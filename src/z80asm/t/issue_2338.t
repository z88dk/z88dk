#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/2338
# z80asm: allow multi-line quoted strings with binary content

my $bin = bytes(grep {$_ != ord('"')} 1..255);

spew("$test.asm", 'defm "'.$bin.'"');
run_ok("z88dk-z80asm -raw-strings -l -v -b $test.asm");
check_bin_file("$test.bin", $bin);
check_text_file("$test.lis", <<'END');
test_t_issue_2338.asm:
     1                          defm "
     2                          
     3                           !#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~€‚ƒ„…†‡ˆ‰Š‹Œ‘’“”•–—˜™š›œŸ ¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏĞÑÒÓÔÕÖ×ØÙÚÛÜİŞßàáâãäåæçèéêëìíîïğñòóôõö÷øùúûüışÿ"
        0000  0102030405060708        + defm"\1\2\3\4\5\6\a\b\t\n\v\f\r\x0e\x0f\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f !#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~\x7f\x80\x81\x82\x83\x84\x85\x86\x87\x88\x89\x8a\x8b\x8c\x8d\x8e\x8f\x90\x91\x92\x93\x94\x95\x96\x97\x98\x99\x9a\x9b\x9c\x9d\x9e\x9f\xa0\xa1\xa2\xa3\xa4\xa5\xa6\xa7\xa8\xa9\xaa\xab\xac\xad\xae\xaf\xb0\xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9\xba\xbb\xbc\xbd\xbe\xbf\xc0\xc1\xc2\xc3\xc4\xc5\xc6\xc7\xc8\xc9\xca\xcb\xcc\xcd\xce\xcf\xd0\xd1\xd2\xd3\xd4\xd5\xd6\xd7\xd8\xd9\xda\xdb\xdc\xdd\xde\xdf\xe0\xe1\xe2\xe3\xe4\xe5\xe6\xe7\xe8\xe9\xea\xeb\xec\xed\xee\xef\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff"
              090a0b0c0d0e0f10  
              1112131415161718  
              191a1b1c1d1e1f20  
              2123242526272829  
              2a2b2c2d2e2f3031  
              3233343536373839  
              3a3b3c3d3e3f4041  
              4243444546474849  
              4a4b4c4d4e4f5051  
              5253545556575859  
              5a5b5c5d5e5f6061  
              6263646566676869  
              6a6b6c6d6e6f7071  
              7273747576777879  
              7a7b7c7d7e7f8081  
              8283848586878889  
              8a8b8c8d8e8f9091  
              9293949596979899  
              9a9b9c9d9e9fa0a1  
              a2a3a4a5a6a7a8a9  
              aaabacadaeafb0b1  
              b2b3b4b5b6b7b8b9  
              babbbcbdbebfc0c1  
              c2c3c4c5c6c7c8c9  
              cacbcccdcecfd0d1  
              d2d3d4d5d6d7d8d9  
              dadbdcdddedfe0e1  
              e2e3e4e5e6e7e8e9  
              eaebecedeeeff0f1  
              f2f3f4f5f6f7f8f9  
              fafbfcfdfeff      
     4                          
END

unlink_testfiles;
done_testing;
