source $(dirname $0)/../lib/common.sh 

curl -H 'Content-Type: application/xml' -H 'Accept: application/xml' -u $auth 'https://thealleygroup.harvestapp.com/people/772668/entries?from=20160801&to=20160830'