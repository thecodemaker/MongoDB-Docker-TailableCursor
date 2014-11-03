#!/bin/bash

RABBITMQ=`which rabbitmqadmin`
CMD = "${RABBITMQ} --port=5672 --host=localhost --vhost=/ quest quest"

# exchange
$CMD declare exchange name=bus type=topic durable=true

# queue
$CMD declare queue name=documents durable=true

# bindings
$CMD declare binding source=bus destination_type=queue destination=documents routing_key="documents"