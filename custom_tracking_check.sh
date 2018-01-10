client_id=$1
customer_id=$2
dbp=$3

server_name="${dbp}.prod.marinsw.net"

query="

select
$client_id client_id
, case 
when pca.custom_row_map like '%ZeroRevenueAndConversion%' then '1' else '0' end as Custom_Tracking

from marin.clients cl
join marin.publisher_accounts pa on cl.client_id=pa.client_id
join marin.publisher_client_accounts pca on pa.publisher_account_id=pca.publisher_account_id

where
cl.client_id = $client_id

group by 1

"

mysql -h $server_name  -u $user -p$pass -e "$query" -N
