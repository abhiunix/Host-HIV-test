#!/bin/bash 
#Author: Abhijeet Singh (@abhiunix)
#Date: 12 Dec 2021
#Twitter: https://twitter.com/abhiunix

function functionu(){
echo ""
echo "Testing for Host Header injection vulnerability on $uo"
responseA=$(curl -sk -D response $uo -H 'Host: bing.com' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:94.0) Gecko/20100101 Firefox/94.0' -I)
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
				c) co=$OPTARG;;
				p) po=$OPTARG;;
				*) echo "Try using valid options. use -h to show help menu.";;

		esac
		if [[ $options = "u" ]]; then
			functionu
		elif [[ $options = "U" ]]; then
			functionU < $2
			if [ -s vulnerableUrls.txt ]; then
			    # The file is not-empty.
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