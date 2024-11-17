#!/bin/bash
# (wordpress_)startup.sh


echo "Checking if MySQL is ready..."
/wait-for-it.sh -t 0 mysql_db:3306

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

wp core install --allow-root --url="localhost:8080" --title="SKC WordPress Dev Site" --admin_user="webcie" --admin_email="webcie@skcvolleybal.nl" --admin_password="webcie"

# Run WP-CLI commands here
# Example: Install Pods plugin
echo "Installing Pods plugin..."
wp plugin install pods --allow-root --path=/var/www/html
wp plugin install members --allow-root --path=/var/www/html

# Start Apache in the foreground
apache2-foreground