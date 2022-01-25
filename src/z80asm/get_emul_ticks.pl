#!/usr/bin/perl

# assemble instruction given in command line (separated by ':'), get ticks in all CPUs
# for carry clear and carry set

use Modern::Perl;
use Path::Tiny;
use Text::Table;
use Config;

# make sure to use our z80asm
$ENV{PATH} = join($Config{path_sep}, ".", "../ticks", $ENV{PATH});

my $asm = "@ARGV\n"; $asm =~ s/\s*:\s*/\n/g;
my $tb = Text::Table->new(";", "CPU", "Min T", "Max T");
for my $cpu (qw( 8080 8085 gbz80 r2ka z180 z80 z80n )) {
	my @T;
	for my $carry (0..1) {
		path("test.asm")->spew(
			($carry ? "scf\n" : "and a\n"),
			$asm,
			"nop ; END\n");
		run("z88dk-z80asm -b -l -m$cpu test.asm");
		# get end address
		my $end;
		for (path("test.lis")->lines) {
			if (/^\s*\d+\s+([0-9A-F]{6})\s+00\s+nop ; END/) { $end = $1; last; }
		}
		defined($end) or die "end address not found\n";
		# end=1: skip and a/scf in ticks count
		run("z88dk-ticks -m$cpu -start 0001 -end $end test.bin >test.out");	
		my $t = path("test.out")->slurp;
		$t =~ /^(\d+)\s*$/ or die "expected ticks count, got $t\n";
		push @T, 0+$1;
	}
	@T = sort {$a <=> $b} @T;
	$tb->add(";", $cpu, @T);
}
say "\nResults\n", $tb;
unlink "test.asm", "test.bin", "test.lis", "test.o", "test.out";


sub run {
	my($cmd) = @_;
	say $cmd;
	system($cmd)==0 or die "Command failed\n";
}
