#!/usr/bin/env bash

git submodule update --init --recursive
sudo apt-get install -y build-essential bison flex libxml2-dev subversion zlib1g-dev m4 ragel re2c dos2unix texinfo texi2html gdb curl perl cpanminus ccache libboost-all-dev libmodern-perl-perl libyaml-perl liblocal-lib-perl libcapture-tiny-perl libpath-tiny-perl libtext-table-perl libdata-hexdump-perl libregexp-common-perl libclone-perl libfile-slurp-perl
cpanm --local-lib=~/perl5 App::Prove CPU::Z80::Assembler Data::Dump Data::HexDump File::Path List::Uniq Modern::Perl Object::Tiny::RW Regexp::Common Test::Harness Text::Diff Text::Table YAML::Tiny
eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
#export BUILD_SDCC=1
#export BUILD_SDCC_HTTP=1
chmod 777 build.sh
./build.sh -l
