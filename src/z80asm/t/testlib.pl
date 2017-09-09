#------------------------------------------------------------------------------
# Z88DK Z80 Macro Assembler
#
# Plain Perl (no CPAN libraries) test library
#
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#------------------------------------------------------------------------------
use strict;
use warnings;
use v5.10;
use Test::More;
use File::Basename;

# add path to z80asm top directory
my $IS_WIN32 = $^O =~ /MSWin32/;
my $root = dirname(dirname(__FILE__));
$root =~ s!/!\\!g if $IS_WIN32;
$ENV{PATH} = $root . ($IS_WIN32 ? ';' : ':') . $ENV{PATH};


sub slurp {
	my($file) = @_;
	local $/;
	open(my $fh, "<:raw", $file) or die "$file: $!";
	return <$fh>;
}

sub spew {
	my($file, @text) = @_;
	open(my $fh, ">:raw", $file) or die "$file: $!";
	print $fh @text;
}

sub run {
	my($cmd, $return, $out, $err) = @_;
	$return //= 0;
	$out //= '';
	$err //= '';
	
	$cmd .= " >test.stdout 2>test.stderr";
	
	ok 1, $cmd;
	ok !!$return == !!system($cmd), "exit value";
	
	my $gotout = slurp("test.stdout");
	my $goterr = slurp("test.stderr");
	
	if ($out eq "IGNORE") {
		note "test.stdout: ", $gotout;
	}
	else {
		is norm_nl($gotout), norm_nl($out), "test.stdout";
	}
	
	if ($err eq "IGNORE") {
		note "test.stderr: ", $goterr;
	}
	else {
		is norm_nl($goterr), norm_nl($err), "test.stderr";
	}
	
	if (Test::More->builder->is_passing) {
		unlink "test.stdout", "test.stderr";
	}
}

sub norm_nl {
	my(@lines) = @_;
	for (@lines) {
		s/[ \t\r]+\n/\n/g;
	}
	return wantarray ? @lines : join('', @lines);
}

sub hexdump {
	my($str) = @_;
	my $ret = '';
	for (split //, $str) {
		$ret .= sprintf("%02X ", ord($_));
	}
	return $ret;
}

sub unlink_tests {
	if ($ENV{KEEP}) {
		note "kept test files";
	}
	else {
		if (Test::More->builder->is_passing) {
			for (qw(test.asm test.bin test.c test.err test.lis test.map test.o test.out)) {
				-f $_ and ok unlink($_), "unlink $_";
			}
		}
	}
}

sub z80asm {
	my($source, $options) = @_;
	$options //= "-b";
	
	spew("test.asm", $source);
	run("z80asm $options test.asm");
}

sub ticks {
	my($source, $options) = @_;
	z80asm($source, $options);
	my $cpu = ($options =~ /--cpu=(\S+)/) ? $1 : "z80";
	my $end = -s "test.bin";
	run("ticks test.bin -m$cpu -end ".sprintf("%04X", $end)." -output test.out", 0, "IGNORE");
	my $bin = slurp("test.out");
	my $mem = substr($bin, 0, 0x10000); $mem =~ s/\0+$//;
	my @mem = map {ord} split //, $mem;
	my @regs = map {ord} split //, substr($bin, 0x10000);
	my $ret = {
		mem 	=> \@mem, 
	};
	$ret->{F} = shift @regs;	$ret->{F_S}  = ($ret->{F} & 0x80) ? 1 : 0;
								$ret->{F_Z}  = ($ret->{F} & 0x40) ? 1 : 0;
								$ret->{F_H}  = ($ret->{F} & 0x10) ? 1 : 0;
								$ret->{F_PV} = ($ret->{F} & 0x04) ? 1 : 0;
								$ret->{F_N}  = ($ret->{F} & 0x02) ? 1 : 0;
								$ret->{F_C}  = ($ret->{F} & 0x01) ? 1 : 0;
	$ret->{A} = shift @regs;
	$ret->{C} = shift @regs;
	$ret->{B} = shift @regs;	$ret->{BC} = ($ret->{B} << 8) | $ret->{C};
	$ret->{L} = shift @regs;
	$ret->{H} = shift @regs;	$ret->{HL} = ($ret->{H} << 8) | $ret->{L};
	my $PCl = shift @regs;
	my $PCh = shift @regs;		$ret->{PC} = ($PCh << 8) | $PCl;
	my $SPl = shift @regs;
	my $SPh = shift @regs;		$ret->{SP} = ($SPh << 8) | $SPl;
	$ret->{I} = shift @regs;
	$ret->{R} = shift @regs;
	$ret->{E} = shift @regs;
	$ret->{D} = shift @regs;	$ret->{DE} = ($ret->{D} << 8) | $ret->{E};
	$ret->{C_} = shift @regs;
	$ret->{B_} = shift @regs;	$ret->{BC_} = ($ret->{B_} << 8) | $ret->{C_};
	$ret->{E_} = shift @regs;
	$ret->{D_} = shift @regs;	$ret->{DE_} = ($ret->{D_} << 8) | $ret->{E_};
	$ret->{L_} = shift @regs;
	$ret->{H_} = shift @regs;	$ret->{HL_} = ($ret->{H_} << 8) | $ret->{L_};
	$ret->{F_} = shift @regs;	$ret->{F__S}  = ($ret->{F_} & 0x80) ? 1 : 0;
								$ret->{F__Z}  = ($ret->{F_} & 0x40) ? 1 : 0;
								$ret->{F__H}  = ($ret->{F_} & 0x10) ? 1 : 0;
								$ret->{F__PV} = ($ret->{F_} & 0x04) ? 1 : 0;
								$ret->{F__N}  = ($ret->{F_} & 0x02) ? 1 : 0;
								$ret->{F__C}  = ($ret->{F_} & 0x01) ? 1 : 0;
	$ret->{A_} = shift @regs;
	my $IYl = shift @regs;
	my $IYh = shift @regs;		$ret->{IY} = ($IYh << 8) | $IYl;
	my $IXl = shift @regs;
	my $IXh = shift @regs;		$ret->{IX} = ($IXh << 8) | $IXl;
	$ret->{IFF} = shift @regs;
	$ret->{IM} = shift @regs;
	my $MPl = shift @regs;
	my $MPh = shift @regs;		$ret->{MP} = ($MPh << 8) | $MPl;
	@regs == 8 or die;
	
	return $ret;
}

1;
