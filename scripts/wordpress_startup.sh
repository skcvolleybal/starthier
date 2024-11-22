#!/bin/bash
# (wordpress_)startup.sh
echo "Checking if MySQL is ready..."
/wait-for-it.sh -t 0 mysql_db:3306
sleep 5
export WP_CLI_PATH='/var/www/html'
export WP_CLI_ALLOW_ROOT=1

wp core install --url='http://localhost' --title='SKC Volleybal Dev Site' --admin_user='webcie' --admin_password='webcie' --admin_email='webcie@skcvolleybal.nl' --skip-email
wp option update blogdescription 'Development site for SKC Volleybal' 
wp user update webcie --first_name='Webcie' --last-name='SKC'


# Example: Install Pods plugin
echo "Installing Pods plugin..."
wp plugin install pods
wp plugin install members
# Activate them bad boys
wp plugin activate pods
wp plugin activate members


# Create custom roles only if they don't already exist
wp role list | grep -q 'beheerder' || wp role create beheerder 'Beheerder' 
wp role list | grep -q 'barcie' || wp role create barcie 'Barcie' 
wp role list | grep -q 'bestuur' || wp role create bestuur 'Bestuur' 
wp role list | grep -q 'commissieco' || wp role create commissieco 'CommissieCo' 
wp role list | grep -q 'customer' || wp role create customer 'Customer' 
wp role list | grep -q 'lustrumcie' || wp role create lustrumcie 'LustrumCie' 
wp role list | grep -q 'paparazcie' || wp role create paparazcie 'PaparazCie' 
wp role list | grep -q 'scheidsco' || wp role create scheidsco 'ScheidsCo' 
wp role list | grep -q 'vendor' || wp role create vendor 'Vendor' 
wp role list | grep -q 'shop' || wp role create shop 'Shop' 
wp role list | grep -q 'abonnee' || wp role create abonnee 'Abonnee' 
wp role list | grep -q 'tc' || wp role create tc 'TC' 
wp role list | grep -q 'teamcoordinator' || wp role create teamcoordinator 'Teamcoordinator' 
wp role list | grep -q 'webcie' || wp role create webcie 'WebCie' 

# Add the pod structure to the site
wp pods-legacy-api import-pod --file="/pods.json"

# Add a custom team if it doesn't exist yet
for team_type in Heren Dames; do
    if [ "$team_type" == "Heren" ]; then
        max=9
    else
        max=15
    fi
    for i in $(seq 1 $max); do
        title="$team_type $i"
        if ! wp post list --post_type=team --post_status=publish --field=post_title | grep -q "$title"; then
            wp post create --post_type=team --post_title="$title" --post_status=publish
        else
            echo "Post with the title '$title' already exists."
        fi
    done
done



echo "✅  Done running all preprogrammed commands, WP CLI container remains available"

# Infinite loop to keep the container alive
while true; do sleep 3600; done
