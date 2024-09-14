define_variables() {
    TARGET_DIR="/Applications/XAMPP/xamppfiles/htdocs"
    DB_NAME="wordpress_db"
    DB_USER="root"
    DB_PASSWORD=""
    DB_HOST="127.0.0.1"
    WP_URL="http://localhost/"  # The local URL for your WordPress site
    WP_TITLE="SKC WORDPRESS DEV SITE"
    WP_ADMIN_USER="admin"
    WP_ADMIN_PASS="password"
    WP_ADMIN_EMAIL="webcie@skcvolleybal.nl"

    WP_DIR=$TARGET_DIR

}


setup_xampp_and_brew() {
    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    echo "Installed Brew"

    # Disable gatekeeper so we can install XAMPP using brew 
    sudo spctl --master-disable

    echo "Disabled Gatekeeper"

    # Install XAMPP
    brew install --cask xampp

    # Used to interface with WP from command line
    echo "Installing WP CLI"
    brew install wp-cli

    cd "/Applications/XAMPP/xamppfiles"
    sudo ./xampp start

    cd "htdocs"

    # Empty htdocs dir 
    sudo rm -rf *
    echo "Emptied htdocs"
    echo "Clean XAMPP install ready"

} 

download_wordpress_and_plugins() {
    # Change to the target directory
    cd "$TARGET_DIR" || exit

    # Download WordPress
    echo "Downloading WordPress..."
    curl -O https://wordpress.org/latest.zip

    # Unzip WordPress
    echo "Unzipping WordPress..."
    unzip latest.zip

    # Move WordPress files to the target directory
    mv wordpress/* .

    # Clean up the zip file and empty wordpress directory
    rm -rf wordpress latest.zip

    Download Pods plugin
    echo "Downloading Pods plugin..."
    cd "${TARGET_DIR}/wp-content/plugins" || exit
    curl -L -o pods.zip https://downloads.wordpress.org/plugin/pods.latest-stable.zip

    # Unzip Pods plugin
    echo "Unzipping Pods plugin..."
    unzip pods.zip
    rm pods.zip


    echo "WordPress with Pods plugin has been successfully installed in $TARGET_DIR"

}

create_wordpress_database () {

    echo "Creating WordPress database..."


    cd "${TARGET_DIR}/../bin"

    echo "⚠️ THIS IS NOT YOUR PASSWORD; IT'S THE EMPTY DATABASE PASSWORD. JUST PRESS ENTER FOR THIS PASSWORD BELOW"
    ./mysql -u$DB_USER -p$DB_PASS -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
    if [ $? -eq 0 ]; then
        echo "Database '$DB_NAME' created successfully."
    else
        echo "Failed to create database."
        exit 1
    fi
}

setup_wp_config_file () {
    # Step 2: Set up wp-config.php for WordPress
    cd "$WP_DIR" || exit
    echo "Set path to $WP_DIR"

    # Check if wp-config.php exists; if not, create it from wp-config-sample.php
    if [ ! -f wp-config.php ]; then
    cp wp-config-sample.php wp-config.php
    echo "wp-config.php created from sample."
    else
    echo "wp-config.php already exists."
    fi

    # Update wp-config.php with database information
    echo "Configuring WordPress database settings in wp-config.php..."

    # Replace placeholders in wp-config.php with actual values
    sed -i "" "s/database_name_here/$DB_NAME/" wp-config.php
    sed -i "" "s/username_here/$DB_USER/" wp-config.php
    sed -i "" "s/password_here/$DB_PASS/" wp-config.php
    sed -i "" "s/localhost/$DB_HOST/" wp-config.php

    echo "Resulting wp-config.php:"
    cat wp-config.php
}


install_wordpress() {

    # Step 3: Install WordPress using wp-cli
    echo "Installing WordPress..."

    # Install WordPress via wp-cli
    wp core install --path="$TARGET_DIR" \
    --url="$WP_URL" \
    --title="$WP_TITLE" \
    --admin_user="$WP_ADMIN_USER" \
    --admin_password="$WP_ADMIN_PASS" \
    --admin_email="$WP_ADMIN_EMAIL" \
    --skip-email

    if [ $? -eq 0 ]; then
        echo "WordPress installed successfully!"
    else
        echo "WordPress installation failed!"
        exit 1
    fi
    echo "WordPress is now fully set up at $WP_URL."

}


define_variables
# setup_xampp_and_brew
# download_wordpress_and_plugins
create_wordpress_database
setup_wp_config_file
install_wordpress