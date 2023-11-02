#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# https://github.com/z88dk/z88dk/issues/1177
# z80asm - wrong parse of expressions with parenthesis

z80asm_ok("", "", "", 
	'ld bc,   ($2A << 8) + $ff'		=> bytes(0x01, 0xff, 0x2a),
	'ld bc,  (($2A << 8) + $ff)'	=> bytes(0xed, 0x4b, 0xff, 0x2a),
	'ld bc, +(($2A << 8) + $ff)'	=> bytes(0x01, 0xff, 0x2a),
	'ld bc,   ([1]) + [(2)]'		=> bytes(0x01, 0x03, 0x00),
	'ld bc,   [(1)] + [(2)]'		=> bytes(0x01, 0x03, 0x00),
	'ld bc,   ([1]) + ([2])'		=> bytes(0x01, 0x03, 0x00),
	'ld bc,   [(1)] + ([2])'		=> bytes(0x01, 0x03, 0x00),
	'ld bc,   [$2A << 8] + $ff'		=> bytes(0x01, 0xff, 0x2a),
	'ld bc,  [[$2A << 8] + $ff]'	=> bytes(0xed, 0x4b, 0xff, 0x2a),
	'ld bc, +[[$2A << 8] + $ff]'	=> bytes(0x01, 0xff, 0x2a),
);

unlink_testfiles;
done_testing;
