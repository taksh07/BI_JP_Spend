client_id=$1
customer_id=$2
dbp=$3

server_name="dbp-mc-reports.prod.marinsw.net"

query="

select
$client_id client_id
, c.company_name

from
marin_common.client_dim cd
join marin_common.customers c on cd.customer_id=c.customer_id

where
cd.client_id = $client_id

group by 1

"
mysql -h $server_name -u $user -p$pass -e "$query" -N
