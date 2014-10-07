#!/bin/bash

#create docker images
#execute these lines from command line
sudo docker build -t dev24/mongodb mongod
sudo docker build -t dev24/mongos mongos

#create a replica set
sudo docker run --name rs1_srv1 -P -d dev24/mongodb --noprealloc --smallfiles --replSet rs1 --dbpath /data/mongodb --profile=0 --slowms=-1
sudo docker run --name rs1_srv2 -P -d dev24/mongodb --noprealloc --smallfiles --replSet rs1 --dbpath /data/mongodb --profile=0 --slowms=-1
sudo docker run --name rs1_srv3 -P -d dev24/mongodb --noprealloc --smallfiles --replSet rs1 --dbpath /data/mongodb --profile=0 --slowms=-1

#initialize the replica sets
#sudo docker inspect rs1_srv1

#    "Name": "/rs1_srv1",
#    "NetworkSettings": {
#        "Bridge": "docker0",
#        "Gateway": "172.17.42.1",
#        "IPAddress": "172.17.0.2",
#        "IPPrefixLen": 16,
#        "PortMapping": null,
#        "Ports": {
#            "27017/tcp": [
#                {
#                    "HostIp": "0.0.0.0",
#                    "HostPort": "49153"
#                }
#            ]
#        }
#    },

#sudo docker inspect rs1_srv2

#   "Name": "/rs1_srv2",
#    "NetworkSettings": {
#        "Bridge": "docker0",
#        "Gateway": "172.17.42.1",
#        "IPAddress": "172.17.0.3",
#        "IPPrefixLen": 16,
#        "PortMapping": null,
#        "Ports": {
#            "27017/tcp": [
#                {
#                    "HostIp": "0.0.0.0",
#                    "HostPort": "49154"
#                }
#            ]
#        }
#    },

#sudo docker inspect rs1_srv3

#    "Name": "/rs1_srv3",
#    "NetworkSettings": {
#        "Bridge": "docker0",
#        "Gateway": "172.17.42.1",
#        "IPAddress": "172.17.0.4",
#        "IPPrefixLen": 16,
#        "PortMapping": null,
#        "Ports": {
#            "27017/tcp": [
#                {
#                    "HostIp": "0.0.0.0",
#                    "HostPort": "49155"
#                }
#            ]
#        }
#    },

#sudo docker logs rs1_srv1
#sudo docker logs rs1_srv2
#sudo docker logs rs1_srv3

#sudo docker ps
CONTAINER ID        IMAGE                  COMMAND                CREATED              STATUS              PORTS                      NAMES
#7ea80412b31a        dev24/mongodb:latest   usr/bin/mongod --nop   About a minute ago   Up About a minute   0.0.0.0:49155->27017/tcp   rs1_srv3
#613c4f71fa0b        dev24/mongodb:latest   usr/bin/mongod --nop   About a minute ago   Up About a minute   0.0.0.0:49154->27017/tcp   rs1_srv2
#676727c7b9f5        dev24/mongodb:latest   usr/bin/mongod --nop   2 minutes ago        Up 2 minutes        0.0.0.0:49153->27017/tcp   rs1_srv1


#sudo apt-get install mongodb-clients

mongo --port 49153 << 'EOF'
    config = { _id: "rs1", members:[
              { _id : 0, host : "172.17.0.02:27017" },
              { _id : 1, host : "172.17.0.03:27017" },
              { _id : 2, host : "172.17.0.04:27017" }]};
    rs.initiate(config)
EOF

mongo --port 49153 << 'EOF'
    rs.status()
EOF

#MongoDB shell version: 2.4.10
#connecting to: 127.0.0.1:49153/test
#{
#	"set" : "rs1",
#	"date" : ISODate("2014-10-07T20:05:46Z"),
#	"myState" : 1,
#	"members" : [
#		{
#			"_id" : 0,
#			"name" : "172.17.0.02:27017",
#			"health" : 1,
#			"state" : 1,
#			"stateStr" : "PRIMARY",
#			"uptime" : 1045,
#			"optime" : Timestamp(1412712313, 1),
#			"optimeDate" : ISODate("2014-10-07T20:05:13Z"),
#			"self" : true
#		},
#		{
#			"_id" : 1,
#			"name" : "172.17.0.03:27017",
#			"health" : 1,
#			"state" : 2,
#			"stateStr" : "SECONDARY",
#			"uptime" : 33,
#			"optime" : Timestamp(1412712313, 1),
#			"optimeDate" : ISODate("2014-10-07T20:05:13Z"),
#			"lastHeartbeat" : ISODate("2014-10-07T20:05:45Z"),
#			"lastHeartbeatRecv" : ISODate("2014-10-07T20:05:46Z"),
#			"pingMs" : 1,
#			"syncingTo" : "172.17.0.02:27017"
#		},
#		{
#			"_id" : 2,
#			"name" : "172.17.0.04:27017",
#			"health" : 1,
#			"state" : 2,
#			"stateStr" : "SECONDARY",
#			"uptime" : 31,
#			"optime" : Timestamp(1412712313, 1),
#			"optimeDate" : ISODate("2014-10-07T20:05:13Z"),
#			"lastHeartbeat" : ISODate("2014-10-07T20:05:45Z"),
#			"lastHeartbeatRecv" : ISODate("2014-10-07T20:05:45Z"),
#			"pingMs" : 0,
#			"syncingTo" : "172.17.0.02:27017"
#		}
#	],
#	"ok" : 1
#}

#create some config servers
sudo docker run --name cfg1 -P -d dev24/mongodb --noprealloc --smallfiles --configsvr --dbpath /data/mongodb --port 27017 --profile=0 --slowms=-1

#sudo docker inspect cfg1

#   "Name": "/cfg1",
#    "NetworkSettings": {
#        "Bridge": "docker0",
#        "Gateway": "172.17.42.1",
#        "IPAddress": "172.17.0.5",
#        "IPPrefixLen": 16,
#        "PortMapping": null,
#        "Ports": {
#            "27017/tcp": [
#                {
#                    "HostIp": "0.0.0.0",
#                    "HostPort": "49156"
#                }
#            ]
#        }
#    },

#sudo docker logs cfg1
#sudo docker ps

#CONTAINER ID        IMAGE                  COMMAND                CREATED              STATUS              PORTS                      NAMES
#99bbb6790076        dev24/mongodb:latest   usr/bin/mongod --nop   About a minute ago   Up About a minute   0.0.0.0:49156->27017/tcp   cfg1
#7ea80412b31a        dev24/mongodb:latest   usr/bin/mongod --nop   24 minutes ago       Up 23 minutes       0.0.0.0:49155->27017/tcp   rs1_srv3
#613c4f71fa0b        dev24/mongodb:latest   usr/bin/mongod --nop   24 minutes ago       Up 24 minutes       0.0.0.0:49154->27017/tcp   rs1_srv2
#676727c7b9f5        dev24/mongodb:latest   usr/bin/mongod --nop   24 minutes ago       Up 24 minutes       0.0.0.0:49153->27017/tcp   rs1_srv1

#create mongod router
sudo docker run --name mongos1 -P -d dev24/mongos --configdb 172.17.0.14:27017 --port 27017

#sudo docker inspect mongos1

#    "Name": "/mongos1",
#    "NetworkSettings": {
#        "Bridge": "docker0",
#        "Gateway": "172.17.42.1",
#        "IPAddress": "172.17.0.6",
#        "IPPrefixLen": 16,
#        "PortMapping": null,
#        "Ports": {
#            "27017/tcp": [
#                {
#                    "HostIp": "0.0.0.0",
#                    "HostPort": "49157"
#                }
#            ]
#        }
#    },

#sudo docker logs mongos1

#sudo docker ps

#CONTAINER ID        IMAGE                  COMMAND                CREATED             STATUS              PORTS                      NAMES
#787d0e8e8893        dev24/mongos:latest    usr/bin/mongos --con   14 minutes ago      Up 14 minutes       0.0.0.0:49157->27017/tcp   mongos1
#99bbb6790076        dev24/mongodb:latest   usr/bin/mongod --nop   17 minutes ago      Up 17 minutes       0.0.0.0:49156->27017/tcp   cfg1
#7ea80412b31a        dev24/mongodb:latest   usr/bin/mongod --nop   39 minutes ago      Up 39 minutes       0.0.0.0:49155->27017/tcp   rs1_srv3
#613c4f71fa0b        dev24/mongodb:latest   usr/bin/mongod --nop   39 minutes ago      Up 39 minutes       0.0.0.0:49154->27017/tcp   rs1_srv2
#676727c7b9f5        dev24/mongodb:latest   usr/bin/mongod --nop   40 minutes ago      Up 40 minutes       0.0.0.0:49153->27017/tcp   rs1_srv1


mongo 172.17.0.06:27017 << 'EOF'
    sh.addShard("rs1/172.17.0.02:27017")
    sh.status()
EOF

#--- Sharding Status ---
#  sharding version: {
#	"_id" : 1,
#	"version" : 3,
#	"minCompatibleVersion" : 3,
#	"currentVersion" : 4,
#	"clusterId" : ObjectId("5423113d9da4aed3c48c9ac2")
#}
#  shards:
#	{  "_id" : "rs1",  "host" : "rs1/172.17.0.11:27017,172.17.0.12:27017,172.17.0.13:27017" }
#  databases:
#	{  "_id" : "admin",  "partitioned" : false,  "primary" : "config" }


#sudo docker ps -a -q | sudo xargs docker stop | sudo xargs docker rm