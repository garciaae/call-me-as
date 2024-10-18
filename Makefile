include .env
.EXPORT_ALL_VARIABLES:

DOCKER_BUILDKIT=1
COMPOSE_DOCKER_CLI_BUILD=1

COMPOSE_PROJECT_NAME=call-me-as

# Regular call environment variables
ifeq ($(shell [ -f ./studio/.call_flow ] && echo true),true)
	CALL_FLOW_SID=$(shell cat ./studio/.call_flow)
else
    CALL_FLOW_SID=$(DEFAULT_CALL_FLOW_SID)
endif

# Press 1 environment variables
ifeq ($(shell [ -f ./studio/.flow ] && echo true),true)
	PRESS_1_FLOW_SID=$(shell cat ./studio/.press_1_flow)
else
    PRESS_1_FLOW_SID=$(DEFAULT_PRESS_ONE_FLOW_SID)
endif


bash:
	@docker compose -f docker-compose.yml run --rm call-me-as bash

call:
	@docker compose -f docker-compose.yml run --rm call-me-as twilio api:studio:v2:flows:executions:create --flow-sid $(CALL_FLOW_SID) --to $(to) --from $(TWILIO_NUMBER_FROM)

call-press-1:
	@docker compose -f docker-compose.yml run --rm call-me-as twilio api:studio:v2:flows:executions:create --flow-sid $(PRESS_1_FLOW_SID) --to $(to) --from $(TWILIO_NUMBER_FROM)

push-flow:
	@docker compose -f docker-compose.yml run --rm push-flow
