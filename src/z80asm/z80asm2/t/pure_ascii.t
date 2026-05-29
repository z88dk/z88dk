#!/usr/bin/env perl

use Modern::Perl;
use Test::More;
use Test::PureASCII;
use File::Find;

find(
    sub {
        return unless -f $_;
        return unless /\.(cpp|h|c|re|pl|t|pm|txt|md|asm|inc)$/;
        file_is_pure_ascii( { forbid_control => 1, forbid_cr => 1 }, $_ );
    },
    "."
);

done_testing;
