user=tshinagawa
pass=2mecno7v2k
export user pass

#JP_Spend
#start_date="'2017-10-01'"
#end_date="'2017-10-31'"
#export start_date  end_date

#echo Enter start date
#read start_date
#export start_date

#echo Enter end date
#read end_date
#export end_date

todays_date='2017-11-24'
start_date="'"$(date -d "$todays_date -30 days" +%Y-%m-%d)"'"
end_date="'"$todays_date"'"
export start_date end_date 


echo -e 'client_id\tclient_name\tFolder_Name\tFolder_Goal\tCPA\tCPA_Target\tTargets\tMargin_Percent\tROAS_Target\tHigh_Position\tLow_Position' > folders.csv 
shuf JP_Client_Spend_List.txt | xargs -P 20  -L 1 ./folders.sh >> folders.csv

mytime=`date +%Y-%m-%d:%H:%M:%S`
echo " JP-Folders-The query has finsihed at $mytime" | mail -s "JP_folders finished at $mytime" tshinagawa@marinsoftware.com

