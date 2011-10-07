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
# Copyright (C) Paulo Custodio, 2011

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/eol_format.t,v 1.1 2011-10-07 17:22:13 pauloscustodio Exp $
# $Log: eol_format.t,v $
# Revision 1.1  2011-10-07 17:22:13  pauloscustodio
# Convert to UNIX line end format
#
#
# Assert that all source files are in UNIX line-ending format; fix if not

use strict;
use warnings;
use File::Slurp;
use Test::More;
use File::Find;
use File::Basename;
use File::Copy;

find(sub {
	return unless -f $_;
	return unless /^Makefile$|\.(c|h|pl|t|asm)$/i;
	ok dos2unix($_), "$File::Find::name in UNIX end of line format";
    }, dirname($0)."/..");

done_testing;


sub dos2unix {
    my($file) = @_;

    # read file
    my $text = read_file($file, binmode => ':raw');

    # check format
    my $new_text = $text;
    $new_text =~ s/([^\r\n]*)(\r\n|\r|\n)/$1\n/g;
    my $ok = $text eq $new_text;

    if (! $ok) {
	diag "Converting end of line of $file";
	copy($file, "$file.bak");
	write_file($file, {atomic => 1, binmode => ':raw'}, \$new_text);
    }

    return $ok;
}
