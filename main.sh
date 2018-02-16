
user=jkao
pass=4vgtthjyy8
export user pass

#JP_Spend
#start_date="'2017-10-01'"
#end_date="'2017-10-31'"
#export start_date  end_date

echo Enter start date
read start_date
export start_date

echo Enter end date
read end_date
export end_date

#Customer Names
echo -e 'client_id\tcustomer_name' > 1_customer_names.csv
shuf JP_Client_Spend_List.txt | xargs -P 20  -L 1 ./customer_names.sh >> 1_customer_names.csv

sort 1_customer_names.csv -o 1_customer_names.csv
echo '1/7 done'

#Cost Report
echo -e 'client_id\tclient_name\tcustomer_id\tyear\tmonth\tlocal_cost\ttraffic_cost\tGoogle_cost\tYJP_cost\tYDN_cost\ttraffic_folder\tactive_campaigns_traffic\tall_campaigns' > 2_jp_spend_report.csv
shuf JP_Client_Spend_List.txt | xargs -P 20  -L 1 ./jp_spend.sh >> 2_jp_spend_report.csv

sort 2_jp_spend_report.csv -o 2_jp_spend_report.csv 
echo '2/7 done'

#User login details
echo -e 'client_id\tuser_login' > 3_marin_login_count.csv
shuf JP_Client_Spend_List.txt | xargs -P 20  -L 1 ./marin_login.sh >> 3_marin_login_count.csv 

sort 3_marin_login_count.csv -o 3_marin_login_count.csv 
echo '3/7 done'

#Daily Reports
echo -e 'client_id\tdaily_report' > 4_reports.csv
shuf JP_Client_Spend_List.txt | xargs -P 20  -L 1 ./reports.sh >> 4_reports.csv

sort 4_reports.csv -o 4_reports.csv
echo '4/7 done'

#PCA Linked
echo -e 'client_id\tGoogle_PCA\tYJP_PCA\tYDN_PCA' > 5_Linked_PCAs.csv
shuf JP_Client_Spend_List.txt | xargs -P 20  -L 1 ./PCA_link_count.sh >> 5_Linked_PCAs.csv

sort 5_Linked_PCAs.csv -o 5_Linked_PCAs.csv
echo '5/7 done'

#Custom Tracking Check
echo -e 'client_id\tcustom_tracking' > 6_custom_tracking.csv
shuf JP_Client_Spend_List.txt | xargs -P 20  -L 1 ./custom_tracking_check.sh >> 6_custom_tracking.csv

sort 6_custom_tracking.csv -o 6_custom_tracking.csv
echo '6/7 done'

#Last Pub Cost Date
echo -e 'client_id\tGoogle_Last_Date\tYJP_Last_Date\tYDN_Last_Date' > 7_last_cost_date.csv
shuf JP_Client_Spend_List.txt | xargs -P 20  -L 1 ./last_cost_date.sh >> 7_last_cost_date.csv
echo '7/7 done'

#Join the Tables
echo 'Joining tables...'
join -t $'\t' 1_customer_names.csv 2_jp_spend_report.csv -a1 > joined_1_2.csv
join -t $'\t' joined_1_2.csv 3_marin_login_count.csv -a1 -e 'NULL' -o '0,1.2,1.3,1.4,1.5,1.6,1.7,1.8,1.9,1.10,1.11,1.12,1.13,1.14,2.2' > joined_1_2_3.csv
join -t $'\t' joined_1_2_3.csv 4_reports.csv -a1 -e 'NULL' -o '0,1.3,1.4,1.2,1.5,1.6,1.7,1.8,1.9,1.10,1.11,1.12,1.13,1.14,1.15,2.2' > joined_1_2_3_4.csv
join -t $'\t' joined_1_2_3_4.csv 5_Linked_PCAs.csv -a1 > joined_1_2_3_4_5.csv
join -t $'\t' joined_1_2_3_4_5.csv 6_custom_tracking.csv -a1 | tac > all_done.csv

echo 'removing files'
rm ./joined_1_2.csv
rm ./joined_1_2_3.csv
rm ./joined_1_2_3_4.csv 
rm ./joined_1_2_3_4_5.csv
echo 'script complete'

#echo "JP_Spend_is_Ready" | mail -s "JP_Spend_Ready" -a /home/tshinagawa/JP_Client_Spend/all_done.csv tshinagawa@marinsoftware.com, jkao@marinsoftware.com 

: '
mytime=`date +%Y-%m-%d:%H:%M:%S`
echo " JP-Spend-The query has finsihed at $mytime" | mail -s "JPspend finished at $mytime" tshinagawa@marinsoftware.com 
'
