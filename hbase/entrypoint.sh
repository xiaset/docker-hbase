#!/bin/bash

# Set some sensible defaults
#export CORE_CONF_fs_defaultFS=${CORE_CONF_fs_defaultFS:-hdfs://`hostname -f`:8020}

function addProperty() {
  local path=$1
  local name=$2
  local value=$3

  local entry="<property><name>$name</name><value>${value}</value></property>"
  local escapedEntry=$(echo $entry | sed 's/\//\\\//g')
  sed -i "/<\/configuration>/ s/.*/${escapedEntry}\n&/" $path
}

function configure() {
    local path=$1
    local module=$2
    local envPrefix=$3

    local var
    local value
    
    echo "Configuring $module"
    for c in `printenv | perl -sne 'print "$1 " if m/^${envPrefix}_(.+?)=.*/' -- -envPrefix=$envPrefix`; do 
        name=`echo ${c} | perl -pe 's/___/-/g; s/__/_/g; s/_/./g'`
        var="${envPrefix}_${c}"
        value=${!var}
        echo " - Setting $name=$value"
        addProperty /opt/hbase/conf/$module-site.xml $name "$value"
    done
}

configure /opt/hbase/conf/hbase-site.xml hbase HBASE_CONF
#configure /etc/hadoop/hdfs-site.xml hdfs HDFS_CONF
#configure /etc/hadoop/yarn-site.xml yarn YARN_CONF
#configure /etc/hadoop/httpfs-site.xml httpfs HTTPFS_CONF
#configure /etc/hadoop/kms-site.xml kms KMS_CONF

#if [ "$MULTIHOMED_NETWORK" = "1" ]; then
#    echo "Configuring for multihomed network"
#
#    # HDFS
#    addProperty /etc/hadoop/hdfs-site.xml dfs.namenode.rpc-bind-host 0.0.0.0
#    addProperty /etc/hadoop/hdfs-site.xml dfs.namenode.servicerpc-bind-host 0.0.0.0
#    addProperty /etc/hadoop/hdfs-site.xml dfs.namenode.http-bind-host 0.0.0.0
#    addProperty /etc/hadoop/hdfs-site.xml dfs.namenode.https-bind-host 0.0.0.0
#    addProperty /etc/hadoop/hdfs-site.xml dfs.client.use.datanode.hostname true
#    addProperty /etc/hadoop/hdfs-site.xml dfs.datanode.use.datanode.hostname true
#
#    # YARN
#    addProperty /etc/hadoop/yarn-site.xml yarn.resourcemanager.bind-host 0.0.0.0
#    addProperty /etc/hadoop/yarn-site.xml yarn.nodemanager.bind-host 0.0.0.0
#    addProperty /etc/hadoop/yarn-site.xml yarn.nodemanager.bind-host 0.0.0.0
#    addProperty /etc/hadoop/yarn-site.xml yarn.timeline-service.bind-host 0.0.0.0
#
#    # MAPRED
#    addProperty /etc/hadoop/mapred-site.xml yarn.nodemanager.bind-host 0.0.0.0
#fi
curl --user reader:reader -H "X-Requested-By: ambari" -X GET http://$AMBARI_HOST/api/v1/clusters/$AMBARI_HDFS_CLUSTER_NAME/services/HDFS/components/HDFS_CLIENT?format=client_config_tar -o /opt/hbase/conf/hdfs_config.tar.gz
cd /opt/hbase/conf
tar -xf /opt/hbase/conf/hdfs_config.tar.gz

export HBASE_CONF_DIR=/opt/hbase/conf
export JAVA_HOME=/usr/lib/jvm/java-8-oracle
export HBASE_HEAPSIZE=8000
export HBASE_REGIONSERVER_OPTS="$HBASE_REGIONSERVER_OPTS -Xms8G -Xmx8g"
export HBASE_MANAGES_ZK=false
export HBASE_OPTS="$HBASE_OPTS -Xgcthreads2 -Xalwaysclassgc -Xms8192m -Xmx8192m -Xgcpolicy:balanced"

exec $@

