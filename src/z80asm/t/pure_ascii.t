#!/usr/bin/env perl

use Modern::Perl;
use Test::More;
use Test::PureASCII;
use File::Find;

find(
    sub {
        return unless -f $_;
        return if /^test_t/;    # ignore test files
        return unless /\.(cpp|h|c|def|re|rl|lst|lis|pl|t|pm|txt|md|asm|inc|m4|AZM|HEX|PRN)$/;
        file_is_pure_ascii( { forbid_control => 1, forbid_cr => 1 }, $_ );
    },
    "."
);

done_testing;
