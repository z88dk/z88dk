#!/usr/bin/perl

# test standard loop vs faster loop 
# see https://github.com/z88dk/z88dk/issues/1911

use Modern::Perl;
use Test::More;
use Path::Tiny;

sub old_loop {
	my($bc) = @_;
	my $count = 0;
	loop:
		$count++;
		
		$bc = ($bc-1) & 0xffff;						# dec bc
		my $a = (($bc>>8) & 0xff) | ($bc & 0xff);	# ld a, b \ or c
		goto loop if $a!=0;							# jr nz, loop
	
	return $count;
}

sub new_loop {
	my($bc) = @_;
	my $count = 0;
	
	$bc = ($bc-1) & 0xffff;							# dec bc
	my $b = ($bc >> 8) & 0xff;
	my $c = $bc & 0xff;
	$b = ($b+1) & 0xff;								# inc b
	$c = ($c+1) & 0xff;								# inc c
	loop:
		$count++;
		
		$c = ($c-1) & 0xff;							# dec c
		goto loop if $c!=0;							# jr nz,loop
		$b = ($b-1) & 0xff;							# djnz ...
		goto loop if $b!=0;							# ... loop
		
	return $count;
}

# functional test
for my $count (1, 255, 256, 257, 65535, 65536) {
	is old_loop($count), $count;
	is new_loop($count), $count;
}

# performance test - Copy a ZX Spectrum screen
path("test-old.asm")->spew(<<'END');
		ld 		hl, 0x8000
		ld 		de, 0x4000
		ld 		bc, 32*192
loop:
IF  __CPU_GBZ80__
        ld      a, (hl+)
ELSE
        ld      a, (hl)
        inc     hl
ENDIF
        ld      (de), a
        inc     de
		
		dec		bc
		ld		a, b
		or		c
		jr 		nz, loop
		ret
END

path("test-new.asm")->spew(<<'END');
		ld 		hl, 0x8000
		ld 		de, 0x4000
		ld 		bc, 32*192

		; setup loop
		dec 	bc			
		inc 	b 
		inc 	c 
loop:
IF  __CPU_GBZ80__
        ld      a, (hl+)
ELSE
        ld      a, (hl)
        inc     hl
ENDIF
        ld      (de), a
        inc     de
		
        ; iterate
		dec 	c       
		jr 		nz,loop 
		djnz    loop 
		ret
END

my %data;
for my $cpu (qw( 8080 8085 gbz80 r2ka z180 z80 z80n )) {
	for my $test ("test-old", "test-new") {
		# assemble
		run("z88dk-z80asm -b -l -m$cpu $test.asm");
		
		# get end address
		for (path("$test.lis")->lines) {
			if (/^\d+\s+([0-9A-F]{4})\s+C9\s+ret/) { 
				$data{$cpu}{$test}{end} = $1; 
				last; 
			}
		}
		defined($data{$cpu}{$test}{end}) or die "end address not found\n";
		
		# run ticks
		run("z88dk-ticks -m$cpu -start 0000 -end $data{$cpu}{$test}{end} ".
		    "$test.bin >$test.out");
		my $t = path("$test.out")->slurp;
		$t =~ /^(\d+)\s*$/ or die "expected ticks count, got $t\n";
		$data{$cpu}{$test}{ticks} = 0+$t;
		
		unlink("$test.o","$test.lis","$test.bin","$test.out");
	}
	$data{$cpu}{speed_increase} = $data{$cpu}{"test-new"}{ticks}
					            / $data{$cpu}{"test-old"}{ticks};
}
unlink("test-old.asm","test-new.asm");

# output data
use Data::Dump 'dump';
diag dump \%data;

done_testing;

sub run {
	my($cmd) = @_;
	local $Test::Builder::Level = $Test::Builder::Level + 1;
	ok 0==system($cmd), $cmd;
}
