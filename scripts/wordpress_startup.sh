#!/bin/bash
# (wordpress_)startup.sh


echo "Checking if MySQL is ready..."
/wait-for-it.sh -t 0 mysql_db:3306

wp core install --url='http://localhost:8080' --title='SKC Volleybal Dev Site' --admin_user='webcie' --admin_password='webcie' --admin_email='webcie@skcvolleybal.nl' --path='/var/www/html' --skip-email
wp option update blogdescription 'Development site for SKC Volleybal' 
wp user update webcie --first_name='Webcie' --last-name='SKC' --path='/var/www/html'

# Example: Install Pods plugin
echo "Installing Pods plugin..."
wp plugin install pods --allow-root --path=/var/www/html
wp plugin install members --allow-root --path=/var/www/html

# Activate them bad boys
wp plugin activate pods --allow-root --path=/var/www/html
wp plugin activate members --allow-root --path=/var/www/html


# Create custom roles only if they don't already exist
wp role list --allow-root --path=/var/www/html | grep -q 'beheerder' || wp role create beheerder 'Beheerder' --allow-root --path=/var/www/html &&
wp role list --allow-root --path=/var/www/html | grep -q 'barcie' || wp role create barcie 'Barcie' --allow-root --path=/var/www/html &&
wp role list --allow-root --path=/var/www/html | grep -q 'bestuur' || wp role create bestuur 'Bestuur' --allow-root --path=/var/www/html &&
wp role list --allow-root --path=/var/www/html | grep -q 'commissieco' || wp role create commissieco 'CommissieCo' --allow-root --path=/var/www/html &&
wp role list --allow-root --path=/var/www/html | grep -q 'customer' || wp role create customer 'Customer' --allow-root --path=/var/www/html &&
wp role list --allow-root --path=/var/www/html | grep -q 'lustrumcie' || wp role create lustrumcie 'LustrumCie' --allow-root --path=/var/www/html &&
wp role list --allow-root --path=/var/www/html | grep -q 'paparazcie' || wp role create paparazcie 'PaparazCie' --allow-root --path=/var/www/html &&
wp role list --allow-root --path=/var/www/html | grep -q 'scheidsco' || wp role create scheidsco 'ScheidsCo' --allow-root --path=/var/www/html &&
wp role list --allow-root --path=/var/www/html | grep -q 'vendor' || wp role create vendor 'Vendor' --allow-root --path=/var/www/html &&
wp role list --allow-root --path=/var/www/html | grep -q 'shop' || wp role create shop 'Shop' --allow-root --path=/var/www/html &&
wp role list --allow-root --path=/var/www/html | grep -q 'abonnee' || wp role create abonnee 'Abonnee' --allow-root --path=/var/www/html &&
wp role list --allow-root --path=/var/www/html | grep -q 'tc' || wp role create tc 'TC' --allow-root --path=/var/www/html &&
wp role list --allow-root --path=/var/www/html | grep -q 'teamcoordinator' || wp role create teamcoordinator 'Teamcoordinator' --allow-root --path=/var/www/html &&
wp role list --allow-root --path=/var/www/html | grep -q 'webcie' || wp role create webcie 'WebCie' --allow-root --path=/var/www/html &&


wp pods pod add --type=post_type --name=team --allow-root --path=/var/www/html

