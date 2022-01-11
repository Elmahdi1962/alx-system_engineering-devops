# add stable version of nginx
# exec { 'add nginx stable repo':
#   command => 'sudo add-apt-repository ppa:nginx/stable',
#   path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
# }

# update software packages list
exec { 'update packages':
  command => 'apt-get -y update',
  provider => shell,
}

# install nginx
package { 'nginx':
  ensure  => 'installed',
}

# allow HTTP
exec { 'allow HTTP':
  command => "ufw allow 'Nginx HTTP'",
  provider => shell,
}

# create index file
file { '/var/www/html/index.html':
  content => "Hello World!\n",
}

# create index file
file { '/var/www/html/404.html':
  content => "Ceci n'est pas une page\n",
}

# change folder rights
exec { 'chmod':
  command => 'chmod -R 755 /var/www',
  provider => shell,
}

# add redirection and error page
file { 'Nginx default config file':
  ensure   => file,
  provider => shell,
  path     => '/etc/nginx/sites-available/default',
  content  =>
"server {
        listen 80 default_server;
        listen [::]:80 default_server;
        root /var/www/html;

        # Add index.php to the list if you are using PHP
        index index.html index.htm index.nginx-debian.html;

        server_name _;
        add_header X-Served-By \$hostname;
        location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                try_files \$uri \$uri/ =404;
        }

        error_page 404 /404.html;
        location  /404.html {
            internal;
        }
        
        if (\$request_filename ~ redirect_me){
            rewrite ^ https://www.youtube.com/watch?v=QH2-TGUlwu4 permanent;
        }
}
",
}
# restart nginx
exec { 'restart service':
  command => 'service nginx restart',
  provider => shell,
}

# start service nginx
service { 'nginx':
  ensure  => running,
  require => Package['nginx'],
}
