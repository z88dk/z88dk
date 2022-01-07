#------------------------------------------------------------------------------
# z80asm assembler
# Test z88dk-z80asm-*.lib
# Copyright (C) Paulo Custodio, 2011-2022
# License: http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#------------------------------------------------------------------------------

use Modern::Perl;
use Test::More;
use Path::Tiny;
require '../../t/testlib.pl';

my @CPUS = (qw( 8080 8085 gbz80 r2ka z80 ));

my $test_nr;

# ld de, sp+%n
for my $cpu (@CPUS) {
    for my $base (0x1000) {
        for my $add (0, 127, 255) {
            $test_nr++;
            note "Test $test_nr: cpu:$cpu reg:de base:$base add:$add";
            my $add_text = $add == 0 ? "" :
                                       "+$add";
            
            my $r = ticks(<<END, "-m$cpu");
                    ld		sp, $base
                    ld      de, sp $add_text
                    rst     0
END
            my $sum = $base + $add;
            
            is $r->{DE}, $sum, "result";
                    
            (Test::More->builder->is_passing) or die;
        }
    }
}

# ld hl, sp+%s
for my $cpu (@CPUS) {
    for my $base (0x1000) {
        for my $add (-128, 0, 127) {
            $test_nr++;
            note "Test $test_nr: cpu:$cpu reg:hl base:$base add:$add";
            my $add_text = $add <  0 ? $add :
                           $add == 0 ? "" :
                                       "+$add";
            
            my $r = ticks(<<END, "-m$cpu");
                    ld		sp, $base
                    ld      hl, sp $add_text
                    rst     0
END
            my $sum;
			if ($cpu eq '8085') {
				$sum = $base + ($add & 0xff);		# unsigned
			}
			else {
				$sum = $base + $add;				# signed
			}
			
            is $r->{HL}, $sum, "result";
                    
            (Test::More->builder->is_passing) or die;
        }
    }
}

unlink_testfiles();
done_testing();
