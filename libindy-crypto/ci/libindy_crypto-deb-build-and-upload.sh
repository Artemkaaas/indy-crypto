#!/bin/bash -xe

if [ "$1" = "--help" ] ; then
  echo "Usage: <version> <type> <number>"
  return
fi

version="$1"
type="$2"
number="$3"

[ -z $version ] && exit 1
[ -z $type ] && exit 2
[ -z $number ] && exit 3

sed -i -E -e 'H;1h;$!d;x' -e "s/libindy-crypto ([(,),0-9,.]+)/libindy-crypto ($version)/" debian/changelog

dpkg-buildpackage -tc

rename -v "s/$version/$version-$number/" ../*.deb

mkdir debs &&  mv ../*.deb ./debs/

./sovrin-packaging/upload_debs.py ./debs $type