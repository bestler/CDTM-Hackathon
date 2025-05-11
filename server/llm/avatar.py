import os

from livekit import agents
from livekit.agents import AgentSession, Agent, RoomInputOptions, RoomOutputOptions
from livekit.plugins import (
    openai,
    google,
    noise_cancellation,
    silero,
    bey
)
from dotenv import load_dotenv

load_dotenv()

class Assistant(Agent):
    def __init__(self) -> None:
        super().__init__(instructions="You are a helpful voice AI assistant.")


async def entrypoint():
    ctx=agents.JobContext()
    await ctx.connect()

    session = AgentSession(
        # llm=openai.realtime.RealtimeModel(voice="alloy"),

        stt=google.STT(),
        llm=openai.LLM(model="gpt-4o-mini"),
        # llm = GeminiLLM(),
        tts = openai.TTS(model="gpt-4o-mini-tts"),
        # tts=google.TTS(),
        vad=silero.VAD.load(),
        # turn_detection=MultilingualModel(),
    )


    avatar_id = "b9be11b8-89fb-4227-8f86-4a881393cbdb"
    bey_avatar = bey.AvatarSession(avatar_id=avatar_id)
    await bey_avatar.start(session, room=ctx.room)
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
            room_output_options=RoomOutputOptions(audio_enabled=False),
        )

    await session.generate_reply(
        instructions="Greet the user and offer your assistance."
    )

async def start():
    worker_options = agents.WorkerOptions(
        entrypoint_fnc=entrypoint, 
        worker_type=agents.WorkerType.ROOM,
        ws_url=os.getenv("LIVEKIT_URL"),
    )

    # You can call the agent directly instead of using cli
    worker = agents.Worker(worker_options)
    
    # Run the worker manually (this is the alternative to cli.run_app)
    await worker.run()