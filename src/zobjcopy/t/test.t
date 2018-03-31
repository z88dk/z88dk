#!/usr/bin/perl
#-----------------------------------------------------------------------------
# zobjcopy - manipulate z80asm object files
# Copyright (C) Paulo Custodio, 2011-2018
# License: http://www.perlfoundation.org/artistic_license_2_0
#-----------------------------------------------------------------------------

use Modern::Perl;
use Path::Tiny;
use Test::More;

my $OBJ_FILE_VERSION = "11";

#------------------------------------------------------------------------------
path("test.o")->spew_raw(objfile(
	NAME => "file1",
	EXPR => [
		# type, filename, line_nr, section, asmptr, ptr, target_name, text
		[ 'U', "file1.asm", 123, "text_1", 0, 1, "", "start % 256" ],
	],
	SYMBOLS => [
		# scope, type, section, value, name, def_filename, line_nr
		[ 'L', 'A', "text_1", 0, "start", "file1.asm", 123 ],
	],
	LIBS => [
		# name, ...
		"ext1", "ext2"
	],
	CODE => [
		# section, org, align, code
		[ "text_1", 0, 1, "hello" ]
	],
));

ok -f "test.o";



#unlink "test.o";
done_testing;

#------------------------------------------------------------------------------
# return object file binary representation
sub objfile {
	my(%args) = @_;

	exists($args{ORG}) and die;
	
	my $o = "Z80RMF".$OBJ_FILE_VERSION;

	# store empty pointers; mark position for later
	my $name_addr	 = length($o); $o .= pack("V", -1);
	my $expr_addr	 = length($o); $o .= pack("V", -1);
	my $symbols_addr = length($o); $o .= pack("V", -1);
	my $lib_addr	 = length($o); $o .= pack("V", -1);
	my $code_addr	 = length($o); $o .= pack("V", -1);

	# store expressions
	if ($args{EXPR}) {
		store_ptr(\$o, $expr_addr);
		for (@{$args{EXPR}}) {
			@$_ == 8 or die;
			my($type, $filename, $line_nr, $section, $asmptr, $ptr, $target_name, $text) = @$_;
			$o .= $type . pack_lstring($filename) . pack("V", $line_nr) .
			        pack_string($section) . pack("vv", $asmptr, $ptr) . 
					pack_string($target_name) . pack_lstring($text);
		}
		$o .= "\0";
	}

	# store symbols
	if ($args{SYMBOLS}) {
		store_ptr(\$o, $symbols_addr);
		for (@{$args{SYMBOLS}}) {
			@$_ == 7 or die;
			my($scope, $type, $section, $value, $name, $def_filename, $line_nr) = @$_;
			$o .= $scope . $type . pack_string($section) . 
					pack("V", $value) . pack_string($name) .
					pack_string($def_filename) . pack("V", $line_nr);
		}
		$o .= "\0";
	}

	# store library
	if ($args{LIBS}) {
		store_ptr(\$o, $lib_addr);
		for my $name (@{$args{LIBS}}) {
			$o .= pack_string($name);
		}
	}

	# store name
	store_ptr(\$o, $name_addr);
	$o .= pack_string($args{NAME});

	# store code
	if ( $args{CODE} ) {
		ref($args{CODE}) eq 'ARRAY' or die;
		store_ptr(\$o, $code_addr);
		for (@{$args{CODE}}) {
			@$_ == 4 or die;
			my($section, $org, $align, $code) = @$_;
			$o .= pack("V", length($code)) . 
			        pack_string($section) . 
					pack("VV", $org, $align) . 
					$code;
		}
		$o .= pack("V", -1);
	}

	return $o;
}

#------------------------------------------------------------------------------
# store a pointer to the end of the binary object at the given address
sub store_ptr {
	my($robj, $addr) = @_;
	my $ptr = length($$robj);
	my $packed_ptr = pack("V", $ptr);
	substr($$robj, $addr, length($packed_ptr)) = $packed_ptr;
}

#------------------------------------------------------------------------------
sub pack_string {
	my($string) = @_;
	return pack("C", length($string)).$string;
}

#------------------------------------------------------------------------------
sub pack_lstring {
	my($string) = @_;
	return pack("v", length($string)).$string;
}

