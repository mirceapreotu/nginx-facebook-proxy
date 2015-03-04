#!/bin/bash

echo ""
echo "Installing nginx with Facebook proxy support"
echo ""

self="${0#./}"
install_dir=`cd "${self%/*}/../"; pwd`  
libs_dir="/usr/local/lib"
src_dir="/usr/local/src"

echo "setting up dependencies ..."
apt-get install perl perl-base perl-modules libperl-dev
cpan JSON

echo "setting up libs ..."
tar -xzvf $install_dir/libs/echo-nginx-module-0.47.tar.gz -C $libs_dir
tar -xzvf $install_dir/libs/form-input-nginx-module-master.tgz -C $libs_dir
tar -xzvf $install_dir/libs/memc-nginx-module-0.13.tar.gz -C $libs_dir
tar -xzvf $install_dir/libs/ngx_devel_kit-master.tgz -C $libs_dir

echo "unpacking & installing nginx ..."
tar -xzvf $install_dir/libs/nginx-1.5.5.tar.gz -C $src_dir
cd $src_dir/nginx-1.5.5
./configure --prefix=/opt/nginx --add-module=/usr/local/lib/memc-nginx-module-0.13/ --prefix=/usr/local/nginx --with-http_ssl_module --with-pcre --conf-path=/usr/local/nginx/nginx.conf --pid-path=/usr/local/nginx/nginx.pid --lock-path=/usr/local/nginx/nginx.lock --add-module=/usr/local/lib/echo-nginx-module-0.47/ --add-module=/usr/local/lib/ngx_devel_kit-master/ --add-module=/usr/local/lib/form-input-nginx-module-master --with-http_perl_module --with-http_stub_status_module
make -js
make install

echo "setting up nginx ..."
cd $install_dir
cp -R conf.d modules nginx.conf sites-available sites-enabled /usr/local/nginx
mkdir /var/log/nginx
mkdir /tmp/nginx

echo "done !"