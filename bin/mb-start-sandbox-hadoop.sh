#!/bin/bash
/opt/cloudera/parcels/CDH/bin/zookeeper-server start

# start hdfs services
cd /opt/cloudera/parcels/CDH/lib/hadoop-hdfs/bin/
su hdfs -c "nohup hdfs namenode > /var/log/hadoop-hdfs-namenode.log 2>&1 &"
sleep 30s
su hdfs -c "nohup hdfs secondarynamenode > /var/log/hadoop-hdfs-secondarynamenode.log 2>&1 &"
sleep 30s
su hdfs -c "nohup hdfs datanode > /var/log/hadoop-hdfs-datanode.log 2>&1 &"
sleep 30s

# start hbase
su hdfs -c "nohup /opt/cloudera/parcels/CDH/bin/hbase master start > /var/log/hbase-master.log 2>&1 &"
su hdfs -c "nohup /opt/cloudera/parcels/CDH/bin/hbase regionserver start > /var/log/hbase-regionserver.log 2>&1 &"

# start yarn services
su hdfs -c "nohup /opt/cloudera/parcels/CDH/bin/yarn timelineserver start > /var/log/yarn-timelineserver.log 2>&1 &"
su hdfs -c "nohup /opt/cloudera/parcels/CDH/bin/yarn nodemanager start > /var/log/yarn-nodemanager.log 2>&1 &"
su hdfs -c "nohup /opt/cloudera/parcels/CDH/bin/yarn resourcemanager start > /var/log/yarn-resourcemanager.log 2>&1 &"
