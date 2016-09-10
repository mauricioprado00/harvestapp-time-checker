source $(dirname $0)/../lib/common.sh 

get_this_month_report | grep '\(project-id\)\|\(hours\)' > /tmp/this-month-projects-and-hours

for project_group in $project_groups; do
    echo "project group: "$project_group
    eval "max=\$${project_group}_max"
    eval "warn=\$${project_group}_warn"
    echo "max time: $max"
    echo '' > /tmp/current-project-group-total-hours
    for project_id in $(eval "echo \$$project_group"); do 
        echo "project_id: "$project_id
        #get_this_month_report | grep '(project-id)|(hours)'
        project_total=$(cat /tmp/this-month-projects-and-hours | grep -B1 'project-id.*'$project_id | adduphours)
        echo "project total: "$project_total
        echo $project_total>>/tmp/current-project-group-total-hours
    done
    total_group_hours=$(cat /tmp/current-project-group-total-hours | addupfloats)
    echo "Total group hours: "$total_group_hours

    echo $total_group_hours $max | awk '{ if ($1 > $2) { exit 1; } exit 0; }'
    if [ $? -ne 0 ]; then
        echo "Project group "$project_group" has EXCEEDED HOURS"
    else 

        echo $total_group_hours $max $warn | awk '{ if (($1+$3) > $2) { exit 1; } exit 0; }'
        if [ $? -ne 0 ]; then
            echo "Project group "$project_group" is ABOUT to EXCEED HOURS"
        fi
    fi

    echo
done