#!/bin/bash  
# readme:
# usage: ./JsonQuery_all_itemid.sh <hostid>
#        First need to establish a connectoin with the server and replace the auth code below
#        output: zabbix_item.get_host.id_$1.json
#        more info at https://confluence.int.net.nokia.com/display/RSCON/Zabbix

curl -s -X POST -H 'Content-Type: application/json' -d '
{
    "jsonrpc": "2.0",
    "method": "item.get",
    "params": {
        "output":
[
            "hostid",
            "itemid",
            "snmp_oid",
            "name",
            "key_",
            "lastvalue"
        ],
"hostids": "'$1'",
"sortfield": "key_"
    },
    "id": 1,
    "auth": "678bfc852fa3d0be91bb322f2eb8c5d3"
}' http://10.32.227.201/zabbix/api_jsonrpc.php | python -mjson.tool > zabbix_item.get_host.id_$1.json

#echo usage: script <hostid>
echo returned all itemids, oids, names and values of the hostid in the file zabbix_item.get_host.id_$1.json
