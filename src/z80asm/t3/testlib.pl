#!/usr/bin/env perl

use Modern::Perl;
use Test::More;
use Capture::Tiny 'capture_merged';
use Path::Tiny;

use vars '$test';
$test = "test_".(($0 =~ s/\.t$//r) =~ s/[\.\/]/_/gr);

sub check_bin_file {
    my($got_file, $exp) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    
    run_ok("hexdump -C $got_file > $got_file.hex");
    
    my $exp_file = ($got_file =~ s/\.\w+$/.exp/ir);
    path($exp_file)->spew_raw($exp);
    run_ok("hexdump -C $exp_file > $exp_file.hex");
    
    run_ok("diff $exp_file.hex $got_file.hex");
    
    unlink("$got_file.hex", $exp_file, "$exp_file.hex") 
        if Test::More->builder->is_passing;
}

sub z80asm_ok {
    my($asm, $options, $bin) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    
    my $asm_file = "${test}_z80asm.asm";
    my $bin_file = "${test}_z80asm.bin";
    path($asm_file)->spew($asm);
    unlink($bin_file);
    
    run_ok("./z88dk-z80asm $options $asm_file");
    check_bin_file($bin_file, $bin);

    unlink($asm_file, $bin_file, "${test}_o") 
        if Test::More->builder->is_passing;
}

sub capture_ok {
    my($cmd, $exp_out) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    
    path("${test}_exp")->spew($exp_out);
    $cmd .= " > ${test}_out";
    run_ok($cmd);
    run_ok("dos2unix -q ${test}_exp ${test}_out");
    run_ok("diff ${test}_exp ${test}_out");
}

sub capture_nok {
    my($cmd, $exp_err) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    
    path("${test}_exp")->spew($exp_err);
    $cmd .= " 2> ${test}_err";
    run_nok($cmd);
    run_ok("dos2unix -q ${test}_err ${test}_exp");
    run_ok("diff ${test}_exp ${test}_err");
}

sub run_ok {
    my($cmd) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    ok 0==system($cmd), $cmd;
}

sub run_nok {
    my($cmd) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    ok 0!=system($cmd), $cmd;
}

END {
    unlink(<${test}*>) 
        if Test::More->builder->is_passing;
}

1;
