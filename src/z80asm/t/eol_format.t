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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/eol_format.t,v 1.6 2013-01-20 21:24:29 pauloscustodio Exp $
# $Log: eol_format.t,v $
# Revision 1.6  2013-01-20 21:24:29  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.5  2012/05/11 19:40:53  pauloscustodio
# note() instead of diag() for messages not to be shown during prove
#
# Revision 1.4	2011/10/10 18:24:18  pauloscustodio
# convert CVS files to UNIX format : do not convert the CVS directories - only for internal
#  use
#
# Revision 1.3	2011/10/07 18:21:47  pauloscustodio
# Don't fail the test if any of the CVS files in not in UNIX format
#
# Revision 1.2	2011/10/07 18:18:36  pauloscustodio
# Convert CVS files also to UNIX line ending, so that source files are not converted
# back to DOS format on checkin
#
# Revision 1.1	2011/10/07 17:22:13  pauloscustodio
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

find(sub {
		return unless -f $_;
		return unless /^Makefile$|\.(c|h|pl|t|asm)$/i;
		ok dos2unix($_), "$File::Find::name in UNIX end of line format";
	}, dirname($0)."/..");

# convert CVS files to UNIX format
if (0) {
	my @CVS_dirs;
	find(sub {
			return unless -d $_;
			return unless /^CVS$/i;
			push @CVS_dirs, $File::Find::name;
		}, dirname($0)."/../../..");

	find(sub {
			return unless -f $_;
			ok 1, "$File::Find::name in UNIX end of line format";
		}, @CVS_dirs);

}

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
		note "Converting end of line of $file";
		write_file($file, {atomic => 1, binmode => ':raw'}, \$new_text);
	}

	return $ok;
}

