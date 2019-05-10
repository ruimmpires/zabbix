#!/bin/bash  
# readme:
# usage: ./Rest_Remove_Discovered_Hosts.sh <IP>
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


#Asks zabbix for the all the hosts in the group discovered hosts
curl -s -X POST -H 'Content-Type: application/json' -d '
{
    "jsonrpc": "2.0", "method": "hostgroup.get",
    "params": {"output": "hostid","selectHosts": ["host"],
    "filter": {"name": ["Discovered hosts"]}
    },"id": 1, "auth": "'$a'"
}' http://10.32.227.201/zabbix/api_jsonrpc.php | python -mjson.tool  > hostlist_discovered_hosts_$1.json

hostlist=$(grep -oP '(?<=hostid":\s")[0-9]+' hostlist_discovered_hosts_$1.json)
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

#delete the hosts in the list list_discovered_host_ids.lst
for (( i=1; i<$l+1; i++ )); do (
curl -s -X POST -H 'Content-Type: application/json' -d '
{
    "jsonrpc": "2.0",
    "method": "host.delete",
    "params": ["'${h[i]}'"],
    "auth": "'$a'",
    "id": 1
}' http://$1/zabbix/api_jsonrpc.php | python -mjson.tool; 
echo Deleted hostid ${h[$i]} listed in the file hostlist_discovered_hosts_$1.json); done
