#!/bin/bash  
# readme:
# usage: ./RestQuery_Template_ServerMonitoring.sh <IP>
#        output: one json file per host id wich is mapped to the Template ServerMonitoring 
#        more info at https://confluence.int.net.nokia.com/display/RSCON/Zabbix

function pause(){
   read -p "$*"
}
 


#USER LOGIN
#To be improved and only do the user login when failing the query
a=$(curl -s -X POST -H 'Content-Type: application/json' -d '
{
    "jsonrpc": "2.0","method": "user.login",
    "params": {"user": "Admin","password": "zabbix"},            
    "id": 1,"auth": null
}' http://$1/zabbix/api_jsonrpc.php | python -mjson.tool | grep -oPw '(?<=result":\s")[^"]+')
echo login to $1 done with result $a
#pause 'Press [Enter] key to continue...'


#FINDS THE TEMPLATE ID
t=$(curl -s -X POST -H 'Content-Type: application/json' -d '
{
    "jsonrpc": "2.0", "method": "template.get",
    "params": {"output": ["host"],
    "filter": {"host": ["Template ServerMonitoring"]}
    },"id": 1, "auth": "'$a'"
}' http://$1/zabbix/api_jsonrpc.php | python -mjson.tool | grep -oP '(?<=templateid":\s")[0-9]+')
echo TemplateID is $t
#pause 'Press [Enter] key to continue...'

#LISTS HOSTIDS, HOSTNAMES AND IPS OF THE HOSTS MAPPED TO THE TEMPLATE
curl -s -X POST -H 'Content-Type: application/json' -d '
{
    "jsonrpc": "2.0", "method": "host.get",
    "params": {"output": ["hostid", "host", "itemids"],"selectInterfaces": ["ip"], "templateids":"'$t'"},
    "id": 1,"auth": "'$a'"
}' http://$1/zabbix/api_jsonrpc.php | python -mjson.tool > RestQuery_Template_ServerMonitoring_hosts_list_$1.json 
hostlist=$(grep -oP '(?<=hostid":\s")[0-9]+' RestQuery_Template_ServerMonitoring_hosts_list_$1.json)
echo Hoslist $hostlist
echo $hostlist > hostlist

#COUNTS THE NUMBER OF HOSTS AND TRANSFORMS THE LIST INTO AN ARRAY
declare -a h
l=$(wc -w hostlist | awk '{print $1}')
echo There are $l hosts
for ((i=1; i<$l+1; i++)); do h[i]=$(awk '{print $'$i'}' hostlist) ; done
#pause 'Press [Enter] key to continue...'

# TEST output for checking the new array ${h[*]}
#for (( i=0; i<$l+1; i++ )); do echo hostlist[$i] ${hostlist[$i]}; done
#for (( i=1; i<$l+1; i++ )); do echo h[$i] ${h[$i]}; done
#pause 'Press [Enter] key to continue...'

#QUERIES THE SERVER FOR ALL ITEMS OF EACH HOSTID
for (( i=1; i<$l+1; i++ )); do (
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
"hostids": "'${h[i]}'",
"sortfield": "key_"
    },
    "id": 1,
    "auth": "'$a'"
}' http://$1/zabbix/api_jsonrpc.php | python -mjson.tool > RestQuery_Template_ServerMonitoring_$1_hostid_${h[i]}.json; 
echo Returned all itemids, oids, names and values of the hostid in the file RestQuery_Template_ServerMonitoring_$1_hostid_${h[i]}.json); done
