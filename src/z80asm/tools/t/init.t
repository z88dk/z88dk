#!/usr/bin/perl

#     ZZZZZZZZZZZZZZZZZZZZ    8888888888888       00000000000
#   ZZZZZZZZZZZZZZZZZZZZ    88888888888888888    0000000000000
#                ZZZZZ      888           888  0000         0000
#              ZZZZZ        88888888888888888  0000         0000
#            ZZZZZ            8888888888888    0000         0000       AAAAAA         SSSSSSSSSSS   MMMM       MMMM
#          ZZZZZ            88888888888888888  0000         0000      AAAAAAAA      SSSS            MMMMMM   MMMMMM
#        ZZZZZ              8888         8888  0000         0000     AAAA  AAAA     SSSSSSSSSSS     MMMMMMMMMMMMMMM
#      ZZZZZ                8888         8888  0000         0000    AAAAAAAAAAAA      SSSSSSSSSSS   MMMM MMMMM MMMM
#    ZZZZZZZZZZZZZZZZZZZZZ  88888888888888888    0000000000000     AAAA      AAAA           SSSSS   MMMM       MMMM
#  ZZZZZZZZZZZZZZZZZZZZZ      8888888888888       00000000000     AAAA        AAAA  SSSSSSSSSSS     MMMM       MMMM
#
# Copyright (C) Paulo Custodio, 2011-2013
#
# Test class

use Modern::Perl;
use Test::More;
use Capture::Tiny 'capture';
use Test::Differences; 

unlink "t/init.c", "t/init.h";
ok ! system "make -C t";
my($stdout, $stderr, $return) = capture {
	system 't/main';
};

ok !$return;

eq_or_diff_text $stdout, <<'END';
init_1()
init_2()
main start
Person init name=Jack, age=33, allocated memory
person Jack, age 33
leak person
Person init name=Ripper, age=34, allocated memory
person Ripper, age 34
Hello world
Person fini Ripper, freed memory
person = 0
main end
Person fini Jack, freed memory
fini_3()
fini_1()
END

eq_or_diff_text $stderr, <<'END';
END

done_testing;
