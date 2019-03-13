#!perl

#------------------------------------------------------------------------------
# Build all the CPU opcodes and test assemble
use Modern::Perl;
use Test::More;
use Path::Tiny;
use Capture::Tiny 'capture';
use Data::HexDump;
use Test::Differences; 

my @CPU = (qw( z80 z180 r2k r3k ));

#------------------------------------------------------------------------------
# globals
my $cpu;		# current cpu
my $asmf;		# current asm output file handle
my $binf;		# current binary output file handle
my $errf;		# current error output file handle, opcodes that are invalid
my $addr;		# current address

#------------------------------------------------------------------------------
# build opcodes
for (@CPU) {
	$cpu = $_;
	ok 1, $cpu;
	
	my $asm_file = "t/data/ops_".$cpu."_ok.asm";
	my $err_file = "t/data/ops_".$cpu."_err.asm";
	my $bmk_file = "t/data/ops_".$cpu."_ok.bmk";
	
	$addr = 0;
	
	# write asm files in binary mode to have only LF
	open ($asmf, ">:raw", $asm_file);
	open ($errf, ">:raw", $err_file);
	open ($binf, ">:raw", $bmk_file);
	
	# parse .in file and build t/data/ops_*
	my $in_file = $0; $in_file =~ s/\.t$/.in/i or die;
	parse($cpu, path($in_file)->lines);
	
	close $asmf;
	close $binf;
	close $errf;
	
	test_asm($cpu, $asm_file, $err_file, $bmk_file);
}

done_testing;

sub get_bytes {
	my($asm_file) = @_;
	my $bytes = '';
	my $bytes_ixiy = '';
	for (path($asm_file)->lines) {
		s/.*;\s*//;
		
		my $line_bytes = '';
		for (split(' ', $_)) {
			$line_bytes .= chr(hex($_));
		}
		
		$bytes .= $line_bytes;
		
		# compute swapped ix/iy
		$line_bytes =~ s/^ (\x76?) ([\xDD\xFD]) (?! [\xD4\xE4\xF4] ) /
						$1 . ($2 eq chr(0xDD) ? chr(0xFD) : chr(0xDD))/xe;
		$bytes_ixiy .= $line_bytes;
	}
	
	return ($bytes, $bytes_ixiy);
}

sub parse {
	my($cpu, @lines) = @_;
	
	# read each line
	for (@lines) {
		for (split(/\n/, $_)) {
			next if /^\s*\#/;
			next if /^\s*\;/;
			next if /^\s*$/;
			s/^\s+//;
			s/\s+$//;
			s/\s+/ /g;
			
			# check if cpu has this opcode
			my $exists = 1;
			if (/^\[(.*?)\]\s*/) {
				my($cpus, $rest) = ($1, $');
				$_ = $rest;
				$exists = check_cpus($cpu, split(' ', $cpus));
			}
			
			# get opcode and bytes
			my($opcode, $bytes) = split(/\s*=>\s*/, $_);
			
			# handle cpus in bytes
			$bytes =~ s/\[(.*?)\]/ check_cpus($cpu, split(' ', $1)) /ge;
			emit_line($exists, $opcode, $bytes);
		}
	}
}

sub check_cpus {
	my($cpu, @cpus) = @_;
	for (@cpus) {
		/^not_(.*)/ and return ! check_cpus($cpu, $1);
		return 1 if /$cpu/;
		return 1 if /zilog/ && $cpu =~ /^z/;
		return 1 if /rabbit/ && $cpu =~ /^r/;
	}
	return 0;
}

sub emit_line {
	my($exists, $opcode, $bytes, $var) = @_;
	$var ||= 1;		# start with $1
	
	# expand $var
	if ($opcode =~ /\{(.*?)\}/) {
		my($before, $list, $after) = ($`, $1, $');
		my @list = split(' ', $list);
		for (0 .. $#list) {
			my($id, $text) = ($_, $list[$_]);
			next if $text eq '.';				# use a DOT to skip items
			
			my $opcode_copy = $before . $text . $after;
			my $bytes_copy = $bytes; $bytes_copy =~ s/\$$var/ sprintf("%X", $id) /ge;
			
			emit_line($exists, $opcode_copy, $bytes_copy, $var+1);
		}
		return;
	}
	
	# expand N, MN, D
	if ($opcode =~ /\b(MN)\b/) { 
		return expand_values($exists, $opcode, $bytes, $1, 0, 0x0123, 0x4567, 0x89AB, 0xCDEF, 0xFFFF);
	} 
	elsif ($opcode =~ /\b(N)\b/) { 
		return expand_values($exists, $opcode, $bytes, $1, 0, 0x55, 0xAA, 0xFF);
	} 
	elsif ($opcode =~ /\b(D)\b/) { 
		return expand_values($exists, $opcode, $bytes, $1, -128, 0, 127);
	} 
	else { 
	} 

	# compute bytes
	$bytes =~ s/([0-9A-F]+)/0x$1/g;		# all numbers in hex
	my @bytes = split_exprs($bytes);
	
	# emit
	my $asm_line = sprintf(" %-23s;; %04X: ", $opcode, $addr);
	my $bin_line = '';
	for (@bytes) {
		my @subbytes = eval($_); $@ and die $@;
		for my $byte (@subbytes) {
			$asm_line .= sprintf(" %02X", $byte);
			$bin_line .= chr($byte);
		}
	}
	
	if (!$exists) {
		say $errf $asm_line;
	}
	else {
		say $asmf $asm_line;
		print $binf $bin_line;
		$addr += length($bin_line);
	}
}

sub expand_values {
	my($exists, $opcode, $bytes, $var, @values) = @_;
	for (@values) {
		my $opcode_copy = $opcode; 
		$opcode_copy =~ s/\b$var\b/$_/g;
		$opcode_copy =~ s/\((\w+)\s*\+\s*0\s*\)/($1)/g;
		
		my $bytes_copy = $bytes; 
		$bytes_copy =~ s/\b$var\b/ sprintf("%X", $_ & 255) /ge;
		if ($var eq 'MN') {
			$bytes_copy =~ s/\bM\b/ sprintf("%X", ($_ >>  8) & 255) /ge;
			$bytes_copy =~ s/\bN\b/ sprintf("%X",         $_ & 255) /ge;
		}

		emit_line($exists, $opcode_copy, $bytes_copy);
	}
}

sub split_exprs {
	local($_) = @_;
	my @exprs = ('');
	my $paren = 0;
	while (! /\G\Z/gc) {
		if (/\G\(/gc) {
			$paren++;
			$exprs[-1] .= $&;
		}
		elsif (/\G\)/gc) {
			$paren--;
			die "syntax error: $_" if $paren < 0;
			$exprs[-1] .= $&;
		}
		elsif (/\G,/gc) {
			if ($paren == 0) {
				push @exprs, '';
			}
			else {
				$exprs[-1] .= $&;
			}
		}
		elsif (/\G[^(),]+/gc) {
			$exprs[-1] .= $&;
		}
		else {
			die "syntax error: $_";
		}
	}
	
	return @exprs;
}

sub test_asm {
	my($cpu, $asm_file, $err_file, $bmk_file, $options) = @_;
	for ($asm_file, $err_file, $bmk_file) { $_ = path($_); }
	$options //= '';
	
	# build OK
	my $cmd = "./z80asm -m$cpu -l -b $options $asm_file";
	ok 1, $cmd;
	my($out, $err, $exit) = capture { system($cmd) };
	$err =~ s/^Warning .* interpreting indirect value as immediate\s*//gm;
	is $out, "", "output";
	is $err, "", "error";
	is $exit, 0, "exit";
	
	my $bin_file = replace_ext($asm_file, ".bin");
	my $bin = $bin_file->slurp_raw;
	my $bmk = $bmk_file->slurp_raw;
	$cmd = "diff $bin_file $bmk_file";
	ok $bin eq $bmk, $cmd;
	
	if ($bin eq $bmk) {
		unlink replace_ext($asm_file, ".lis");
		unlink replace_ext($asm_file, ".o");
		unlink replace_ext($asm_file, ".bin");
		unlink replace_ext($asm_file, ".err");
	}
	else {
		my $bin_dump = HexDump($bin);
		my $bmk_dump = HexDump($bmk);
		is_text( $bin_dump, $bmk_dump );
	}
	
	# build failure for invalid opcodes
	my $num_errors = scalar($err_file->lines);
	if ($num_errors > 0) {
		$cmd = "./z80asm -m$cpu -l -b $err_file";

		my($stdout, $stderr, $exit) = capture {	system($cmd); };
		is $stdout, "", "output of $cmd";
		ok $exit != 0, "exit of $cmd";
		
		# test that all lines have been signalled as error
		my @lines_error;
		for (split(/\n/, $stderr)) {
			if (/Error at file .*? line (\d+)/) {
				$lines_error[$1] = 1;
			}
#			elsif (/\d+ errors occurred during assembly/) {
#			}
			else {
				diag $_;
				ok 0, "cannot parse error line";
			}
		}
		my $ok = 1;
		for (1 .. $num_errors) {
			if (!defined $lines_error[$_]) {
				ok 0, "expected error on line $_";
				$ok = 0;
			}
		}
		ok $ok, "errors of $cmd";
		if ($ok) {
			unlink replace_ext($err_file, ".err");
		}
	}
}

sub replace_ext {
	my($file, $new_ext) = @_;
	$file =~ s/\.\w+$/$new_ext/;
	return path($file);
}
