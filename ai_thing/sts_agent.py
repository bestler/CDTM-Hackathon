import logging
from dotenv import load_dotenv
from livekit.agents import (
    Agent,
    AgentSession,
    AutoSubscribe,
    JobContext,
    JobProcess,
    WorkerOptions,
    cli,
    metrics,
    RoomInputOptions,
)
from livekit.plugins import (
    noise_cancellation,
    google,
    silero,
)
from livekit.plugins.turn_detector.multilingual import MultilingualModel
import os
import colorama
from colorama import Fore, Style

# Initialize colorama for colored console output
colorama.init()

# Import your GeminiLLM wrapper
from gemini_llm import GeminiLLM

# Load environment variables for the agent
load_dotenv(dotenv_path=".env.local")
logger = logging.getLogger("voice-agent")


class Assistant(Agent):
    def __init__(self) -> None:
        super().__init__(
            instructions="You are a voice assistant created by LiveKit. Your interface with users is voice-based. Use short, concise responses.",
            stt=google.STT(),
            llm=GeminiLLM(),
            tts=google.TTS(),
            turn_detection=MultilingualModel(),
        )
        self.conversation_history = []

    async def on_enter(self):
        test_prompt = "What is the capital of France?"
        print(f"{Fore.YELLOW}Testing LLM with prompt: '{test_prompt}'{Style.RESET_ALL}")
        try:
            gemini_response = self.llm.complete(test_prompt)
            logger.info(f"Gemini LLM Test Response: {gemini_response}")
            print(f"{Fore.GREEN}LLM Test Success: {Style.BRIGHT}{gemini_response}{Style.RESET_ALL}")
        except Exception as e:
            logger.error(f"Gemini LLM Test Failed: {str(e)}")
            print(f"{Fore.RED}LLM Test Failed: {str(e)}{Style.RESET_ALL}")

        self.session.generate_reply(
            instructions="Hey, how can I help you today?", allow_interruptions=True
        )
        print(f"\n{Fore.GREEN}AI Assistant: {Style.BRIGHT}Hey, how can I help you today?{Style.RESET_ALL}")

    async def on_speech_to_text(self, transcript):
        print(f"\n{Fore.BLUE}User: {Style.BRIGHT}{transcript.text}{Style.RESET_ALL}")
        self.conversation_history.append({"role": "user", "content": transcript.text})

        # Add debug information about EOU probability
        eou_probability = getattr(transcript, 'eou_probability', 0)
        print(f"{Fore.YELLOW}Debug: EOU Probability = {eou_probability}{Style.RESET_ALL}")

        # For high EOU probability, force a response generation
        if eou_probability > 0.5:
            try:
                # Force LLM to respond by directly calling it
                print(f"{Fore.YELLOW}Debug: High EOU detected, forcing LLM response{Style.RESET_ALL}")
                response = self.llm.complete(transcript.text)
                print(f"\n{Fore.GREEN}AI Assistant: {Style.BRIGHT}{response}{Style.RESET_ALL}")
                self.conversation_history.append({"role": "assistant", "content": response})
                
                # Also generate TTS if needed (in room mode)
                if hasattr(self.session, 'room') and self.session.room:
                    self.session.reply(text=response)
            except Exception as e:
                print(f"{Fore.RED}Error generating response: {e}{Style.RESET_ALL}")

        return await super().on_speech_to_text(transcript)

    async def on_llm_response(self, prompt, response):
        """Override to log LLM response to console"""
        print(f"\n{Fore.GREEN}AI Assistant (LLM): {Style.BRIGHT}{response}{Style.RESET_ALL}")
        self.conversation_history.append({"role": "assistant", "content": response})
        return await super().on_llm_response(prompt, response)


def prewarm(proc: JobProcess):
    proc.userdata["vad"] = silero.VAD.load()


async def entrypoint(ctx: JobContext):
    logger.info(f"connecting to room {ctx.room.name}")
    await ctx.connect(auto_subscribe=AutoSubscribe.AUDIO_ONLY)

    # Print a welcome message to the console
    print(f"\n{Fore.YELLOW}{Style.BRIGHT}=== Voice Assistant with Console Logging ==={Style.RESET_ALL}")
    print(f"{Fore.YELLOW}Waiting for a participant to join...{Style.RESET_ALL}")

    # Wait for the first participant to connect
    participant = await ctx.wait_for_participant()
    logger.info(f"starting voice assistant for participant {participant.identity}")
    print(f"\n{Fore.YELLOW}Participant {Style.BRIGHT}{participant.identity}{Style.RESET_ALL} {Fore.YELLOW}joined. Starting voice assistant...{Style.RESET_ALL}")

    usage_collector = metrics.UsageCollector()

    # Log metrics and collect usage data
    def on_metrics_collected(agent_metrics: metrics.AgentMetrics):
        metrics.log_metrics(agent_metrics)
        usage_collector.collect(agent_metrics)

    def on_session_end(reason):
        print(f"{Fore.RED}Session ended: {reason}{Style.RESET_ALL}")

    session = AgentSession(
        vad=ctx.proc.userdata["vad"],
        # Reduce these values to make the agent respond faster
        min_endpointing_delay=0.01,  # Changed from 0.5
        max_endpointing_delay=2.0,  # Changed from 5.0
    )

    # Trigger the on_metrics_collected function when metrics are collected
    session.on("metrics_collected", on_metrics_collected)
    session.on("ended", on_session_end)

    await session.start(
        room=ctx.room,
        agent=Assistant(),
        room_input_options=RoomInputOptions(
            # enable background voice & noise cancellation, powered by Krisp
            # included at no additional cost with LiveKit Cloud
            noise_cancellation=noise_cancellation.BVC(),
        ),
    )


if __name__ == "__main__":
    cli.run_app(
        WorkerOptions(
            entrypoint_fnc=entrypoint,
            prewarm_fnc=prewarm,
        ),
    )