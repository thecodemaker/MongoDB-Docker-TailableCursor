#!/bin/sh

#create docker images
#execute these lines from command line
sudo docker build -t dev0/rabbitmq rabbitmq

sudo docker run --name rabbitmq1 -P -d dev0/rabbitmq

#initialize the rabbitmq node
sudo docker inspect rabbitmq1

#    "Name": "/rabbitmq1",
#    "NetworkSettings": {
#        "Bridge": "docker0",
#        "Gateway": "172.17.42.1",
#        "IPAddress": "172.17.0.21",
#        "IPPrefixLen": 16,
#        "PortMapping": null,
#        "Ports": {
#            "15672/tcp": [
#                {
#                    "HostIp": "0.0.0.0",
#                    "HostPort": "49166"
#                }
#            ],
#            "5672/tcp": [
#                {
#                    "HostIp": "0.0.0.0",
#                    "HostPort": "49167"
#                }
#            ]
#        }
#    }


sudo docker logs rabbitmq1

#              RabbitMQ 3.3.5. Copyright (C) 2007-2014 GoPivotal, Inc.
#  ##  ##      Licensed under the MPL.  See http://www.rabbitmq.com/
#  ##  ##
#  ##########  Logs: /data/log/rabbit@52365ee9c908.log
#  ######  ##        /data/log/rabbit@52365ee9c908-sasl.log
#  ##########
#              Starting broker... completed with 6 plugins.

#sudo docker ps

#TODO
#From rabbit2
# rabbitmqctl stop_app
# rabbitmqctl join_cluster rabbit@rabbit1
# rabbitmqctl start_app
#
#rabbitmqctl cluster_status
#Cluster status of node rabbit@rabbit2 ...
#[{nodes,[{disc,[rabbit@rabbit1]},{ram,[rabbit@rabbit2]}]},{running_nodes,[rabbit@rabbit2,rabbit@rabbit1]}]

#amqp://guest@HOST_IP:49xxx

#sudo docker ps -a -q | sudo xargs docker stop | sudo xargs docker rm