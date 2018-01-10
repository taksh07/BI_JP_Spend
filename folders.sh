client_id=$1
customer_id=$2
dbp=$3


server_name="${dbp}.prod.marinsw.net"
kif="marin_olap_staging.keyword_instance_fact_${customer_id}_${client_id}"
kid="marin_olap_staging.keyword_instance_dim_${customer_id}_${client_id}"

 query="

SELECT
$client_id client_id
, cl.client_name
, f.folder_name
, f.bid_parameters as Folder_Goal
, sum(kif.publisher_cost)/sum(kif.conversions)as CPA
, f.specified_rev_per_conv as CPA_Target
, f.bid_target_method as Targets
, f.margin as Marin_Percent
, 1/(1-f.margin/100) ROAS_target
, case when pbc.northmost_position is null then 0 else pbc.northmost_position end as High_Position_Target
, case when pbc.southmost_position is null then 0 else pbc.southmost_position end as Low_Position_Target
FROM
${kif} kif
JOIN ${kid} kid on kif.keyword_instance_dim_id=kid.keyword_instance_dim_id
LEFT JOIN marin.folders f on kid.folder_id=f.folder_id
LEFT JOIN marin.position_bidding_context pbc on f.folder_id=pbc.folder_id
JOIN marin.clients cl on f.client_id=cl.client_id
WHERE
f.bid_system='Traffic'
AND
kif.time_id BETWEEN DATEDIFF($start_date,'2004-12-31') AND DATEDIFF($end_date,'2004-12-31')

GROUP BY 1,2,3,4,6,7,8,9,10,11

"
mysql -h $server_name -u $user -p$pass -e "$query" -N
