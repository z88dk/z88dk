#!/usr/bin/perl

# z80asm2 tests
#
# Copyright (C) Paulo Custodio, 2011-2019
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/

use Modern::Perl;
use Test::More;
use Path::Tiny;
use Config;
use Test::Cmd::Common;

# run z80asm2 from .
$ENV{PATH} = ".".$Config{path_sep}.$ENV{PATH};

sub norm_nl { local $_ = shift; s/\r\n/\n/g; return $_; }

my $test = Test::Cmd::Common->new(
	string => "scanner tests", 
	prog => "z80asm2", workdir => '');

sub assemble {
	my($asm, $bin) = @_;
	my $ok;
	
	$test->write("test.asm", $asm);
	unlink "test.bin";
	$test->run(args => "test.asm", stdout => "", stderr => "");
	$ok = -f "test.bin";
	ok $ok, "test.bin exists";
	if ($ok) {
		my $got = path("test.bin")->slurp_raw;
		$ok = $got eq $bin;
		ok $ok, "test.bin contents ok";
		system("z88dk-dis test.bin") unless $ok;
	}
}

sub test {
	my($asm, $bin) = @_;
	assemble(lc($asm), $bin);
	assemble(uc($asm), $bin);
}

sub error {
	my($asm, $error) = @_;
	$test->write("test.asm", $asm);
	unlink "test.bin";
	$test->run(args => "test.asm", fail => '$? == 0', stdout => "", stderr => undef);
	is norm_nl($test->stderr), $error, "stderr";
	my $ok = !-f "test.bin";
	ok $ok, "test.bin not created";
}

# test numbers
test("ld a,0", pack("C*", 0x3e, 0));
error("ld a,0z", "Error at test.asm line 1: Invalid number\n");
error("ld a,0_", "Error at test.asm line 1: Invalid number\n");
test("ld a,255", pack("C*", 0x3e, 0xff));
test("ld bc,255d", pack("C*", 0x01, 0xff, 0x00));

test("ld a,0ffh", pack("C*", 0x3e, 0xff));
test("ld a,#0ff", pack("C*", 0x3e, 0xff));
test("ld a,\$0ff", pack("C*", 0x3e, 0xff));
test("ld a,0xff", pack("C*", 0x3e, 0xff));
error("ld a,0xffg", "Error at test.asm line 1: Invalid number\n");
error("ld a,0xff_", "Error at test.asm line 1: Invalid number\n");
test("ld bc,255h", pack("C*", 0x01, 0x55, 0x02));

test("ld bc,0b0ah", pack("C*", 0x01, 0x0a, 0x0b));	# hex
test("ld bc,0b010", pack("C*", 0x01, 0x02, 0x00));	# bin
test("ld bc,010b", pack("C*", 0x01, 0x02, 0x00));

test("ld bc,%010", pack("C*", 0x01, 0x02, 0x00));
test("ld bc,\@010", pack("C*", 0x01, 0x02, 0x00));
test("ld bc,%'-#-'", pack("C*", 0x01, 0x02, 0x00));
test("ld bc,%\"-#-\"", pack("C*", 0x01, 0x02, 0x00));
test("ld bc,\@'-#-'", pack("C*", 0x01, 0x02, 0x00));
test("ld bc,\@\"-#-\"", pack("C*", 0x01, 0x02, 0x00));

error("ld bc,\@'-#-", "Error at test.asm line 1: Invalid number\n");
error("ld bc,\@\"-#-", "Error at test.asm line 1: Invalid number\n");
error("ld bc,%'-#-", "Error at test.asm line 1: Invalid number\n");
error("ld bc,%\"-#-", "Error at test.asm line 1: Invalid number\n");
error("ld bc,%\"-#-?\"", "Error at test.asm line 1: Invalid number\n");

test("ld a,0q377", pack("C*", 0x3e, 0xff));
test("ld a,0o377", pack("C*", 0x3e, 0xff));
test("ld a,377o", pack("C*", 0x3e, 0xff));
test("ld a,377q", pack("C*", 0x3e, 0xff));

done_testing();
