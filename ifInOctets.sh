#!/bin/bash  
# usage: script <itemid>

curl -s -X POST -H 'Content-Type: application/json' -d '
{
    "jsonrpc": "2.0", 
    "method": "item.get",
    "params": {
        "output":["hostid","itemid","snmp_oid","name","key_","lastvalue","lastclock"],
        "itemids": "'$1'"},
    "id": 1,"auth": "500b3e28e2dcffa38006f44cca6f8a19"
}' http://10.32.227.201/zabbix/api_jsonrpc.php | python -mjson.tool | grep value

