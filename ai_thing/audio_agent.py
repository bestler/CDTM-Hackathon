from dotenv import load_dotenv

from livekit import agents
from livekit.agents import AgentSession, Agent, RoomInputOptions, RoomOutputOptions, ModelSettings
from livekit.plugins import (
    openai,
    google,
    noise_cancellation,
    silero,
    bey
)
from livekit.plugins.turn_detector.multilingual import MultilingualModel

from gemini_llm import GeminiLLM
from typing import AsyncIterable, AsyncGenerator
from livekit.agents import stt
 
from livekit import rtc
load_dotenv()


class Assistant(Agent):
    def __init__(self) -> None:
        super().__init__(instructions="""
            Initiate it on your own and say exactly the following to the patient:
            "Can you tell me about any previous diagnoses, treatments, or important medical documents you’ve received 
            in the past—like doctor’s letters or reports? Just speak freely, and I’ll make sure your doctor gets a clear summary.
            If the patient wants to end the conversation, then say: "Thank you for sharing that information.
            """)
    
    async def stt_node(
        self, audio: AsyncIterable[rtc.AudioFrame], model_settings: ModelSettings
    ) -> AsyncGenerator[stt.SpeechEvent, None]:
        # Call the default implementation
        async for event in Agent.default.stt_node(self, audio, model_settings):
            for txt in event.alternatives:
                print(txt.text)

            # if event.is_final:
            #     print("🗣 Final transcript:", event.text)
            # else:
            #     print("⏳ Partial transcript:", event.text)

            yield event



async def entrypoint(ctx: agents.JobContext):
    await ctx.connect()

    session = AgentSession(
        # llm=openai.realtime.RealtimeModel(voice="alloy"),

        stt=google.STT(),
        llm=openai.LLM(model="gpt-4o-mini"),
        # llm = GeminiLLM(),
        tts = openai.TTS(model="gpt-4o-mini-tts"),
        # tts=google.TTS(),
        vad=silero.VAD.load(),
        turn_detection=MultilingualModel(),
    )


    avatar_id = "b9be11b8-89fb-4227-8f86-4a881393cbdb"
    bey_avatar = bey.AvatarSession(avatar_id=avatar_id)
    # await bey_avatar.start(session, room=ctx.room)
    # avatar = bey.AvatarSession(avatar_id = avatar_id, avatar_participant_name="öklasdjf") # avatar_id=avatar_id, avatar_participant_identity="assistant", avatar_participant_name="Assistant"
    # await avatar.start(session, room=ctx.room)

    print(f"Joining room: {ctx.room.name}")

    await session.start(
            agent=Assistant(),
            room=ctx.room,
            room_input_options=RoomInputOptions(
                # LiveKit Cloud enhanced noise cancellation
                # - If self-hosting, omit this parameter
                # - For telephony applications, use `BVCTelephony` for best results
                noise_cancellation=noise_cancellation.BVC(), 
            ),
            # room_output_options=RoomOutputOptions(audio_enabled=False),
        )

    await session.generate_reply(
        instructions="""
            Initiate it on your own and say exactly the following to the patient:
            "Can you tell me about any previous diagnoses, treatments, or important medical documents you’ve received in the past—like doctor’s letters or reports? Just speak freely, and I’ll make sure your doctor gets a clear summary"
            """
    )
    



if __name__ == "__main__":
    agents.cli.run_app(agents.WorkerOptions(entrypoint_fnc=entrypoint)) #  worker_type=agents.WorkerType.ROOM, agent_name="assistant"