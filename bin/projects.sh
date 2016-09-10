source $(dirname $0)/../lib/common.sh 

projects=$(api '/people/'${me}'/entries?from=20160101&to=20160930' | grep project-id | sort | uniq | sed 's#.*">##g;s#<.*##g')

echo "all projects since 20160101 to 20160930"
for project in $projects; do
    echo "project "$project
    # get_project $project
    # echo

done