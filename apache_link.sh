#!/bin/bash
env
PROYECTO=`basename "$PWD"` 
echo "VALOR VARIABLE = ${PROYECTO}"
ln -s "$PWD" /var/www/html/${PROYECTO}
sed -i "s|/var/www/html|/var/www/html/${PROYECTO}|g" /etc/apache2/sites-enabled/000-default.conf
sudo setfacl -dRL -m u:'www-data':rwX -m u:www-data:rwX ${PWD}
sudo setfacl -RL -m u:'www-data':rwX -m u:www-data:rwX ${PWD}
sudo /etc/init.d/apache2 restart
