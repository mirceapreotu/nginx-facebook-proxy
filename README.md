# nginx-facebook-proxy


## Installation

1) Download and install nginx (version >= 1.5.4)

2) Extract all dependencies from lib directory to /usr/local/lib

3) Install Perl with development libs

apt-get install perl perl-base perl-modules libperl-dev
cpan JSON

4) Switch to nginx directory and run

./configure --prefix=/opt/nginx --add-module=/usr/local/lib/memc-nginx-module-0.13/ --prefix=/usr/local/nginx --with-http_ssl_module --with-pcre --conf-path=/usr/local/nginx/nginx.conf --pid-path=/usr/local/nginx/nginx.pid --lock-path=/usr/local/nginx/nginx.lock --add-module=/usr/local/lib/echo-nginx-module-0.47/ --add-module=/usr/local/lib/ngx_devel_kit-master/ --add-module=/usr/local/lib/form-input-nginx-module-master --with-http_perl_module --with-http_stub_status_module

make -j2

make install
