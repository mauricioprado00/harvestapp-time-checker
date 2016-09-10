
if [ ! -f ~/.harvest-app-config ]; then
    echo 'Please create a harvest app config file in ~/.harvest-app-config '
    echo 'You can use this one as an example: harvest-app-config.sample' 
    exit 1
fi

source ~/.harvest-app-config

function api() {
    local requested=$1
    curl -H 'Content-Type: application/xml' -H 'Accept: application/xml' -u ${auth} ${baseurl}${requested} 2>/dev/null
}

function stripxml() {
    cat - | sed 's#.*">##g;s#<.*##g'
}

function addupfloats() {
    cat - | awk 'BEGIN {total=0;} {total=total+$1; } END {print total}'
}

function adduphours() {
    cat - | grep hours | stripxml | addupfloats
}

function get_project() {
    local pid=$1

    api '/projects/'$pid
}

# http://stackoverflow.com/questions/12381501/how-to-use-bash-to-get-the-last-day-of-each-month-for-the-current-year-without-u
function month_range() {
    local month_nr=$1
    local year=$2
    local max=$(date -d "${month_nr}/1/${year} + 1 month - 1 day" "+%Y%m%d"); 
    local min=$(date -d "${month_nr}/1/${year}" "+%Y%m%d");
    echo $min
    echo $max
}

function this_month_range(){
    local year=$(date '+%Y')
    local month_nr=$(date '+%m')
    month_range $month_nr $year
}

function this_month_range_params() {
    local params='from='$(this_month_range | head -n1)'&to='$(this_month_range | tail -n1)
    echo $params
}

function get_this_month_report() {
    api '/people/'${me}'/entries?'$(this_month_range_params)
}