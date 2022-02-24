# change the limit ofopen files in nginx config

exec {'change limit':
  command  => "ulimit -Hn #hard 4096 && ulimit -Sn #soft 4096",
  provider => shell
}
