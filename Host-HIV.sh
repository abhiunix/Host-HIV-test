#!/bin/bash 
#Author: Abhijeet Singh (@abhiunix)
#Date: 12 Dec 2021
#Twitter: https://twitter.com/abhiunix

function functionu(){
echo ""
echo "Testing for Host Header injection vulnerability on $uo"
response=$(curl -sk -D response $uo -H 'Host: bing.com' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:94.0) Gecko/20100101 Firefox/94.0' -I)
response=$(curl -sk -o body.txt $uo -H 'Host: bing.com' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:94.0) Gecko/20100101 Firefox/94.0')

cat body.txt >> response
rm -r ./body.txt 
finding=$(cat response | grep bing.com)
rm -r response
if [ -z "$finding" ]; then
	echo "URL $uo is not vulnerable."
else
	echo -e "\033[31mURL might be vulnerable.\033[m"
	echo $uo >> vulnerableUrls.txt
fi
}

function functionU(){
echo ""
while IFS= read -r line; do
	uo=$line
	functionu
done 
}

if (( $# < 1 )); then
     echo "Try using valid options. Use -h to show help menu."
     exit  
fi
while getopts u:U:hc options; do
		case $options in
				u) uo=$OPTARG;;
				U) Uo=$OPTARG;;
				h) ho=$OPTARG;;
				*) echo "Try using valid options. use -h to show help menu.";;

		esac
		if [[ $options = "u" ]]; then
			functionu
		elif [[ $options = "U" ]]; then
			echo "Checking if the supplied list of URLs are working fine."
			sleep 3
			cat ./$2 | httpx | tee $2.urls
			echo ""
			sleep 1
			echo "Nice!! We have collected the working urls in $2.urls file."
			echo ""
			sleep 2
			echo "Now checking for Host Header Injection vulnerability. The output will be saved to vulnerableUrls.txt"
			sleep 3
			functionU < $2.urls
			if [ -s vulnerableUrls.txt ]; then
			    # The file is not-empty.
			     sleep 2
				echo ""
				echo "The vulnerable URLs has been saved to vulnerableUrls.txt"
			else
		        # The file is empty.
		        echo "Sorry, no URL seems to be vulnerable. Better luck next time!!."
			fi



			echo "Finished the URLs"

		elif [[ $options = "h" ]]; then
			echo "Usage of HIV test:"
			echo "  -h   Show basic help message and exit"
			echo "  -u   Target URL (e.g. 'http://www.site.com/')"
			echo "  -U   Target URL list file."
			echo ""
			echo "eg: ./hhi.sh -u https://example.com"
			echo "eg: ./hhi.sh -U ./path/URLlist.txt"
		fi
done
#enhancement
#--cookie support