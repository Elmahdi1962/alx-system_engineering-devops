# update software packages list
exec { 'update packages':
  command => 'apt-get -y update',
  provider => shell,
}

# install
exec { 'install nginx':
  command => 'apt-get -y install nginx',
  provider => shell,
}

# update config
exec { 'command':
  command => 'sudo sed -i "/listen 80 default_server;/a add_header X-Served-By $HOSTNAME;" /etc/nginx/sites-available/default',
  provider => shell,
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
