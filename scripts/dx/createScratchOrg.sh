bold=$(tput bold)
normal=$(tput sgr0)

alias=$1
duration=${2:-7}
config=${3:-config/scratch-org-definition.json}

echo ${bold}Create Scratch Org: $alias${normal}
sfdx force:org:create --definitionfile $config --setalias $alias --setdefaultusername --durationdays $duration --targetdevhubusername DEVHUB
echo -e