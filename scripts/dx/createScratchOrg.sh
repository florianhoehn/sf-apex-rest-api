bold=$(tput bold)
normal=$(tput sgr0)

alias=$1
duration=${2:-7}
config=${3:-config/project-scratch-def.json}

echo ${bold}Create Scratch Org: $alias${normal}
sfdx force:org:create --definitionfile $config --setalias $alias --setdefaultusername --durationdays $duration --targetdevhubusername DEVHUB
echo -e

echo ${bold}Push repository: $alias${normal}
sfdx force:source:push --forceoverwrite --targetusername $alias --wait 10
echo -e