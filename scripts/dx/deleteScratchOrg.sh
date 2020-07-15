bold=$(tput bold)
normal=$(tput sgr0)

alias=$1

echo ${bold}Delete Scratch Org: $alias ${normal}
sfdx force:org:delete --targetusername $alias --targetdevhubusername DEVHUB --noprompt