client_id=$1
customer_id=$2
dbp=$3

server_name="${dbp}.prod.marinsw.net"

query="
select 
$client_id client_id
, count(case when p.publisher_id=4 then pca.alias end) as Google_PCA_Linked
, count(case when p.publisher_id=9 then pca.alias end) as YJP_PCA_Linked
, count(case when p.publisher_id=13 then pca.alias end) as YDN_PCA_Linked

from marin.publisher_client_accounts pca
join marin.publisher_accounts pa ON pca.publisher_account_id = pa.publisher_account_id
join marin.publishers p on pa.publisher_id = p.publisher_id

where
pa.client_id = $client_id

"

mysql -h $server_name -u $user -p$pass -e "$query" -N
