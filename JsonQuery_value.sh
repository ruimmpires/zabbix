#!/bin/bash  
# usage: ./JsonQuery_value.sh <itemid>

curl -s -X POST -H 'Content-Type: application/json' -d '
{
    "jsonrpc": "2.0", 
    "method": "item.get",
    "params": {
        "output":["hostid","itemid","snmp_oid","name","key_","lastvalue","lastclock"],
        "itemids": "'$1'"},
    "id": 1,"auth": "d5087d89aad918e4a9b7ec5425eaa6c1"
}' http://10.32.227.201/zabbix/api_jsonrpc.php | python -mjson.tool 
#| grep value

