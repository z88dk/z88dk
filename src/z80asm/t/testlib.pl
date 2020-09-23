#------------------------------------------------------------------------------
# Z88DK Z80 Macro Assembler
#
# Plain Perl (no CPAN libraries) test library
#
# Copyright (C) Paulo Custodio, 2011-2019
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#------------------------------------------------------------------------------
use Modern::Perl;
use Config;
use Test::More;
use Cwd qw( cwd abs_path );
use File::Basename;
use File::Path 'remove_tree';

my @TEST_EXT = qw( asm bin c d dat def err inc lis lst map o P out sym tap );

# run z80asm from .
$ENV{PATH} = ".".$Config{path_sep}.$ENV{PATH};

# add path to z80asm top directory
_prepend_path(_root());

#------------------------------------------------------------------------------
# Portability
#------------------------------------------------------------------------------

# return the top directory of z80asm
sub _root {
	our $root;
	$root or $root = abs_path(dirname(dirname(__FILE__)));
	return $root
}

sub _prepend_path {
	my($dir) = @_;
	$ENV{PATH} = $dir . $Config{path_sep} . $ENV{PATH};
}

#------------------------------------------------------------------------------
# Build z88dk tools
#------------------------------------------------------------------------------

sub _build_tool {
	my($tool) = @_;
	our %have_built;
	
	unless ($have_built{$tool}) {
		note "Building $tool";
		
		my $dir = cwd();
		chdir _root()."/../$tool" or die;
		
		my $tool_dir = abs_path(cwd());
		
		# cannot make -C because make does not understand \\ in filenames
		run("make", 0, 'IGNORE', 'IGNORE');	
		
		chdir $dir or die;
		
		_prepend_path($tool_dir);
		
		$have_built{$tool}++;
	}
}

sub build_appmake {	_build_tool('appmake'); }
sub build_ticks	{	_build_tool('ticks');	}
sub build_z80nm {	_build_tool('z80nm');	}

#------------------------------------------------------------------------------
# Run tools
#------------------------------------------------------------------------------

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
		check_text($gotout, $out, "test.stdout");
	}
	
	if ($err eq "IGNORE") {
		note "test.stderr: ", $goterr;
	}
	else {
		check_text($goterr, $err, "test.stderr");
	}
	
	if (Test::More->builder->is_passing) {
		unlink "test.stdout", "test.stderr";
	}
}

sub z80asm {
	my($source, $options, $return, $out, $err) = @_;
	$options //= "-b";
	
	spew("test.asm", $source);
	run("z80asm $options test.asm", $return, $out, $err);
}

sub appmake {
	my($args) = @_;
	
	build_appmake();
	run("z88dk-appmake $args", 0, 'IGNORE');
}

sub ticks {
	my($source, $options) = @_;

	build_ticks();
	z80asm($source, $options." -b");
	
	my $cpu = ($options =~ /(?:-m=?)(\S+)/) ? $1 : "z80";
	run("z88dk-ticks test.bin -m$cpu -output test.out", 
		0, "IGNORE");

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

sub parity {
	my($a) = @_;
	my $bits = 0;
	$bits++ if $a & 0x80;
	$bits++ if $a & 0x40;
	$bits++ if $a & 0x20;
	$bits++ if $a & 0x10;
	$bits++ if $a & 0x08;
	$bits++ if $a & 0x04;
	$bits++ if $a & 0x02;
	$bits++ if $a & 0x01;
	return ($bits & 1) == 0 ? 1 : 0;
}

sub z80nm {
	my($file, $out) = @_;
	
	build_z80nm();
	run("z80nm -a $file", 0, $out);
}

#------------------------------------------------------------------------------
# Read and write files
#------------------------------------------------------------------------------

sub slurp {
	my($file) = @_;
	ok -f $file, $file;
	local $/;
	open(my $fh, "<:raw", $file) or die "$file: $!";
	return <$fh> // "";
}

sub spew {
	my($file, @text) = @_;
	open(my $fh, ">:raw", $file) or die "$file: $!";
	print $fh @text;
}

sub unlink_testfiles {
	if ($ENV{KEEP}) {
		note "kept test files";
	}
	else {
		if (Test::More->builder->is_passing) {
			for (@TEST_EXT) {
				for (<test*.$_>) {
					if (-f $_) { ok unlink($_), "unlink $_"; }
				}
			}
			for (<test_dir*>) {
				if (-d $_) { ok remove_tree($_), "remove_tree $_"; }
			}
		}
	}
}

#------------------------------------------------------------------------------
# Compare files
#------------------------------------------------------------------------------

sub trim {
	local $_ = shift;
	s/^[ \t\f\v\r]+//mg;
	s/[ \t\f\v\r]+$//mg;
	s/[ \t\f\r\r]+/ /g;
	return $_;
}

sub hexdump {
	my($str) = @_;
	my $ret = '';
	my $addr = 0;
	my @bytes = map {ord} split //, $str;
	while (@bytes) {
		$ret .= sprintf("%04X:", $addr);
		for (1..8) {
			if (@bytes) {
				$ret .= sprintf(" %02X", shift @bytes);
			}
			$addr++;
		}
		$ret .= "\n";
	}
	return $ret;
}

sub check_text_file {
	my($file, $exp, $title) = @_;
	$title //= $file." contents";
	my $loc = " at file ".((caller)[1])." line ".((caller)[2]);
	
	ok -f $file, "$file exists".$loc;
	if (-f $file) {
		check_text(
				slurp($file), 
				$exp, 
				$title.$loc);
	}
}

sub check_bin_file {
	my($file, $exp, $title) = @_;
	$title //= $file." contents";
	my $loc = " at file ".((caller)[1])." line ".((caller)[2]);
	
	ok -f $file, "$file exists".$loc;

	if (-f $file) {
		check_text(
				hexdump(slurp($file)),
				hexdump($exp),
				$title.$loc);
	}
}

sub check_text {
	my($out, $exp, $title) = @_;

	my $out_t = trim($out);
	my $exp_t = trim($exp);
	
	ok $out_t eq $exp_t, $title;
	if ($out_t ne $exp_t) {
		my $line_nr = 0;
		my @out = map {(++$line_nr).": ".$_} split(/\n/, $out);
		my @out_t = map {trim($_)} @out;

		$line_nr = 0;
		my @exp = map {(++$line_nr).": ".$_} split(/\n/, $exp);
		my @exp_t = map {trim($_)} @exp;
		
		while (@out || @exp) {
			# remove same lines
			while (@out && @exp && $out_t[0] eq $exp_t[0]) {
				shift @out; shift @out_t;
				shift @exp; shift @exp_t;
			}
			
			# check for one input finished
			if (@out && !@exp) {
				diag scalar(@out)." lines differ";
				diag "---";
				diag "> ".$_ for @out;
				diag ".";
				@out = @out_t = ();
			}
			elsif (!@out && @exp) {
				diag scalar(@exp)." lines differ";
				diag "< ".$_ for @exp;
				diag "---";
				diag ".";
				@exp = @exp_t = ();
			}
			else {
				# count different lines and show them
				my $count = 0;
				while ($count < @out && $count < @exp && $out_t[$count] ne $exp_t[$count]) {
					$count++;
				}
				diag "$count lines differ";
				for (0..$count-1) {
					diag "< ".$exp[$_];
				}
				diag "---";
				for (0..$count-1) {
					diag "> ".$out[$_];
				}
				diag ".";
				splice(@out, 0, $count); splice(@out_t, 0, $count);
				splice(@exp, 0, $count); splice(@exp_t, 0, $count);
			}
		}
	}
}

1;
