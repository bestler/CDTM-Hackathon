# intake_flow.py
"""Backend flow for collecting missing patient information via an avatar interface.

Revision: **English‑only conversation**
-------------------------------------
* `LLMQuestionClient` prompt now requests an English question.
* All fallback messages, confirmations, and skip prompts are in English.
* No logic changes – you only need to wire real API calls.
"""

from __future__ import annotations

import asyncio
from typing import Any, Dict, List, Tuple

###############################################################################
# ── External‑API wrapper stubs ────────────────────────────────────────────────
###############################################################################

class MistralSpeechClient:
    """Minimal async wrapper around your Mistral speech‑to‑text endpoint."""

    async def transcribe(self, audio_path: str) -> str:  # pragma: no cover
        raise NotImplementedError  # TODO: implement HTTP / SDK call


class GeminiVisionClient:
    """Minimal async wrapper around your Gemini image‑to‑text / OCR endpoint."""

    async def extract_text(self, image_path: str) -> str:  # pragma: no cover
        raise NotImplementedError  # TODO: implement HTTP / SDK call


class AvatarVideoClient:
    """Wrapper for the text‑to‑video avatar that speaks to the user."""

    async def speak(self, text: str) -> None:  # pragma: no cover
        raise NotImplementedError  # TODO: implement streaming back to the FE


class LLMQuestionClient:
    """Generate a concise, polite question in English for a missing field."""

    SYSTEM_PROMPT = (
        "You are a clinical intake assistant. Given a JSON field name, "
        "generate one concise, polite question in English that you would ask "
        "a patient to fill that field. The question must ONLY ask for the "
        "information, with no additional commentary."
    )

    async def ask(self, field_path: str) -> str:  # pragma: no cover
        """Call your preferred LLM (Mistral, OpenAI, etc.) to get a question."""
        # Example (commented):
        # response = await openai.ChatCompletion.acreate(
        #     model="gpt-4o-mini",
        #     messages=[
        #         {"role": "system", "content": self.SYSTEM_PROMPT},
        #         {"role": "user", "content": field_path},
        #     ],
        # )
        # return response.choices[0].message.content.strip()
        raise NotImplementedError

###############################################################################
# ── Mandatory fields and helpers ─────────────────────────────────────────────
###############################################################################

REQUIRED_FIELDS: List[str] = [
    "name",
    "date_of_birth",
    "insurance_card.provider",
    "insurance_card.number",
    "vaccination_pass",
    "symptoms",
]


def get_missing_fields(record: Dict[str, Any]) -> List[str]:
    return [f for f in REQUIRED_FIELDS if _field_is_missing(record, f)]


def _field_is_missing(record: Dict[str, Any], dotted_path: str) -> bool:
    node: Any = record
    for key in dotted_path.split('.'):
        if not isinstance(node, dict) or key not in node:
            return True
        node = node[key]
    return node in (None, '', [])


def set_field(record: Dict[str, Any], dotted_path: str, value: Any) -> None:
    parts = dotted_path.split('.')
    node = record
    for key in parts[:-1]:
        node = node.setdefault(key, {})
    node[parts[-1]] = value

###############################################################################
# ── Conversation state machine ───────────────────────────────────────────────
###############################################################################

class IntakeSession:
    """Manage one avatar‑guided data‑collection session for a single patient."""

    def __init__(
        self,
        patient_record: Dict[str, Any],
        speech_client: MistralSpeechClient,
        vision_client: GeminiVisionClient,
        avatar_client: AvatarVideoClient,
        question_client: LLMQuestionClient,
    ) -> None:
        self.patient_record = patient_record
        self.speech_client = speech_client
        self.vision_client = vision_client
        self.avatar = avatar_client
        self.q_gen = question_client

    # ────────────────────────────────────────────────────────────────────────
    async def run(self) -> Dict[str, Any]:
        while True:
            missing = get_missing_fields(self.patient_record)
            if not missing:
                await self.avatar.speak("Thank you — we now have all the information we need.")
                return self.patient_record

            field = missing[0]
            resolved = await self._query_field(field)
            if not resolved:  # user skipped → move to end of queue
                missing.append(missing.pop(0))

    # ────────────────────────────────────────────────────────────────────────
    async def _query_field(self, field: str) -> bool:
        prompt = await self._build_prompt(field)
        await self.avatar.speak(prompt)

        kind, payload = await self._await_user_input()

        if kind == 'text':
            if payload.strip().lower() in {'skip', 'later', 'ignore', 'next'}:
                await self.avatar.speak("No problem, we can come back to that later.")
                return False
            self._store_answer(field, payload)
            return True

        if kind == 'speech':
            transcript = (await self.speech_client.transcribe(payload)).strip().lower()
            if transcript in {'skip', 'later', 'ignore', 'next'}:
                await self.avatar.speak("No problem, we can come back to that later.")
                return False
            self._store_answer(field, transcript)
            return True

        if kind == 'image':
            extracted = await self.vision_client.extract_text(payload)
            self._store_answer(field, extracted)
            return True

        # Fallback
        await self.avatar.speak("I'm sorry, I didn't understand that. Could you please try again?")
        return await self._query_field(field)

    # --------------------------------------------------------------------
    async def _build_prompt(self, field: str) -> str:
        try:
            return await self.q_gen.ask(field)
        except NotImplementedError:
            # Simple fallback from field path
            human = field.replace('_', ' ').replace('.', ' – ')
            return f"Please provide {human}."

    # --------------------------------------------------------------------
    def _store_answer(self, field: str, value: Any) -> None:
        set_field(self.patient_record, field, value)

    # --------------------------------------------------------------------
    async def _await_user_input(self) -> Tuple[str, Any]:  # pragma: no cover
        """Hook this into your websocket / event loop to receive user responses."""
        raise NotImplementedError

###############################################################################
# ── Example usage ────────────────────────────────────────────────────────────
###############################################################################

if __name__ == '__main__':
    async def _demo() -> None:
        patient = {'id': 'demo‑123'}
        session = IntakeSession(
            patient_record=patient,
            speech_client=MistralSpeechClient(),
            vision_client=GeminiVisionClient(),
            avatar_client=AvatarVideoClient(),
            question_client=LLMQuestionClient(),
        )
        try:
            await session.run()
        except NotImplementedError:
            print('⚠️  Stubbed components — wire up real APIs to run the full flow.')

    asyncio.run(_demo())
