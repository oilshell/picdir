#!/usr/bin/env bash
#
# Usage:
#   ./run.sh <function name>

set -o nounset
set -o pipefail
set -o errexit

# Got this working:
#
# https://www.geekality.net/2011/05/01/php-how-to-proportionally-resize-an-uploaded-image/
# http://samples.geekality.net/image-resize/

# https://stackoverflow.com/questions/13338339/imagecreatefromjpeg-and-similar-functions-are-not-working-in-php
deps() {
  sudo apt install php php-gd

  # for php_codesniffer, weird.  Except that code sucks.
  # sudo apt install php-xml
}

export IMAGEBIN_UPLOAD_DIR="$PWD/_tmp/uploads"
export IMAGEBIN_CACHE_DIR="$PWD/_tmp/cache"

serve() {
  mkdir -p $IMAGEBIN_UPLOAD_DIR $IMAGEBIN_CACHE_DIR
  php -S localhost:8991
}

deploy() {
  local name=$1

  local host=$name@$name.org
  local dir=$name.org/imagebin/

  ssh $host mkdir -v -p $dir

  scp imagebin.php index.html $host:$dir
}

lint() {
  php -l *.php
}

# https://getcomposer.org/download/
install-composer() {
  wget https://getcomposer.org/installer
  php installer
}

# it automatically installs here
composer() {
  ./composer.phar "$@"
}

# https://github.com/FriendsOfPHP/PHP-CS-Fixer

# Hm this doesn't fix style.

install-fixer() {
  mkdir --parents tools/php-cs-fixer
  composer require --working-dir=tools/php-cs-fixer friendsofphp/php-cs-fixer
}

fixer() {
  tools/php-cs-fixer/vendor/bin/php-cs-fixer "$@"
}

# requires php-xml package
install-sniffer() {
  mkdir -p tools/php_codesniffer
  composer require --working-dir tools/php_codesniffer "squizlabs/php_codesniffer=*"
}

cbf() {
  tools/php_codesniffer/vendor/bin/phpcbf "$@"
}

"$@"
