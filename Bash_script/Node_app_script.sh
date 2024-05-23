
echo "Script started..."

read -p "Enter github repo link: " project

install_git(){
	echo "Installing git..."
        sudo apt-get update
	sudo apt install git

}


echo $project
clone (){

	echo "Clonning project..."
  git clone  $project node_app
}

install_server_dependencies(){
     
	echo "Installing server deppendencies..."
	sudo apt install nodejs -y
	sudo apt install npm -y
	sudo apt install apache2 -y
	echo "server dependencies installed successfully..."

}


install_app_dependencies(){
	echo "installing app dependencies"
	cd node_app
        sudo npm i -y
        echo "App dependecies installed successfully..."
}

deploy(){
	node index.js 
}

reverse_proxy(){
   echo "Configuring apache..."
	#Apache Reverse proxy config
	sudo a2enmod proxy -y
        sudo a2enmod proxy_http
        sudo a2enmod proxy_balancer
        sudo a2enmod lbmethod_byrequests

    sudo touch  /etc/apache2/sites-available/myreverseproxy.conf

    FILENAME=/etc/apache2/sites-available/myreverseproxy.conf
    
    sudo chmod 700 $FILENAME 

    echo "File name"
    echo $FILENAME

     sudo bash -c "cat > $FILENAME <<EOL
<VirtualHost *:80>
    ServerName localhost

    ProxyPreserveHost On
    ProxyPass / http://localhost:3000/
    ProxyPassReverse / http://localhost:3000/

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOL"

sudo a2ensite myreverseproxy.conf
sudo systemctl restart apache2



}


if ! clone 
then
	echo "Invalid git url"
	exit 1
fi

install_git
clone
install_server_dependencies
install_app_dependencies
reverse_proxy
deploy
