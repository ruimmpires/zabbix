#!/bin/bash  
# readme:
# usage: ./JsonQuery_all_items.sh <IP> 
#        First you need to establish a connection with the server and replace the auth code below
#        output: zabbix_all_items_<IP>.json
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
            "key_",
            "lastvalue"
        ],
"sortfield": "itemid"
    },
    "id": 1,
    "auth": "678bfc852fa3d0be91bb322f2eb8c5d3"
}' http://$1/zabbix/api_jsonrpc.php | python -mjson.tool > zabbix_all_items_$1.json

#echo usage: script <hostid>
echo returned all values of all items, oids, names and values of the server
echo check the output zabbix_all_items_$1.json
echo you may use the online tool https://json-csv.com/
echo here is the tail of the output file
tail zabbix_all_items_$1.json
