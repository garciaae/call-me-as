# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**call-me-as** is a Twilio Studio flow management tool. It deploys personalized call flows to Twilio Studio and triggers outbound calls via the Twilio CLI. There are two flow types:

- **call_flow** — Direct outbound call with speech-to-LLM conversation loop (gather speech → POST to Twilio Function → say response → repeat)
- **press_1_flow** — Same as above but requires the recipient to press 1 before the conversation begins

## Commands

All commands run inside Docker containers. Requires Docker and Docker Compose.

```sh
# Build and start containers
docker compose up --build

# Shell into the Twilio CLI container
make bash

# Deploy personalized flows to Twilio Studio (creates per-developer flows using CUSTOMERIO_ID)
make push-flow

# Make a direct outbound call
make call to=+1XXXXXXXXXX

# Make a "press 1 to connect" outbound call
make call-press-1 to=+1XXXXXXXXXX
```

## Architecture

- **`push_flow.py`** — Python script that reads flow templates from `studio/templates/`, injects the `TWILIO_FUNCTION_URL` into the `http_prompt` state, creates the flows in Twilio Studio via the API, and writes the resulting Flow SIDs to `studio/.call_flow` and `studio/.press_1_flow`.
- **`studio/templates/`** — JSON definitions of Twilio Studio flows. These define the state machines for call handling (trigger → call → gather → HTTP → say → loop).
- **`Makefile`** — Reads Flow SIDs from `studio/.call_flow` and `studio/.press_1_flow` (falling back to `DEFAULT_*_FLOW_SID` env vars) and invokes the Twilio CLI to execute flows.
- **Docker services**:
  - `call-me-as` — Twilio CLI container for executing flows and interactive use
  - `push-flow` — Python 3.11 container that runs `push_flow.py`

## Environment Variables

Copy `env-template` to `.env`. Key variables:

- `TWILIO_ACCOUNT_SID` / `TWILIO_AUTH_TOKEN` — Twilio credentials
- `TWILIO_NUMBER_FROM` — Caller ID (E.164 format)
- `TWILIO_FUNCTION_URL` — Backend URL that handles the conversation (receives speech as POST, returns LLM response)
- `CUSTOMERIO_ID` — Developer identifier used to namespace flow names (e.g., `alejandrogarcia_call_flow`)
- `DEFAULT_CALL_FLOW_SID` / `DEFAULT_PRESS_ONE_FLOW_SID` — Fallback Flow SIDs when personal flows haven't been pushed

## Dependencies

Python deps managed with Poetry (`pyproject.toml`): `twilio` SDK and `python-dotenv`. Python 3.11+.
