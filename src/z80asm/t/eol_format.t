#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm
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
		dos2unix($_) if /^Makefile$|\.(c|h|pl|pm|t|asm|rl|bmk|def|yaml|in|tt)$/i;
		unix2dos($_) if /\.bat$/i;
	}, dirname($0)."/..");
ok 1;

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

sub filter {
	my($file, $sub) = @_;
	
	# read file
	my $text = read_file($file, binmode => ':raw');

	# check format
	my $new_text = $sub->($text);
	my $ok = $text eq $new_text;

	if (! $ok) {
		note "Converting end of line of $file";
		write_file($file, {atomic => 1, binmode => ':raw'}, \$new_text);
	}

	return $ok;
}

sub dos2unix {
	my($file) = @_;

	return filter($file, sub { local $_ = shift; 
						s/([^\r\n]*)(\r\n|\r|\n)/$1\n/g;
						s/([^\n])\z/$1\n/;
						$_;
		});
}

sub unix2dos {
	my($file) = @_;

	return filter($file, sub { local $_ = shift; 
						s/([^\r\n]*)(\r\n|\r|\n)/$1\r\n/g;
						s/([^\r][^\n])\z/$1\r\n/;
						$_;
		});
}

