# docker-nginx-wordpress-auto_install
It will create a Docker image/container with pre-installed PHP7, Nginx, MariaDB, Wordpress, SSH.
Wordpress will be auto installed using wp-cli and wp-config file will be created, visit your container to complete the setup. 

Source: https://github.com/topix-hackademy/docker-nginx-ssh-mysql-php7

# Build the image using 

`docker build -t IMAGE_NAME .`

# Build Container
`docker run -p 8898:80 -p 7272:22 --name CONTAINER_NAME IMAGE_NAME`

# SSH PASS
`topix`

# MySQL Details
### The root password is empty
### WordPress Database details:
`Username: yuli`
`Password: can be found in Container Logs or in mysql-root-pw.txt which is located in root folder of your container`

After setup nginx will restart so wait for few sec before accesing your container.


# Additional Features
## A theme skeleton will be added to themes folder, to include your theme put your theme in 
`wp-content/themes`
## Multiple plugins will be added to plugins fodler, to include your plugins put your plugins in
`wp-content/plugins`



# Upcoming features
+ Install and config ruby, node.
+ Setup gulp, sass, live reload, etc.
+ Setup sendmail.
+ Install logrotate, logwatch and other security enhancements.
