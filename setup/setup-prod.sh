#!/bin/bash
infisical export --token=st.9b120bd4-6fbf-4ba4-904b-05c5c520751f.1922e1e46dac22d4c52764be17cc11f4.1eca91bc8b3576caa5a41b8ada2851bf -e=prod --format=dotenv-export > .env
source .env
echo "$PROD_PRIVATE_KEY" > private_key.pem
chmod 600 private_key.pem
ssh -i "private_key.pem" $AWS_PROD_USER@$AWS_PROD_HOST.compute-1.amazonaws.com "
# Install PHP
sudo yum install -y php php-cli php-fpm php-mysqlnd php-mbstring php-xml php-json php-common php-gd

# Install Git
sudo yum install -y git;

# Install Apache
sudo yum install -y httpd;

# Install Composer
php -r \"copy('https://getcomposer.org/installer', 'composer-setup.php');\"
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer;
git clone https://$GIT_CLONE_TOKEN@github.com/$GIT_USERNAME/$GIT_REPOSITORY.git

# Install Infisical
curl -1sLf 'https://dl.cloudsmith.io/public/infisical/infisical-cli/setup.rpm.sh' | sudo bash
sudo yum install infisical -y

# Init setup
cd DevSecOps
composer install
sudo cp -R . /var/www/html/

# Start Apache
sudo sed -i 's!/var/www/html!/var/www/html/public!g' /etc/httpd/conf/httpd.conf
sudo systemctl start httpd


"
# Remove everything
rm private_key.pem
rm -rf .env
