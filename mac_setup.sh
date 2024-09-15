define_variables() {
    TARGET_DIR="/Applications/XAMPP/xamppfiles/htdocs"
    WORDPRESS_DB_NAME="wordpress_db"
    DB_USER="root"
    DB_PASSWORD="password"
    DB_HOST="127.0.0.1"
    WP_URL="http://localhost/"  # The local URL for your WordPress site
    WP_TITLE="SKC WORDPRESS DEV SITE"
    WP_ADMIN_USER="admin"
    WP_ADMIN_PASS="password"
    WP_ADMIN_EMAIL="webcie@skcvolleybal.nl"

    TEAMPORTAL_DB_NAME="teamportal_db"
    TCAPP_DB_NAME="tcapp_db"

    XAMPP_NAME="xampp-osx-8.2.4-0-installer"
    DMG_NAME="${XAMPP_NAME}.dmg"
    DMG_URL="https://sourceforge.net/projects/xampp/files/XAMPP%20Mac%20OS%20X/8.2.4/${DMG_NAME}"
    INSTALLER_NAME="${XAMPP_NAME}.app"
    MOUNT_POINT="/Volumes/XAMPP"
    XAMPP_INSTALL_DIRECTORY="/Applications/XAMPP/xamppfiles"
}

install_brew() {
    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    echo "Installed Brew"

}

is_xampp_present() {
    # Check if the directory exists
    if [ -d "$XAMPP_INSTALL_DIRECTORY" ]; then
        # Check if the directory contains any files
        if [ "$(ls -A "$XAMPP_INSTALL_DIRECTORY")" ]; then
            echo "XAMPP already detected at ${XAMPP_INSTALL_DIRECTORY}."
            return 0  # Directory exists and contains files (XAMPP is present)
        else
            echo "The directory is empty."
            return 1  # Directory exists but is empty (XAMPP is not fully installed)
        fi
    else
        echo "The directory does not exist."
        return 1  # Directory does not exist (XAMPP is not installed)
    fi
}


install_xampp() {
    # Check if XAMPP is already present
    if is_xampp_present "$file_to_check"; then
        echo "XAMPP is already installed."
    else
        # Download XAMPP
        echo "Downloading $DMG_NAME..."
        curl -L -o "$DMG_NAME" "$DMG_URL"

        # Mount the .dmg file
        echo "Mounting $DMG_NAME..."
        hdiutil attach "$DMG_NAME" -mountpoint "$MOUNT_POINT" -nobrowse

        # Check if the mount was successful
        if [ $? -ne 0 ]; then
            echo "Failed to mount $DMG_NAME."
            exit 1
        fi

        # Check if the installer name is set
        if [ -z "$INSTALLER_NAME" ]; then
            echo "No installer found in the mounted volume."
            hdiutil detach "$MOUNT_POINT"
            exit 1
        fi

        # Start the installer
        echo "Starting installer: ${MOUNT_POINT}/${INSTALLER_NAME}..."
        open "${MOUNT_POINT}/${INSTALLER_NAME}"

        # Wait for the installation to complete
        echo "Waiting for installation to complete..."
        echo "Once you have installed XAMPP, press Enter to continue. We'll start up Apache and MySQL for you."

        # Wait for user input
        read

        # Unmount the .dmg file
        echo "Unmounting $DMG_NAME..."
        hdiutil detach "$MOUNT_POINT"
        
        echo "Installation completed."
    fi

    echo "Adding XAMPP PHP to path"
 
    #!/bin/bash

    # Define the line to be added
    LINE="export PATH=/Applications/XAMPP/xamppfiles/bin:\$PATH"

    # Check if the line already exists in .zshrc
    if ! grep -Fxq "$LINE" ~/.zshrc; then
        # If not, add the line
        echo "$LINE" >> ~/.zshrc
        echo "Line added to .zshrc"
    else
        echo "Line already exists in .zshrc"
    fi


    
    # Stopping all MySQLD Servers
    echo "Enter your password to kill all running MySQL instances:"
    sudo killall mysqld
    cd "${TARGET_DIR}/../bin/"
    
    
    echo "Starting MySQL and Apache..."
    sudo ./mysql.server start

    # Stopping all apache servers
    sudo killall httpd
    # Starting Apache XAMPP
    sudo /Applications/XAMPP/xamppfiles/bin/apachectl start
}


set_mysql_root_password() {
    cd "${TARGET_DIR}/../bin"

    echo "⚠️ JUST PRESS ENTER FOR THIS PASSWORD BELOW"

    ./mysql -u"$DB_USER" -p"" -e "ALTER USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD'; FLUSH PRIVILEGES;"
    if [ $? -eq 0 ]; then
        echo "MySQL root password changed to $DB_PASSWORD"
    else
        ./mysql -u"$DB_USER" -p"$DB_PASSWORD" -e "ALTER USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD'; FLUSH PRIVILEGES;"
            if [ $? -eq 0 ]; then
                echo "MySQL root password unchanged: $DB_PASSWORD. Continuing"
            else
                echo "Could not change root password! This script will not run properly."
            fi

    fi


}

setup_node_composer_wpcli() {
    # Install Node 18
    brew install node@18

    # Install Composer globally
    brew install composer

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

    # Download Pods plugin
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

    ./mysql -u$DB_USER -p$DB_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $WORDPRESS_DB_NAME;"
    if [ $? -eq 0 ]; then
        echo "Database '$WORDPRESS_DB_NAME' created successfully."
    else
        echo "Failed to create database."
        exit 1
    fi
}

setup_wp_config_file () {
    cd "$TARGET_DIR" || exit

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
    sed -i "" "s/database_name_here/$WORDPRESS_DB_NAME/" wp-config.php
    sed -i "" "s/username_here/$DB_USER/" wp-config.php
    sed -i "" "s/password_here/$DB_PASSWORD/" wp-config.php
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
    echo "This is a CLEAN installation without themes or anything. Use admin panel. " 
}

create_teamportal_database () {

    echo "Creating TeamPortal database..."


    cd "${TARGET_DIR}/../bin"

    ./mysql -u$DB_USER -p$DB_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $TEAMPORTAL_DB_NAME;"
    if [ $? -eq 0 ]; then
        echo "Database '$TEAMPORTAL_DB_NAME' created successfully."
    else
        echo "Failed to create database."
        exit 1
    fi
}


create_tcapp_database () {

    echo "Creating Tcapp database..."
    cd "${TARGET_DIR}/../bin"

    ./mysql -u$DB_USER -p$DB_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $TCAPP_DB_NAME;"
    if [ $? -eq 0 ]; then
        echo "Database '$TCAPP_DB_NAME' created successfully."
    else
        echo "Failed to create database."
        exit 1
    fi
}

install_teamportal () {
    cd $TARGET_DIR
    git clone https://github.com/skcvolleybal/team-portal
    
    # Install NPM packages
    cd "${TARGET_DIR}/team-portal/"
    npm i 
    
    # Install PHP packages
    cd "${TARGET_DIR}/team-portal/php"
    /Applications/XAMPP/xamppfiles/bin/php /opt/homebrew/opt/composer/bin/composer update 
    /Applications/XAMPP/xamppfiles/bin/php /opt/homebrew/opt/composer/bin/composer install 

    # Fix .env file
    cp .env.example .env

    # Not yet working
    sed -i '' 's|WORDPRESS_PATH=C:\\\\laragon\\www\\testskc|WORDPRESS_PATH=/Applications/XAMPP/xamppfiles/htdocs|g' .env

}

install_tc_app () {
    cd $TARGET_DIR
    git clone https://github.com/skcvolleybal/tc-app
    
    # Install NPM packages
    cd "${TARGET_DIR}/tc-app/"
    npm i 
    
    # Install PHP packages
    cd "${TARGET_DIR}/tc-app/"
    /Applications/XAMPP/xamppfiles/bin/php /opt/homebrew/opt/composer/bin/composer update 
    /Applications/XAMPP/xamppfiles/bin/php /opt/homebrew/opt/composer/bin/composer install 

    # Fix .env file
    cp .env.example .env

    # Not yet working
    sed -i '' 's|WORDPRESS_PATH=C:\\\\laragon\\www\\testskc|WORDPRESS_PATH=/Applications/XAMPP/xamppfiles/htdocs|g' .env

    SQL_FILE="${TARGET_DIR}/tc-app/database_install.sql"
    
    cd "${TARGET_DIR}/../bin"
    # Run the SQL script to create tables
    ./mysql -u"$DB_USER" -p"$DB_PASSWORD" "$TCAPP_DB_NAME" < "$SQL_FILE"
    if [ $? -eq 0 ]; then
        echo "Tables created successfully from '$SQL_FILE'."
    else
        echo "Failed to create tables from '$SQL_FILE'."
        exit 1
    fi

}





start_teamportal () {
    cd "${TARGET_DIR}/team-portal/"
    
    # Kill running processes on port 4200
    kill -9 $(lsof -ti:4200) 2>&1 >/dev/null

    # Start teamportal on port 4200
    npm run ng serve

}

define_variables
install_brew
install_xampp
set_mysql_root_password
setup_node_composer_wpcli
download_wordpress_and_plugins
create_wordpress_database
setup_wp_config_file
install_wordpress
create_teamportal_database
create_tcapp_database
install_teamportal
install_tc_app
start_teamportal


