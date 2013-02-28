#!/bin/bash
#Unbannator by benjbubu
#This program helps you to remove host or ip if you get banned accidentally on your 
#computer when using denyhosts
#
#Licence : GNU GPLv3+
#
#Ce programme vous permet d'enlever une IP ou un hote dans denyhosts.
#Pratique en cas d'auto-ban...
#
#This program requires GNU Sed >= 4 to work / Vous avez besoin de la version 4 (ou superieur) de GNU Sed pour fonctionner

#Checking if the script runs under root user / Verification si le script est lancé par le compte root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root due to denyhosts files permissions" 1>&2
   exit 1
fi

#Checking GNU sed version / Verification de la version de GNU sed
testsed=`sed --version | grep version | cut -d" " -f4 | cut -d"." -f1`
if [[ $testsed -lt 4 ]];
then echo "Unbannator need Gnu sed >= 4 to work. Please update";
exit;
fi

#Inserting IP by the user / Declaration de l'IP par l'utilisateur
if [ $# -ne 1 ];
then echo "Incorrect Syntax : ./unbannator.sh XX.YY.ZZ.WW";
exit;
fi

#Stopping Denyhosts
echo "Stopping Denyhosts for my duty..."
sleep 1
/etc/init.d/denyhosts stop

IP=$1

echo "The IP to be removed is" $IP
sleep 1

#Deleting the IP from the files of denyhosts / Suppression de l'IP des fichiers utilis�s par denyhosts

sed -i "/$1/d" /var/lib/denyhosts/hosts
sed -i "/$1/d" /var/lib/denyhosts/hosts-restricted
sed -i "/$1/d" /var/lib/denyhosts/hosts-root
sed -i "/$1/d" /var/lib/denyhosts/hosts-valid
sed -i "/$1/d" /var/lib/denyhosts/users-hosts
sed -i "/$1/d" /etc/hosts.deny
echo "IP deleted from all files, restarting denyhosts"
sleep 1
/etc/init.d/denyhosts start
echo "Job Complete Master"
exit

