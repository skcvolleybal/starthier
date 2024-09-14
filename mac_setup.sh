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

    DMG_URL="https://sourceforge.net/projects/xampp/files/XAMPP%20Mac%20OS%20X/8.2.4/xampp-osx-8.2.4-0-installer.dmg"
    # DMG_URL="http://localhost/xampp-osx-8.2.4-0-installer.dmg" # For testing purposes
    DMG_NAME="xampp-osx-8.2.4-0-installer.dmg"
    INSTALLER_NAME="xampp-osx-8.2.4-0-installer.app"
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

is_xampp_running() {
    #!/bin/bash

    # Install netcat if it's not already installed
    if ! command -v nc &> /dev/null; then
    echo "Netcat not found, installing..."
    brew install netcat
    fi

    # Function to check if a port is open
    check_port() {
    local port=$1
    nc -z localhost $port
    }

    # Check if MySQL is running on port 3306
    if check_port 3306; then
    echo "MySQL is running on port 3306"
    else
    echo "MySQL is not running on port 3306"
    exit 1
    fi

    # Check if Apache is running on port 80
    if check_port 80; then
    echo "Apache is running on port 80"
    else
    echo "Apache is not running on port 80"
    exit 1
    fi

    # Both services are running
    echo "Both MySQL and Apache are running"

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
        echo "Once you have installed XAMPP and started Apache and MySQL, press Enter to continue..."

        # Wait for user input
        read

        echo "Installation completed."

        # Unmount the .dmg file
        echo "Unmounting $DMG_NAME..."
        hdiutil detach "$MOUNT_POINT"
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
    echo "This is a CLEAN installation without themes or anything. Use admin panel. " 
}

install_teamportal () {
    cd $TARGET_DIR
    git clone https://github.com/skcvolleybal/team-portal
    cd "${TARGET_DIR}/team-portal/"
    npm i 
    cd php
    composer install 
    cp .env.example .env


}


start_teamportal () {
    cd "${TARGET_DIR}/team-portal/"
    npm run ng serve

}

define_variables
install_brew
install_xampp
setup_node_composer_wpcli
download_wordpress_and_plugins
create_wordpress_database
setup_wp_config_file
install_wordpress
install_teamportal
start_teamportal


