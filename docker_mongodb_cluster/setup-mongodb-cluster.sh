#!/bin/bash

docker ps -a -q | xargs docker stop | xargs docker rm

#create docker images
#execute these lines from command line
docker build -t dev0/mongodb mongod
docker build -t dev0/mongos mongos

#create a replica set
docker run --name rs1_srv1 -P -d dev0/mongodb --noprealloc --smallfiles --replSet rs1 --dbpath /data/mongodb --profile=0 --slowms=-1
docker run --name rs1_srv2 -P -d dev0/mongodb --noprealloc --smallfiles --replSet rs1 --dbpath /data/mongodb --profile=0 --slowms=-1
docker run --name rs1_srv3 -P -d dev0/mongodb --noprealloc --smallfiles --replSet rs1 --dbpath /data/mongodb --profile=0 --slowms=-1

ip_rs1_srv1=$(docker inspect rs1_srv1 | grep IPAddress | cut -d '"' -f 4)
ip_rs1_srv2=$(docker inspect rs1_srv2 | grep IPAddress | cut -d '"' -f 4)
ip_rs1_srv3=$(docker inspect rs1_srv3 | grep IPAddress | cut -d '"' -f 4)

#sudo apt-get install mongodb-clients

sleep 5

mongo --port $(docker port rs1_srv1 27017|cut -d ":" -f2) <<EOF
    config = { _id: "rs1", members:[
              { _id : 0, host : "${ip_rs1_srv1}:27017" },
              { _id : 1, host : "${ip_rs1_srv2}:27017" },
              { _id : 2, host : "${ip_rs1_srv3}:27017" }]};
    rs.initiate(config)
EOF

sleep 30

mongo --port $(docker port rs1_srv1 27017|cut -d ":" -f2) <<EOF
    rs.status()
EOF

#create some config servers
docker run --name cfg1 -P -d dev0/mongodb --noprealloc --smallfiles --configsvr --dbpath /data/mongodb --port 27017 --profile=0 --slowms=-1
ip_cfg1=$(docker inspect cfg1 | grep IPAddress | cut -d '"' -f 4)

sleep 5

#create mongod router
docker run --name mongos1 -P -d dev0/mongos --configdb "${ip_cfg1}:27017" --port 27017
ip_mongos1=$(docker inspect mongos1 | grep IPAddress | cut -d '"' -f 4)

sleep 5

mongo "${ip_mongos1}:27017" <<EOF
    sh.addShard("rs1/${ip_rs1_srv1}:27017")
    sh.status()
EOF

sleep 5

echo "Mongos IP: ${ip_mongos1}"