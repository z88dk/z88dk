#!/usr/bin/env perl

use Modern::Perl;
use Test::More;
use Config;
use Capture::Tiny 'capture_merged';
use Data::HexDump;
use Path::Tiny;
use Text::Diff;

$ENV{PATH} = join($Config{path_sep}, 
			".",
			"../../bin",
			$ENV{PATH});

my $OBJ_FILE_VERSION = "18";

use vars '$test', '$null', '@CPUS';
$test = "test_".(($0 =~ s/\.t$//r) =~ s/[\.\/\\]/_/gr);
$null = ($^O eq 'MSWin32') ? 'nul' : '/dev/null';
@CPUS = qw( z80 z80_strict z80n z180 
			ez80 ez80_z80 
			r800 
			r2ka r3k r4k r5k 
			8080 8085 
			gbz80 
			kc160 kc160_z80
);

unlink_testfiles();

#------------------------------------------------------------------------------
sub check_bin_file {
    my($got_file, $exp_bin) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    
	my $got_bin = slurp($got_file);
	my $got_hex = HexDump($got_bin);
	
	my $exp_hex = HexDump($exp_bin);
	
	my $diff = diff(\$exp_hex, \$got_hex, {STYLE => 'Context'});
	is $diff, "", "bin file $got_file ok";
	
	(Test::More->builder->is_passing) or die;
}

#------------------------------------------------------------------------------
sub check_text_file {
    my($got_file, $exp_text) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    
	(my $got_text = slurp($got_file)) =~ s/\r\n/\n/g;
	$exp_text =~ s/\r\n/\n/g;
	
	my $diff = diff(\$exp_text, \$got_text, {STYLE => 'Context'});
	is $diff, "", "text file $got_file ok";
	
	(Test::More->builder->is_passing) or die;
}

#------------------------------------------------------------------------------
sub z80asm_ok {
    my($options, $files, $exp_warn, @pairs_asm_bin) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    
    # build $asm and $bin
    my($asm, $bin) = ("","");
    while (my($a, $b) = splice(@pairs_asm_bin, 0, 2)) {
        $asm .= "$a\n";
        $bin .= $b;
    }
    
    # save asm file
    my $asm_file = "${test}.asm";
    my $bin_file = "${test}.bin";
    spew($asm_file, $asm);
    unlink($bin_file);
    
    # assemble
    $options ||= "-b";
    $files ||= $asm_file;

    run_ok("z88dk-z80asm $options $files 2> ${test}.stderr");
    check_bin_file($bin_file, $bin);
    check_text_file("${test}.stderr", $exp_warn) if $exp_warn;
	
	(Test::More->builder->is_passing) or die;
}

#------------------------------------------------------------------------------
sub z80asm_nok {
    my($options, $files, $asm, $exp_err) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    
    # save asm file
    my $asm_file = "${test}.asm";
	spew($asm_file, $asm);
    
    # assemble
    $options ||= "-b";
    $files ||= $asm_file;

    capture_nok("z88dk-z80asm $options $files", $exp_err);
	
	(Test::More->builder->is_passing) or die;
}

#------------------------------------------------------------------------------
sub ticks {
	my($source, $options) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

	spew("$test.asm", $source);
	run_ok("z88dk-z80asm $options -b -l -m $test.asm");
	
	(Test::More->builder->is_passing) or die;

	my $cpu = ($options =~ /(?:-m=?)(\S+)/) ? $1 : "z80";
	run_ok("z88dk-ticks -m$cpu $test.bin -output $test.out");

	(Test::More->builder->is_passing) or die;

	my $bin = slurp("$test.out");
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
		
	(Test::More->builder->is_passing) or die;

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

#------------------------------------------------------------------------------
sub capture_ok {
    my($cmd, $exp_out) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    
    run_ok($cmd." > ${test}.stdout");
    check_text_file("${test}.stdout", $exp_out);
	
	(Test::More->builder->is_passing) or die;
}

#------------------------------------------------------------------------------
sub capture_nok {
    my($cmd, $exp_err) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    run_nok($cmd." 2> ${test}.stderr");
    check_text_file("${test}.stderr", $exp_err);
	
	(Test::More->builder->is_passing) or die;
}

#------------------------------------------------------------------------------
sub run_ok {
    my($cmd) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
	
	ok 1, "Running: $cmd";
    ok 0==system($cmd), $cmd;
	
	(Test::More->builder->is_passing) or die;
}

#------------------------------------------------------------------------------
sub run_nok {
    my($cmd) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
	
	ok 1, "Running: $cmd";
    ok 0!=system($cmd), $cmd;
	
	(Test::More->builder->is_passing) or die;
}

#------------------------------------------------------------------------------
# string table
{
	package ST;
	use Object::Tiny::RW qw( hash list );
	
	sub new {
		my($class) = shift;
		return bless {
			hash => {"" => 0},
			list => [""] }, $class;
	}
	
	sub add {
		my($self, $str) = @_;
		return $self->hash->{$str} if exists $self->hash->{$str};
		my $id = $self->count;
		$self->hash->{$str} = $id;
		push @{$self->list}, $str;
		return $id;
	}
	
	sub lookup {
		my($self, $id) = @_;
		return $self->list->[$id];
	}
	
	sub count {
		my($self) = @_;
		return scalar @{$self->list};
	}
	
	sub store {
		my($self) = @_;
		
		# build list of strings and indexes
		my $strings = "";
		my @index;
		for my $id (0 .. $self->count - 1) {
			push @index, length($strings);
			$strings .= $self->lookup($id) . pack("C", 0);
		}
		my $aligned = (length($strings)+3) & ~3;
		$strings .= pack("C*", (0) x ($aligned - length($strings)));
		
		# write sizes
		my $o = pack("VV", $self->count, length($strings));
		
		# write indexes
		$o .= pack("V*", @index);
		
		# write strings
		$o .= $strings;
		
		return $o;
	}
}	

#------------------------------------------------------------------------------
sub bytes { return pack("C*", map {$_ & 0xff} @_); }
sub words { return pack("v*", @_); }
sub words_be { return pack("n*", @_); }
sub pointers { return join('', map {pack("vC", $_ & 0xFFFF, ($_ >> 16) & 0xFF)} @_); }
sub dwords { return pack("V*", @_); }

sub unlink_testfiles {
	my(@additional) = @_;
    unlink(<${test}*>, @additional) 
        if !$ENV{DEBUG} && Test::More->builder->is_passing;
}

# return object file binary representation
sub objfile {
	my(%args) = @_;

	my $st = ST->new;				# string table

	exists($args{ORG}) and die;

	my $o = "Z80RMF".$OBJ_FILE_VERSION;

	# store CPU and -IXIY
	$o .= pack("VV", $args{CPU}//1, $args{SWAP_IXIY}//0);
	
	# store empty pointers; mark position for later
	my $name_addr	 = length($o); $o .= pack("V", -1);
	my $expr_addr	 = length($o); $o .= pack("V", -1);
	my $symbols_addr = length($o); $o .= pack("V", -1);
	my $lib_addr	 = length($o); $o .= pack("V", -1);
	my $code_addr	 = length($o); $o .= pack("V", -1);
	my $st_addr		 = length($o); $o .= pack("V", -1);
	
	# store expressions
	if ($args{EXPRS}) {
		store_ptr(\$o, $expr_addr);
		for (@{$args{EXPRS}}) {
			@$_ == 9 or die;
			my($type, $filename, $line_nr, $section, $asmptr, $ptr, $opcode_size, 
			   $target_name, $text) = @$_;

			my %TYPES = ( 	"J"=>1, "U"=>2, "S"=>3, 
							"W"=>4, "C"=>4, # was C until v17, after is W
							"B"=>5, "L"=>6, "u"=>7, "s"=>8, 
							"P"=>9, "H"=>10, "="=>11 );
			die "invalid type $type" unless exists $TYPES{$type};

			$o .= pack("V", $TYPES{$type});
			$o .= pack("V", $st->add($filename)) . pack("V", $line_nr);
			$o .= pack("V", $st->add($section));
			$o .= pack("VVV", $asmptr, $ptr, $opcode_size);
			$o .= pack("V", $st->add($target_name));
			$o .= pack("V", $st->add($text));
		}
		$o .= pack("V", 0);
	}

	# store symbols
	if ($args{SYMBOLS}) {
		store_ptr(\$o, $symbols_addr);
		for (@{$args{SYMBOLS}}) {
			@$_ == 7 or die;
			my($scope, $type, $section, $value, $name, $def_filename, $line_nr) = @$_;
			
			my %SCOPES = ("L"=>1, "G"=>2);
			die "invalid scope $scope" unless exists $SCOPES{$scope};

			my %TYPES = ("C"=>1, "A"=>2, "="=>3);
			die "invalid scope $type" unless exists $TYPES{$type};

			$o .= pack("V", $SCOPES{$scope});
			$o .= pack("V", $TYPES{$type});
			$o .= pack("V", $st->add($section));
			$o .= pack("V", $value);
			$o .= pack("V", $st->add($name));
			$o .= pack("V", $st->add($def_filename)) . pack("V", $line_nr);
		}
		$o .= pack("V", 0);
	}

	# store library
	if ($args{EXTERNS}) {
		store_ptr(\$o, $lib_addr);
		for my $name (@{$args{EXTERNS}}) {
			$o .= pack("V", $st->add($name));
		}
		$o .= pack("V", $st->add(""));		# end marker
	}

	# store name
	store_ptr(\$o, $name_addr);
	$o .= pack("V", $st->add($args{NAME}//"test"));

	# store code
	if ( $args{CODE} ) {
		ref($args{CODE}) eq 'ARRAY' or die;
		store_ptr(\$o, $code_addr);
		for (@{$args{CODE}}) {
			@$_ == 4 or die;
			my($section, $org, $align, $code) = @$_;
			$o .= pack("V", length($code));
			$o .= pack("V", $st->add($section));
			$o .= pack("VV", $org, $align);
			$o .= $code;
			
			my $aligned_size = (length($code) + 3) & ~3;
			my $extra_bytes = $aligned_size - length($code);
			$o .= pack("C*", (0) x $extra_bytes);
		}
		$o .= pack("V", -1);
	}

	# store string table
	store_ptr(\$o, $st_addr);
	$o .= $st->store;
	
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
sub pack_lstring {
	my($string) = @_;
	return pack("v", length($string)).$string;
}

#------------------------------------------------------------------------------
# return library file binary representation
sub libfile {
	my($o_files, $public) = @_;

	my $o = "Z80LMF".$OBJ_FILE_VERSION;
	
	# string table pointer
	my $st_addr	= length($o); 
	$o .= pack("V", -1);

	for my $i (0 .. $#$o_files) {
		my $o_file = $o_files->[$i];
		my $next_ptr = length($o) + 4 + 4 + length($o_file);

		$o .= pack("V", $next_ptr);
		$o .= pack("V", length($o_file));
		$o .= $o_file;
	}
	$o .= pack("V", -1);	# next
	$o .= pack("V", 0);	# length = deleted

	# store string table
	my $st = ST->new();
	for (@$public) {
		$st->add($_);
	}

	store_ptr(\$o, $st_addr);
	$o .= $st->store;

	return $o;
}

#------------------------------------------------------------------------------
# quote command line argument with "" on Windows, '' otherwise
sub quote_os {
	my($txt) = @_;
	if ($^O eq 'MSWin32') {
		return '"\''.$txt.'\'"';
	}
	else {
		return "'\"".$txt."\"'";
	}
}

sub os_quoted {
	my($txt) = @_;
	if ($^O eq 'MSWin32') {
		return "'".$txt."'";
	}
	else {
		return '"'.$txt.'"';
	}
}

#------------------------------------------------------------------------------
# path()->spew fails sometimes on Windows (race condition?) with 
# Error rename on 'test_t_ALIGN.asm37032647357911' -> 'test_t_ALIGN.asm': Permission denied
# replace by a simpler spew without renames
sub spew {
	my($file, @data) = @_;
	local $Test::Builder::Level = $Test::Builder::Level + 1;

	my $open_ok = open(my $fh, ">:raw", $file);
	ok $open_ok, "write $file"; 
	
	if ($open_ok) {
		print $fh join('', @data);
	}
	
	(Test::More->builder->is_passing) or die;
}

#------------------------------------------------------------------------------
# and for simetry
sub slurp {
	my($file) = @_;
	local $Test::Builder::Level = $Test::Builder::Level + 1;

	my $open_ok = open(my $fh, "<:raw", $file);
	ok $open_ok, "read $file";
	
	if ($open_ok) {
		read($fh, my $data, -s $file);
		return $data;
	}
	else {
		return "";
	}
	
	(Test::More->builder->is_passing) or die;
}

#------------------------------------------------------------------------------
sub cpu_compatible {
	my($code_cpu, $lib_cpu) = @_;
	if ($code_cpu eq $lib_cpu) {
		return 1;
	}
	elsif ($code_cpu eq "z80_strict" && $lib_cpu eq "8080") {
		return 1;
	}
	elsif ($code_cpu eq "z80" && ($lib_cpu eq "8080" || $lib_cpu eq "z80_strict")) {
		return 1;
	}
	elsif ($code_cpu eq "z80n" && ($lib_cpu eq "8080" || $lib_cpu eq "z80" || $lib_cpu eq "z80_strict")) {
		return 1;
	}
	elsif ($code_cpu eq "z180" && ($lib_cpu eq "8080" || $lib_cpu eq "z80_strict")) {
		return 1;
	}
	elsif ($code_cpu eq "ez80") {
		return 0;
	}
	elsif ($code_cpu eq "ez80_z80") {
		return 0;
	}
	elsif ($code_cpu eq "r800" && ($lib_cpu eq "8080" || $lib_cpu eq "z80_strict")) {
		return 1;
	}
	elsif ($code_cpu eq "r2ka") {
		return 0;
	}
	elsif ($code_cpu eq "r3k" && $lib_cpu eq "r2ka") {
		return 1;
	}
	elsif ($code_cpu eq "r4k") {
		return 0;
	}
	elsif ($code_cpu eq "r5k" && $lib_cpu eq "r4k") {
		return 1;
	}
	elsif ($code_cpu eq "8080") {
		return 0;
	}
	elsif ($code_cpu eq "8085" && $lib_cpu eq "8080") {
		return 1;
	}
	elsif ($code_cpu eq "gbz80") {
		return 0;
	}
	elsif ($code_cpu eq "kc160") {
		return 0;
	}
	elsif ($code_cpu eq "kc160_z80" && ($lib_cpu eq "8080" || $lib_cpu eq "z80_strict")) {
		return 1;
	}
	else {
		return 0;
	}
}

#------------------------------------------------------------------------------
sub ixiy_compatible {
	my($code_ixiy, $lib_ixiy) = @_;
	if ($code_ixiy eq $lib_ixiy) {
		return 1;
	}
	elsif ($code_ixiy eq "" && $lib_ixiy eq "-IXIY-soft") {
		return 1;
	}
	elsif ($code_ixiy eq "-IXIY-soft" && $lib_ixiy eq "") {
		return 1;
	}
	else {
		return 0;
	}
}

#------------------------------------------------------------------------------
# Ticks: prepare tests and run all in one go
{
	package Ticks;
	use Object::Tiny::RW qw( test_nr res_addr asm tests );
	use Test::More;
	
	sub new {
		my($class) = @_;
		return bless {test_nr=>0, 
					  res_addr=>0,
					  asm=>[], 
					  tests=>[]}, $class;
	}
	
	sub add {
		my($self, $asm, %checks) = @_;
		
		my $test_nr = ++$self->{test_nr};
		
		# localize all labels
		my %labels;
		while ($asm =~ /^ \s* (?| \. \s* ([a-z_]\w*) | ([a-z_]\w*) \s* : ) /mixg) {
			$labels{$1}++;
		}
		for my $label (keys %labels) {
			$asm =~ s/ \b $label \b /L${test_nr}_${label}/ixg;
		}
		
		# add reset code
		my $reset_code = "xor a\n";
		for my $reg (qw( bc de hl )) {
			$reset_code .= "ld $reg, 0\n";
		}
		$reset_code .= "IF !__CPU_INTEL__ && !__CPU_GBZ80__\n";
		$reset_code .= "exx\n";
		for my $reg (qw( bc de hl )) {
			$reset_code .= "ld $reg, 0\n";
		}
		$reset_code .= "exx\n";
		$reset_code .= "ENDIF\n";
		$reset_code .= "IF !__CPU_INTEL__ && !__CPU_GBZ80__\nld ix, 0\nld iy, 0\nENDIF\n";
		
		# add test code
		my $test_code = "";
		for my $k (sort keys %checks) {
			my $v = $checks{$k};
			
			if    ($k =~ /^F_S/) { $test_code .= $self->test_flag_code($test_nr, $k, 0x80, $v); }
			elsif ($k =~ /^F_Z/) { $test_code .= $self->test_flag_code($test_nr, $k, 0x40, $v); }
			elsif ($k =~ /^F_H/) { $test_code .= $self->test_flag_code($test_nr, $k, 0x10, $v); }
			elsif ($k =~ /^F_PV/){ $test_code .= $self->test_flag_code($test_nr, $k, 0x04, $v); }
			elsif ($k =~ /^F_N/) { $test_code .= $self->test_flag_code($test_nr, $k, 0x02, $v); }
			elsif ($k =~ /^F_C/) { $test_code .= $self->test_flag_code($test_nr, $k, 0x01, $v); }
			elsif ($k =~ /^(BC|DE|HL|SP|IX|IY)$/) {
				$test_code .= $self->test_dd_code($test_nr, $k, $v);
			}
			elsif ($k =~ /^(BC|DE|HL)_$/) {
				$test_code .= $self->test_dd1_code($test_nr, $k, $v);
			}
			elsif ($k =~ /^(B|C|D|E|H|L|A)$/) {
				$test_code .= $self->test_r_code($test_nr, $k, $v);
			}
			elsif ($k =~ /^(B|C|D|E|H|L|A)_$/) {
				$test_code .= $self->test_r1_code($test_nr, $k, $v);
			}
			else {
				die "cannot parse $k";
			}
		}
		
		push @{$self->asm}, $reset_code, $asm, $test_code;
		
	}
	
	sub _alloc_addr {
		my($self, $n) = @_;
		
		my $res_addr = $self->{res_addr};
		$self->{res_addr} += $n;
		return $res_addr;
	}
	
	sub _tick_plain_regs {
		my($self, $reg) = @_;
		
		my $reg_tick  = $reg =~ s/_/'/r;
		my $reg_plain = $reg =~ s/_//r;
		return ($reg_tick, $reg_plain);
	}
	
	sub _eval_value {
		my($self, $value, @args) = @_;
		
		if (ref($value) eq 'CODE') {
			$value = $value->(@args);
		}
		return $value;
	}
	
	sub _check_value {
		my($self, $test_nr, $t, $reg, $res_addr, $size, $mask, $value) = @_;
		local $Test::Builder::Level = $Test::Builder::Level + 1;
		
		my $got;
		if ($size == 1) {
			$got = $t->{mem}[$res_addr] & ($mask ? $mask : 0xFF);
			if ($mask) {
				$got = $got ? 1 : 0;
			}
		}
		elsif ($size == 2) {
			$got = ($t->{mem}[$res_addr] + ($t->{mem}[$res_addr+1] << 8))
					& ($mask ? $mask : 0xFFFF);
		}
		else {
			die;
		}
		
		$value = $self->_eval_value($value, $t);
		if ($size == 1) {
			$value &= 0xFF;
		}
		elsif ($size == 2) {
			$value &= 0xFFFF;
		}
		else {
			die;
		}
		
		is $got, $value, "Test $test_nr addr=$res_addr $reg=$value";
	}
			
	sub test_flag_code {
		my($self, $test_nr, $flag, $mask, $value) = @_;
		
		my $res_addr = $self->_alloc_addr(1);
		push @{$self->tests}, sub {
			my($t) = @_;
			local $Test::Builder::Level = $Test::Builder::Level + 1;
			SKIP: {
				skip "8085 does not have the N flag" if $t->{cpu} eq '8085' && $flag eq 'F_N';
				$self->_check_value($test_nr, $t, $flag, $res_addr, 1, $mask, $value);
			}
		};
		return <<END;
							push af
							ex (sp), hl
							ld ($res_addr), hl
							ex (sp), hl
							pop af
END
	}
	
	sub test_dd_code {
		my($self, $test_nr, $dd, $value) = @_;
		
		my $res_addr = $self->_alloc_addr(2);
		push @{$self->tests}, sub {
			my($t) = @_;
			local $Test::Builder::Level = $Test::Builder::Level + 1;
			$self->_check_value($test_nr, $t, $dd, $res_addr, 2, 0, $value);
		};

		my $cond = ($dd =~ /IX|IY/i) ? "!__CPU_INTEL__ && !__CPU_GBZ80__" : "1";
		return <<END;
						IF $cond
							ld ($res_addr), $dd
						ELSE
							push hl
							ld hl, 0
							ld ($res_addr), hl
							pop hl
						ENDIF
END
	}
	
	sub test_dd1_code {
		my($self, $test_nr, $dd, $value) = @_;

		my($dd_tick, $dd_plain) = $self->_tick_plain_regs($dd);
		my $res_addr = $self->_alloc_addr(2);
		push @{$self->tests}, sub {
			my($t) = @_;
			local $Test::Builder::Level = $Test::Builder::Level + 1;
			$self->_check_value($test_nr, $t, $dd_tick, $res_addr, 2, 0, $value);
		};
		return <<END;
						IF !__CPU_INTEL__ && !__CPU_GBZ80__
							exx
						ENDIF
							ld ($res_addr), $dd_plain
						IF !__CPU_INTEL__ && !__CPU_GBZ80__
							exx
						ENDIF
END
	}
	
	sub test_r_code {
		my($self, $test_nr, $r, $value) = @_;
		
		my $res_addr = $self->_alloc_addr(1);
		push @{$self->tests}, sub {
			my($t) = @_;
			local $Test::Builder::Level = $Test::Builder::Level + 1;
			$self->_check_value($test_nr, $t, $r, $res_addr, 1, 0, $value);
		};
		if ($r eq 'A') {
			return <<END;
							ld ($res_addr), a
END
		}
		else {
			return <<END;
							push af
							ld a, $r
							ld ($res_addr), a
							pop af
END
		}
	}
	
	sub test_r1_code {
		my($self, $test_nr, $r, $value) = @_;
		
		my($r_tick, $r_plain) = $self->_tick_plain_regs($r);
		my $res_addr = $self->_alloc_addr(1);
		push @{$self->tests}, sub {
			my($t) = @_;
			local $Test::Builder::Level = $Test::Builder::Level + 1;
			$self->_check_value($test_nr, $t, $r_tick, $res_addr, 1, 0, $value);
		};
		if ($r =~ /A_/) {
			return <<END;
							ex af, af'
							ld ($res_addr), a
							ex af, af'
END
		}
		else {
			return <<END;
							push af
						IF !__CPU_INTEL__ && !__CPU_GBZ80__
							exx
						ENDIF
							ld a, $r_plain
							ld ($res_addr), a
						IF !__CPU_INTEL__ && !__CPU_GBZ80__
							exx
						ENDIF
							pop af
END
		}
	}
	
	sub run {
		my($self, @opts) = @_;
		local $Test::Builder::Level = $Test::Builder::Level + 1;

		my $save_bytes = $self->res_addr;
		
		unshift @{$self->asm}, <<END;
			IF __CPU_R4K__ || __CPU_R5K__
				;; Enable R4K instruction mode on the R4K
				ld      a,0xC0
				ioi ld  (0x0420),a      ;EDMR register (p299 in R4000UM.pdf)
			ENDIF			
				jp 		start
				defs 	$save_bytes		;save bytes for results
			start:
END
		push @{$self->asm}, <<END;
				jp 0
END
		push @opts, "" if @opts==0;
		for my $cpu (@::CPUS) {
			SKIP: {
				skip "$cpu not supported by ticks" if $cpu =~ /^ez80$/;
				
				for my $opts (@opts) {
					# run ticks
					my $t = ::ticks(join("\n", "; $cpu $opts\n", @{$self->asm}), "-m$cpu $opts");
					
					# collect labels
					open(my $f, "<", "$::test.map") or die "open $::test.map: $!";
					while (<$f>) {
						if (/^(\w+)\s*=\s*\$([0-9a-f]+)/i) {
							$t->{labels}{$1} = hex($2);
						}
					}
					$t->{cpu} = $cpu;
					
					# check results
					for (@{$self->tests}) {
						$_->($t);

						(Test::More->builder->is_passing) or die;
					}
				}
			}
		}
	}
}

1;
