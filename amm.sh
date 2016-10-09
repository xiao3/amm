#/bin/bash
#
#by Chuck Wang (xiao3)

#############################

#para
#revise the "12 hours" to adjust with your own time zone if it is different with server.
current_time=$(date -d "12 hours" +%Y%m%d-%X)
#replace the "chuck.wang@live.cn" with your own email address to receive the media contents.
email_list="chuck.wang@live.cn"

#############################

#UA
curl 'http://newsroom.united.com/news-releases' -H 'Upgrade-Insecure-Requests: 1' -H 'Referer: http://newsroom.united.com/' -H 'User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36' --compressed |grep "item_date">temp_crawl_file

cat temp_crawl_file | awk -F">" '{print $2}' | awk -F"<" '{print $1}' >temp_date_file

cat temp_crawl_file | awk -F"a href=" '{print $NF}' | awk -F"<" '{print $1}' | awk -F"\"" '{print $2}' >temp_link_file

cat temp_crawl_file | awk -F"a href=" '{print $NF}' | awk -F"<" '{print $1}' | awk -F">" '{print $2}' >temp_title_file


echo "###############United Airlines Newsroom:">temp_summary_file
paste -d, <(cat temp_date_file) <(cat temp_title_file) <(cat temp_link_file) >>temp_summary_file
echo "">>temp_summary_file


#BA
curl 'http://mediacentre.britishairways.com/pressrelease/index?view=list-view&keywords=&start_date=&end_date=&categoryfilter=1' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: zh-CN,zh;q=0.8' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Referer: http://mediacentre.britishairways.com/pressrelease/details/86/News-1/6493' -H $'Cookie: v1st=69ADBB31281E4E14; __gads=ID=719ab5d508a1cc2c:T=1468299553:S=ALNI_MZ4_-dUqlc3RBgCCqRKxx1GHiwn-Q; mmapi.store.p.0=%7B%22mmparams.d%22%3A%7B%7D%2C%22mmparams.p%22%3A%7B%22mmid%22%3A%221499835572692%7C%5C%22-274035430%7CAgAAAArr4TqEmA0AAA%3D%3D%5C%22%22%2C%22pd%22%3A%221499835572696%7C%5C%221559772812%7CAwAAAAoBQuvhOoSYDcqqWJ0BACdeZlARqtNIDwAAAFOmZ0QRqtNIAAAAAP%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FAAtjbi5iaW5nLmNvbQOYDQEAAAAAAAAAAAAA%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FAAAAAAABRQ%3D%3D%5C%22%22%2C%22srv%22%3A%221499835572698%7C%5C%22lvsvwcgeu04%5C%22%22%7D%7D; Allow_BA_Cookies=accepted; __utmt=1; tmseen=1; __utma=28787695.227541888.1468299553.1468566199.1468570998.9; __utmb=28787695.2.10.1468570998; __utmc=28787695; __utmz=28787695.1468570998.9.9.utmcsr=bing|utmccn=(organic)|utmcmd=organic|utmctr=British%20Airways%20news; LGP=1/:&\'()*+,-./01G@BFILJFKKJSNMSWURRGVeV]YYZ]_deQRSTefjiflijs; _gat=1; ba=a%3A4%3A%7Bs%3A10%3A%22session_id%22%3Bs%3A32%3A%22b737c5ad3a9cefc92ca81c17545548cc%22%3Bs%3A10%3A%22ip_address%22%3Bs%3A13%3A%2258.32.230.251%22%3Bs%3A10%3A%22user_agent%22%3Bs%3A109%3A%22Mozilla%2F5.0+%28Windows+NT+6.1%3B+WOW64%29+AppleWebKit%2F537.36+%28KHTML%2C+like+Gecko%29+Chrome%2F51.0.2704.103+Safari%2F537.36%22%3Bs%3A13%3A%22last_activity%22%3Bi%3A1468567401%3B%7Db1ec98fe752917df343de8174032f2eb; __unam=49f0a6b-155eda8b869-662dae50-2; _ga=GA1.2.227541888.1468299553' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' --compressed >temp_curl_ba


cat temp_curl_ba | grep "http://mediacentre.britishairways.com/pressrelease/details" | uniq |awk -F"\"" '{print $2}' >temp_link_ba

cat temp_curl_ba | grep "date_news" | awk -F">" '{print $2}' | awk -F"<" '{print $1}' >temp_date_ba


>temp_title_ba
cat temp_link_ba | while read line
do
    cat temp_curl_ba | grep "${line}" -C 1 | tail -1 |sed -e "s/^[ ]*//g" | sed 's/\r//'  >>temp_title_ba
done

echo "###############British Airways Media Centre:">>temp_summary_file
paste -d, <(cat temp_date_ba) <(cat temp_title_ba) <(cat temp_link_ba) | head >>temp_summary_file
echo "">>temp_summary_file


#chinaaviationdaily.com
curl 'http://www.chinaaviationdaily.com/list/lmlist_1_1.html' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: zh-CN,zh;q=0.8' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Referer: http://www.chinaaviationdaily.com/' -H 'Cookie: _ga=GA1.2.694981887.1468905655' -H 'Connection: keep-alive' -H 'If-Modified-Since: Tue, 19 Jul 2016 05:30:00 GMT' -H 'Cache-Control: max-age=0' --compressed >temp_curl_file_chinaaviationdaily


cat temp_curl_file_chinaaviationdaily | grep "a href=" | grep target | grep li | grep _blank | grep em | grep -v "pic.carnoc.com" | awk -F"a href=" '{print $2}' | awk -F"\"" '{print $2}' >temp_link_chinaaviationdaily


cat temp_curl_file_chinaaviationdaily | grep "a href=" | grep target | grep li | grep _blank | grep em | grep -v "pic.carnoc.com" | awk -F"a href=" '{print $2}' | awk -F">" '{print $2}' | awk -F"<" '{print $1}' >temp_title_chinaaviationdaily


cat temp_curl_file_chinaaviationdaily | grep "a href=" | grep target | grep li | grep _blank | grep em | grep -v "pic.carnoc.com" | awk -F"[" '{print $2}' | awk -F"]" '{print $1}' >temp_date_chinaaviationdaily



echo "###############China Aviation Daily:">>temp_summary_file
paste -d, <(cat temp_date_chinaaviationdaily) <(cat temp_title_chinaaviationdaily) <(cat temp_link_chinaaviationdaily) >>temp_summary_file
echo "">>temp_summary_file

##################### Email send out
cat temp_summary_file | mail -s "Airline Media Monitor ${current_time}" ${email_list}

##################### rm log
rm -rf temp*

