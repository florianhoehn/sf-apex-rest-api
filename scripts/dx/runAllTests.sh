bold=$(tput bold)
normal=$(tput sgr0)

alias=$1

echo ${bold}Run all tests${normal}
sfdx force:apex:test:run --testlevel RunLocalTests --codecoverage --resultformat human --targetusername $alias