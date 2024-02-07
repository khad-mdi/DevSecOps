#!/bin/bash
infisical export --token=st.65a699a9d3fe7eb4f26007b7.0231bbb5ba19d15fe610df8e8de00505.056b30590fcefe4cfcbe8ced1327639a -e=dev --format=dotenv-export > .env
source .env
echo "$DEV_PRIVATE_KEY" > private_key.pem
chmod 600 private_key.pem
ssh -i "private_key.pem" $AWS_DEV_USER@$AWS_DEV_HOST.compute-1.amazonaws.com "
# Install PHP
sudo yum install -y php php-cli php-fpm php-mysqlnd php-mbstring php-xml php-json php-common php-gd

# Install Git
sudo yum install -y git;

# Install Apache
sudo yum install -y httpd;

# Install Composer
php -r \"copy('https://getcomposer.org/installer', 'composer-setup.php');\"
php composer-setup.php --install-dir=/usr/local/bin --filename=composer;
rm composer-setup.php
git clone https://$GIT_CLONE_TOKEN@github.com/$GIT_USERNAME/$GIT_REPOSITORY.git

# Install Infisical
curl -1sLf 'https://dl.cloudsmith.io/public/infisical/infisical-cli/setup.rpm.sh' | sudo bash
sudo yum install infisical -y

# Start Apache
sudo sed -i 's!/var/www/html!/var/www/html/public!g' /etc/httpd/conf/httpd.conf
sudo systemctl start httpd

# Init setup
cd devsecops
composer install
sudo cp -R . /var/www/html/
"
# Remove everything
rm private_key.pem
rm -rf .env
