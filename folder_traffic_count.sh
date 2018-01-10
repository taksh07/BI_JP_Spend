client_id=$1
customer_id=$2
dbp=$3

server_name="${dbp}.prod.marinsw.net"

query="

select
$client_id client_id
, count(case
when fl.bid_system='Traffic' then fl.bid_system else 'null' end) as Traffic_count

from
marin.folders fl 
where fl.client_id = $client_id

group by 1
"

mysql -h $server_name  -u $user -p$pass -e "$query" -N
