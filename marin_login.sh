client_id=$1
customer_id=$2
dbp=$3

server_name="dbp-mc-reports.prod.marinsw.net"


query="
select
$client_id client_id
#,the_year
#,the_month
, sum(login_num) login_num

from
(
select
a.client_id
, c.email
, te.the_month
, te.the_year
, count(*)  click_num
, 0 as login_num


from 
marin_common.user_actions_log a 
join marin_common.users c on c.user_id=a.user_id
join marin_common.time_by_day_epoch te on a.time_id=te.time_id

where 
te.time_id between DATEDIFF($start_date,'2004-12-31') and DATEDIFF($end_date,'2004-12-31')
and a.client_id=$client_id
and a.user_id in  (select user_id from marin_common.users where customer_id=$customer_id) 

group by 1,2,3,4


union all


select
a.client_id
, c.email
, te.the_month
, te.the_year
, 0 as click_num
, count(*)  login_num


from 
marin_common.user_actions_log a 
join marin_common.users c on c.user_id=a.user_id
join marin_common.time_by_day_epoch te on a.time_id=te.time_id

where 
te.time_id between DATEDIFF($start_date,'2004-12-31') and DATEDIFF($end_date,'2004-12-31')
and a.client_id=$client_id
and a.user_id in  (select user_id from marin_common.users where customer_id=$customer_id) 
and a.controller='home'

group by 1,2,3,4

)x

group by 1
"




  mysql -h $server_name -u $user -p$pass -e "$query" -N


