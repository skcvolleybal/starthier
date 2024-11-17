#!/bin/bash
# (wordpress_)startup.sh

# Function to check if MySQL is ready
check_mysql_ready() {
    echo "Checking if MySQL is ready..."
    /wait-for-it.sh mysql_db:3306
}

# Check MySQL readiness
check_mysql_ready

echo "MySQL is ready"

# Ensure WP-CLI is installed
install_wp_cli() {
  echo "Checking if WP-CLI is installed..."
  if ! command -v wp &> /dev/null; then
    echo "WP-CLI not found. Installing..."
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp
    echo "WP-CLI installed successfully."
  else
    echo "WP-CLI is already installed."
  fi
}

# Install WP-CLI if needed
install_wp_cli

# Run WP-CLI commands here
# Example: Install Pods plugin
echo "Installing Pods plugin..."
wp plugin install pods --allow-root --path=/var/www/html

# Start Apache in the foreground
apache2-foreground