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
use Cwd;

my $IS_WIN32 = $^O eq 'MSWin32';
$ENV{PATH} = ($IS_WIN32 ? ".;" : ".:").$ENV{PATH};

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

sub run {
	my($cmd, $return, $out, $err) = @_;
	$return //= 0;
	$out //= '';
	$err //= '';
	
	$cmd .= " >test.stdout 2>test.stderr";
	$cmd =~ s!/!\\!g if $IS_WIN32;
	
	ok 1, $cmd;
	ok !!$return == !!system($cmd), "exit value";
	
	my $gotout = slurp("test.stdout");
	my $goterr = slurp("test.stderr");
	
	if ($out eq "IGNORE") {
		note "test.stdout: ", $gotout;
	}
	else {
		_test_text($gotout, $out, "test.stdout");
	}
	
	if ($err eq "IGNORE") {
		note "test.stderr: ", $goterr;
	}
	else {
		_test_text($goterr, $err, "test.stderr");
	}
	
	if (Test::More->builder->is_passing) {
		unlink "test.stdout", "test.stderr";
	}
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
		_test_text(
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
		_test_text(
				hexdump(slurp($file)),
				hexdump($exp),
				$title.$loc);
	}
}

sub _test_text {
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

sub trim {
	local $_ = shift;
	s/^[ \t\f\v\r]+//mg;
	s/[ \t\f\v\r]+$//mg;
	s/[ \t\f\r\r]+/ /g;
	return $_;
}

sub unlink_testfiles {
	if ($ENV{KEEP}) {
		diag "kept test files";
	}
	else {
		if (Test::More->builder->is_passing) {
			for (qw( asm bin c d def err inc lis lst map o P out sym tap )) {
				for (<test*.$_>) {
					-f $_ and ok unlink($_), "unlink $_";
				}
			}
		}
	}
}

sub z80asm {
	my($source, $options, $return, $out, $err) = @_;
	$options //= "-b";
	
	spew("test.asm", $source);
	run("z80asm $options test.asm", $return, $out, $err);
}

sub ticks {
	my($source) = @_;
	build_ticks();
	z80asm($source);
	run("ticks test.bin -output test.out", 0, "IGNORE");
	my $bin = slurp("test.out");
	my @mem = map {ord} split //, substr($bin, 0, 0x10000);
	my @regs = map {ord} split //, substr($bin, 0x10000);
	return [\@mem, \@regs];
}

sub z80nm {
	my($file, $out) = @_;
	build_z80nm();
	run("z80nm -a $file", 0, $out);
}

sub build_appmake {
	our $is_built;
	unless ($is_built) {
		my $dir = cwd();
		chdir "../appmake" or die;
		run("make", 0, 'IGNORE', 'IGNORE');	# cannot make -C because make does not understand \\ in filenames
		chdir $dir or die;
		$ENV{PATH} = ($IS_WIN32 ? "..\\appmake;" : "../appmake:").$ENV{PATH};
		$is_built++;
	}
}

sub build_ticks {
	our $is_built;
	unless ($is_built) {
		my $dir = cwd();
		chdir "../ticks" or die;
		run("make", 0, 'IGNORE', 'IGNORE');	# cannot make -C because make does not understand \\ in filenames
		chdir $dir or die;
		$ENV{PATH} = ($IS_WIN32 ? "..\\ticks;" : "../ticks:").$ENV{PATH};
		$is_built++;
	}
}

sub build_z80nm {
	our $is_built;
	unless ($is_built) {
		my $dir = cwd();
		chdir "../z80nm" or die;
		run("make", 0, 'IGNORE', 'IGNORE');	# cannot make -C because make does not understand \\ in filenames
		chdir $dir or die;
		$ENV{PATH} = ($IS_WIN32 ? "..\\z80nm;" : "../z80nm:").$ENV{PATH};
		$is_built++;
	}
}

1;
