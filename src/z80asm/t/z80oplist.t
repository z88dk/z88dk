#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Paulo Custodio, 2011-2022
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk/
#
# Test additional opcodes from http://www.z80.info/z80oplist.txt

use Modern::Perl;
use Test::More;
use Path::Tiny;
require './t/testlib.pl';

unlink_testfiles();
test_asm(<<END, "");
        out (c),f       ; ED 71
        out (c),0       ; ED 71

        sll b           ; CB 30
        sll c           ; CB 31
        sll d           ; CB 32
        sll e           ; CB 33
        sll h           ; CB 34
        sll l           ; CB 35
        sll (hl)        ; CB 36
        sll a           ; CB 37

        sls b           ; CB 30
        sls c           ; CB 31
        sls d           ; CB 32
        sls e           ; CB 33
        sls h           ; CB 34
        sls l           ; CB 35
        sls (hl)        ; CB 36
        sls a           ; CB 37

		res 0,(iy+1),b ; FD CB 01 80    
		res 0,(iy+1),c ; FD CB 01 81   
		res 0,(iy+1),d ; FD CB 01 82   
		res 0,(iy+1),e ; FD CB 01 83   
		res 0,(iy+1),h ; FD CB 01 84   
		res 0,(iy+1),l ; FD CB 01 85   
		res 0,(iy+1)   ; FD CB 01 86  
		res 0,(iy+1),a ; FD CB 01 87   

		set 0,(iy+1),b ; FD CB 01 C0    
		set 0,(iy+1),c ; FD CB 01 C1   
		set 0,(iy+1),d ; FD CB 01 C2   
		set 0,(iy+1),e ; FD CB 01 C3   
		set 0,(iy+1),h ; FD CB 01 C4   
		set 0,(iy+1),l ; FD CB 01 C5   
		set 0,(iy+1)   ; FD CB 01 C6  
		set 0,(iy+1),a ; FD CB 01 C7   

END

#unlink_testfiles();
done_testing();

sub test_asm {
	my($code, $options) = @_;
	my @asm;
	my @bin;
	for (split(/\n/, $code)) {
		chomp;
		my($bytes) = /;(.*)/;
		push @asm, "$_\n";
		push @bin, map {$_ = hex($_)} split(' ', $bytes) if $bytes;
	}
	z80asm(join('', @asm), "$options -b -l", 0, "", "");
	check_bin_file("test.bin", pack("C*", @bin));
}
