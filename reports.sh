client_id=$1
customer_id=$2
dbp=$3


server_name="${dbp}.prod.marinsw.net"


 query="
select
$client_id client_id
#,count(distinct name) report_num
,sum(daily_report_or_not) daily_report_num


from
(
select
	client_id
	, name
	, case when count( distinct date(run_date)) >=20 then 1 else 0 end as daily_report_or_not
      	
	from 
		 marin.user_reports ur
	where
    
		ur.client_id=$client_id
		and ur.run_date between date($start_date) and date($end_date) 
         group by 1,2

)x


group by 1
"

  mysql -h $server_name -u $user -p$pass -e "$query" -N
