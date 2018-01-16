client_id=$1
customer_id=$2
dbp=$3

server_name="${dbp}.prod.marinsw.net"
kif="marin_olap_staging.keyword_instance_fact_${customer_id}_${client_id}"
kid="marin_olap_staging.keyword_instance_dim_${customer_id}_${client_id}"

query="

SELECT
$client_id client_id
, DATE(MAX(spend.Google)) as Google_Last
, DATE(MAX(spend.YJP)) as YJP_Last
, DATE(MAX(spend.YDN)) as YDN_Last
FROM
(SELECT
CASE WHEN kid.publisher_id = 4 AND kif.impressions > 0 THEN te.the_date end as Google
, CASE WHEN kid.publisher_id = 9 AND kif.impressions > 0 THEN te.the_date end as YJP
, CASE WHEN kid.publisher_id = 13 and kif.impressions > 0 THEN te.the_date end as YDN
FROM
${kif} kif
JOIN ${kid} kid on kif.keyword_instance_dim_id=kid.keyword_instance_dim_id
JOIN marin.time_by_day_epoch te on kif.time_id=te.time_id
WHERE
kif.time_id BETWEEN DATEDIFF($start_date,'2004-12-31') AND DATEDIFF($end_date,'2004-12-31')

GROUP BY 1,2,3) as spend


"

mysql -h $server_name  -u $user -p$pass -e "$query" -N

