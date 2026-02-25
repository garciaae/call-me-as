from __future__ import annotations

import json
import os
from typing import Any

from dotenv import load_dotenv
from twilio.rest import Client
from twilio.rest.studio.v2.flow import FlowInstance

# Load environment variables from .env file up 3 directories
load_dotenv()

account_sid: str | None = os.getenv('TWILIO_ACCOUNT_SID')
auth_token: str | None = os.getenv('TWILIO_AUTH_TOKEN')
developer_name: str | None = os.getenv('CUSTOMERIO_ID')
function_url: str | None = os.getenv('TWILIO_FUNCTION_URL')

templates_flows: zip[tuple[str, str]] = zip(
    ('studio/templates/press_1_flow.json', 'studio/templates/call_flow.json'),
    ('press_1_flow', 'call_flow'),
)

client: Client = Client(account_sid, auth_token)

for flow_path, flow_suffix_name in templates_flows:
    with open(flow_path, 'r') as json_file:
        flow_definition: dict[str, Any] = json.load(json_file)

    for state in flow_definition.get('states', []):
        if state.get('name') == 'http_prompt' and state.get('type') == 'make-http-request':
            # Replace the "url" field with the function URL from the .env file
            state['properties']['url'] = function_url
            break

    flow_name: str = f'{developer_name if developer_name else "default"}_{flow_suffix_name}'

    # Create a new flow in Twilio Studio using the JSON definition
    new_flow: FlowInstance = client.studio.v2.flows.create(
        friendly_name=flow_name,
        status=FlowInstance.Status.PUBLISHED,
        definition=flow_definition
    )

    print(f'New Flow SID ({flow_name}): {new_flow.sid}')

    with open(f'/studio/.{flow_suffix_name}', 'w') as flow_file:
        flow_file.write(new_flow.sid)
