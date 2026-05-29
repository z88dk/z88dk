#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/2338
# z80asm: allow multi-line quoted strings with binary content

my $bin = bytes(grep {$_ != ord('"')} 32..255);

spew("$test.asm", 'defm "'.$bin.'"');
run_ok("z88dk-z80asm -raw-strings -l -v -b $test.asm");
check_bin_file("$test.bin", $bin);

# make escaped version of the $test.lis file
open my $in, '<:raw', "$test.lis" or die "Can't open $test.lis: $!";
open my $out, '>:raw', "$test.lis.tmp" or die "Can't open $test.lis.tmp: $!";
while (read($in, my $byte, 1)) {
     if ($byte eq "\n" || $byte =~ /[\x20-\x7e]/) {
          # printable ASCII, pass through
          print $out $byte;
     }
     else {
          # non-printable, escape as <<HH>>
          printf $out '[%02x]', ord($byte);
     }
}
close $in;
close $out;
rename("$test.lis.tmp", "$test.lis") or die "Can't rename $test.lis.tmp to $test.lis: $!";

check_text_file("$test.lis", <<'END');
test_t_issue_2338_t.asm:
     1                          defm " !#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~[7f][80][81][82][83][84][85][86][87][88][89][8a][8b][8c][8d][8e][8f][90][91][92][93][94][95][96][97][98][99][9a][9b][9c][9d][9e][9f][a0][a1][a2][a3][a4][a5][a6][a7][a8][a9][aa][ab][ac][ad][ae][af][b0][b1][b2][b3][b4][b5][b6][b7][b8][b9][ba][bb][bc][bd][be][bf][c0][c1][c2][c3][c4][c5][c6][c7][c8][c9][ca][cb][cc][cd][ce][cf][d0][d1][d2][d3][d4][d5][d6][d7][d8][d9][da][db][dc][dd][de][df][e0][e1][e2][e3][e4][e5][e6][e7][e8][e9][ea][eb][ec][ed][ee][ef][f0][f1][f2][f3][f4][f5][f6][f7][f8][f9][fa][fb][fc][fd][fe][ff]"
        0000  2021232425262728        + defm" !#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~\x7f\x80\x81\x82\x83\x84\x85\x86\x87\x88\x89\x8a\x8b\x8c\x8d\x8e\x8f\x90\x91\x92\x93\x94\x95\x96\x97\x98\x99\x9a\x9b\x9c\x9d\x9e\x9f\xa0\xa1\xa2\xa3\xa4\xa5\xa6\xa7\xa8\xa9\xaa\xab\xac\xad\xae\xaf\xb0\xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9\xba\xbb\xbc\xbd\xbe\xbf\xc0\xc1\xc2\xc3\xc4\xc5\xc6\xc7\xc8\xc9\xca\xcb\xcc\xcd\xce\xcf\xd0\xd1\xd2\xd3\xd4\xd5\xd6\xd7\xd8\xd9\xda\xdb\xdc\xdd\xde\xdf\xe0\xe1\xe2\xe3\xe4\xe5\xe6\xe7\xe8\xe9\xea\xeb\xec\xed\xee\xef\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff"
              292a2b2c2d2e2f30  
              3132333435363738  
              393a3b3c3d3e3f40  
              4142434445464748  
              494a4b4c4d4e4f50  
              5152535455565758  
              595a5b5c5d5e5f60  
              6162636465666768  
              696a6b6c6d6e6f70  
              7172737475767778  
              797a7b7c7d7e7f80  
              8182838485868788  
              898a8b8c8d8e8f90  
              9192939495969798  
              999a9b9c9d9e9fa0  
              a1a2a3a4a5a6a7a8  
              a9aaabacadaeafb0  
              b1b2b3b4b5b6b7b8  
              b9babbbcbdbebfc0  
              c1c2c3c4c5c6c7c8  
              c9cacbcccdcecfd0  
              d1d2d3d4d5d6d7d8  
              d9dadbdcdddedfe0  
              e1e2e3e4e5e6e7e8  
              e9eaebecedeeeff0  
              f1f2f3f4f5f6f7f8  
              f9fafbfcfdfeff    
     2                          
END

unlink_testfiles;
done_testing;
