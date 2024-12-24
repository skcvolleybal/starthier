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

wp user add-role 1 beheerder barcie scheidsco tc teamcoordinator webcie

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


# Seems to work?
# Add Webcie user to Heren 6
team_title="Heren 6"
user_id="1"

# Find the post ID for "Heren 6"
team_post_id=$(wp post list --post_type=team --post_status=publish --field=ID --title="$team_title")

if [ -n "$team_post_id" ]; then
    echo "Adding user $user_id to team $team_title (Post ID: $team_post_id)..."
    
    # Check if the `team` meta already exists for the user
    if ! wp user meta get "$user_id" "team" | grep -q "$team_post_id"; then
        wp user meta add "$user_id" "team" "$team_post_id" || echo "Error adding 'team' meta."
    else
        echo "'team' meta for user $user_id already set to $team_post_id."
    fi

    # Check if the `_pods_team` meta already exists for the user
    if ! wp user meta get "$user_id" "_pods_team" | grep -q "$team_post_id"; then
        wp user meta add "$user_id" "_pods_team" "a:1:{i:0;i:$team_post_id;}" || echo "Error adding '_pods_team' meta."
    else
        echo "'_pods_team' meta for user $user_id already includes $team_post_id."
    fi
else
    echo "Team '$team_title' not found."
fi

# Generate a variable number of team members and assign them to random teams
# Only proceed if there's exactly one user (webcie)
existing_user_count=$(wp user list --field=ID | wc -l)
if [ "$existing_user_count" -eq 1 ]; then
    number_of_members=20  # Change this value to increase or decrease the number of members
    team_ids=($(wp post list --post_type=team --post_status=publish --field=ID))

    # Arrays of celebrity first names and surnames (including Dutch celebrities)
    first_names=("Marco" "Linda" "André" "Eva" "Doutzen" "Rico" "Arjen" "Sven" "Ali" "Famke")
    last_names=("Borsato" "de Mol" "Hazes" "Jinek" "Kroes" "Verhoeven" "Lubach" "Kramer" "B" "Louise")

    if [ ${#team_ids[@]} -eq 0 ]; then
        echo "No teams found. Skipping team member assignment."
    else
        echo "Generating $number_of_members team members with celebrity names and assigning them to random teams..."
        for member_number in $(seq 1 $number_of_members); do
            # Generate a random first name and last name
            first_name=${first_names[$RANDOM % ${#first_names[@]}]}
            last_name=${last_names[$RANDOM % ${#last_names[@]}]}
            full_name="$first_name $last_name"

            # Create unique username and email
            username=$(echo "${first_name}_${last_name}_${member_number}" | tr ' ' '_' | tr '[:upper:]' '[:lower:]')
            email="${username}@example.com"
            password="password_${member_number}"

            # Check if the user already exists
            if wp user get $username &> /dev/null; then
                echo "User $username already exists. Skipping creation."
            else
                # Create the user
                wp user create $username $email --role=subscriber --user_pass=$password --first_name="$first_name" --last_name="$last_name"
                echo "Created user $full_name with username $username."
            fi

            # Assign the user to a random team
            random_team_id=${team_ids[$RANDOM % ${#team_ids[@]}]}

            echo "Assigning user $username to team with ID $random_team_id..."

            # Check if the `team` meta already exists for the user
            if ! wp user meta get $username "team" | grep -q "$random_team_id"; then
                wp user meta add $username "team" "$random_team_id" || echo "Error adding 'team' meta."
            else
                echo "'team' meta for user $username already set to $random_team_id."
            fi

            # Check if the `_pods_team` meta already exists for the user
            if ! wp user meta get $username "_pods_team" | grep -q "$random_team_id"; then
                wp user meta add $username "_pods_team" "a:1:{i:0;i:$random_team_id;}" || echo "Error adding '_pods_team' meta."
            else
                echo "'_pods_team' meta for user $username already includes $random_team_id."
            fi
        done
    fi
else
    echo "Skipping team member generation. User count is not equal to one."
fi


echo "✅  Done running all preprogrammed commands, WP CLI container remains available"

# Infinite loop to keep the container alive
while true; do sleep 3600; done
