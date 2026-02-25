# Call Me As

A Twilio Studio flow management tool that deploys personalized call flows and triggers outbound calls via the Twilio CLI. It connects recipients to an LLM-powered conversation through a speech-to-text loop: the call gathers speech, sends it to a backend function, and plays back the LLM response.

## Flow Types

- **call_flow** — Direct outbound call that starts the LLM conversation immediately.
- **press_1_flow** — Same as above, but requires the recipient to press 1 before the conversation begins.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/)
- A Twilio account with Studio and a phone number

## Setup

1. Clone the repository:
   ```sh
   git clone git@github.com:garciaae/call-me-as.git
   cd call-me-as
   ```

2. Create and configure the `.env` file:
   ```sh
   cp env-template .env
   ```
   Fill in the required values (see [Environment Variables](#environment-variables)).

3. Build and start the containers:
   ```sh
   docker compose up --build
   ```

## Usage

### Deploy personalized flows

Push your own flows to Twilio Studio, namespaced by your `CUSTOMERIO_ID`:

```sh
make push-flow
```

Output example:
```
New Flow SID (alejandrogarcia_press_1_flow): FW532be50f3ede1d3c76c6e552e2f12345
New Flow SID (alejandrogarcia_call_flow): FW2a6102d0a5b13297856ae4c526d67890
```

This is optional but strongly recommended so your flows don't conflict with other developers.

### Make a call

```sh
# Direct call
make call to=+1XXXXXXXXXX

# Press 1 to connect
make call-press-1 to=+1XXXXXXXXXX
```

### Shell into the container

```sh
make bash
```

## Environment Variables

| Variable | Description |
|---|---|
| `TWILIO_ACCOUNT_SID` | Twilio account SID ([console](https://www.twilio.com/console)) |
| `TWILIO_AUTH_TOKEN` | Twilio auth token |
| `TWILIO_NUMBER_FROM` | Caller ID in E.164 format (e.g., `+1234567890`) |
| `DEFAULT_NUMBER_TO` | Default destination number |
| `TWILIO_FUNCTION_URL` | Backend URL that handles the conversation (receives speech via POST, returns LLM response) |
| `CUSTOMERIO_ID` | Developer identifier used to namespace flow names |
| `DEFAULT_CALL_FLOW_SID` | Fallback Flow SID for direct calls |
| `DEFAULT_PRESS_ONE_FLOW_SID` | Fallback Flow SID for press-1 calls |

## Architecture

```
studio/templates/          Flow JSON definitions (state machines)
        ├── call_flow.json
        └── press_1_flow.json
push_flow.py               Reads templates, injects TWILIO_FUNCTION_URL, deploys to Studio API
Makefile                   Reads Flow SIDs and invokes Twilio CLI to execute calls
docker-compose.yml         Two services:
        ├── call-me-as     Twilio CLI container
        └── push-flow      Python 3.11 container that runs push_flow.py
```

### Call flow sequence

```
Trigger → Call → Gather Speech → HTTP POST to backend → Say LLM response → Loop
```
