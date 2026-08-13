#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

#------------------------------------------------------------------------------
# Test computed DEFC 1
unlink_testfiles;

spew("${test}.asm", <<'END');
			org 0x100
		start:
			defw start,end1,end2,end3
		end1:
			defc end2 = asmpc
			defc end3 = end1
END

my $bin = words(0x100, 0x108, 0x108, 0x108);

# assemble and link
unlink("${test}.bin");
capture_ok("z88dk-z80asm -b ${test}.asm", "");
check_bin_file("${test}.bin", $bin);

# link only
unlink("${test}.bin");
capture_ok("z88dk-z80asm -b ${test}.o", "");
check_bin_file("${test}.bin", $bin);

capture_ok("z88dk-z80nm -a ${test}.o", <<'END');
Object  file test_t_modlink_defc_t.o at $0000: Z80RMF18
  Name: test_t_modlink_defc_t
  CPU:  z80 
  Section "": 8 bytes, ORG $0100
    C $0000: 00 00 00 00 00 00 00 00
  Symbols:
    L A $0008: end1 (section "") (file test_t_modlink_defc_t.asm:4)
    L A $0008: end2 (section "") (file test_t_modlink_defc_t.asm:5)
    L A $0008: end3 (section "") (file test_t_modlink_defc_t.asm:6)
    L A $0000: start (section "") (file test_t_modlink_defc_t.asm:2)
  Expressions:
    E U16   $0000 $0000 2: start (section "") (file test_t_modlink_defc_t.asm:3)
    E U16   $0000 $0002 4: end1 (section "") (file test_t_modlink_defc_t.asm:3)
    E U16   $0000 $0004 6: end2 (section "") (file test_t_modlink_defc_t.asm:3)
    E U16   $0000 $0006 8: end3 (section "") (file test_t_modlink_defc_t.asm:3)
  Strings:
    S   1 = "test_t_modlink_defc_t.asm"
    S   2 = "start"
    S   3 = "end1"
    S   4 = "end2"
    S   5 = "end3"
    S   6 = "test_t_modlink_defc_t"
END

#------------------------------------------------------------------------------
# Test computed DEFC 2
unlink_testfiles;

spew("${test}.asm", <<'END');
		section code
		section lib

		extern func1_alias, func2_alias, computed_end

		section code
		call func1_alias
		call func2_alias
		jp   computed_end
END

spew("${test}1.asm", <<'END');
		section code
		section lib

		public func1, func2

		section lib
func1:	ret

		section code
func2:	ret z
END

spew("${test}2.asm", <<'END');
		section code
		section lib

		extern func1, func2
		public func1_alias, func2_alias, computed_end

		defc func1_alias = func1		; link lib to lib
		defc func2_alias = func2		; link lib to code

		defc computed_end = chain1 + 1
		defc chain1 = chain2 - 1
		defc chain2 = ASMPC
END

$bin = bytes(		# section code		# @ 0x1000
					0xCD, 0x0A, 0x10,	# @ 0x1000 : main
					0xCD, 0x09, 0x10,	# @ 0x1003
					0xC3, 0x0B, 0x10,	# @ 0x1006
					0xC8,				# @ 0x1009 : func2
					# section lib		# @ 0x100A
					0xC9,				# @ 0x100A : func1
										# @ 0x100B : computed_end
);

# assemble and link
unlink("${test}.bin");
capture_ok("z88dk-z80asm -r0x1000 -b ${test}.asm ${test}1.asm ${test}2.asm", "");
check_bin_file("${test}.bin", $bin);

# link only
unlink("${test}.bin");
capture_ok("z88dk-z80asm -b ${test}.o ${test}1.o ${test}2.o", "");
check_bin_file("${test}.bin", $bin);

capture_ok("z88dk-z80nm -a ${test}.o ${test}1.o ${test}2.o", <<'END');
Object  file test_t_modlink_defc_t.o at $0000: Z80RMF18
  Name: test_t_modlink_defc_t
  CPU:  z80 
  Section "": 0 bytes, ORG $1000
  Section code: 9 bytes
    C $0000: CD 00 00 CD 00 00 C3 00 00
  Section lib: 0 bytes
  Externs:
    U         computed_end
    U         func1_alias
    U         func2_alias
  Expressions:
    E U16   $0000 $0001 3: func1_alias (section code) (file test_t_modlink_defc_t.asm:7)
    E U16   $0003 $0004 3: func2_alias (section code) (file test_t_modlink_defc_t.asm:8)
    E U16   $0006 $0007 3: computed_end (section code) (file test_t_modlink_defc_t.asm:9)
  Strings:
    S   1 = "test_t_modlink_defc_t.asm"
    S   2 = "code"
    S   3 = "func1_alias"
    S   4 = "func2_alias"
    S   5 = "computed_end"
    S   6 = "test_t_modlink_defc_t"
    S   7 = "lib"
Object  file test_t_modlink_defc_t1.o at $0000: Z80RMF18
  Name: test_t_modlink_defc_t1
  CPU:  z80 
  Section "": 0 bytes, ORG $1000
  Section code: 1 bytes
    C $0000: C8
  Section lib: 1 bytes
    C $0000: C9
  Symbols:
    G A $0000: func2 (section code) (file test_t_modlink_defc_t1.asm:10)
    G A $0000: func1 (section lib) (file test_t_modlink_defc_t1.asm:7)
  Strings:
    S   1 = "code"
    S   2 = "func2"
    S   3 = "test_t_modlink_defc_t1.asm"
    S   4 = "lib"
    S   5 = "func1"
    S   6 = "test_t_modlink_defc_t1"
Object  file test_t_modlink_defc_t2.o at $0000: Z80RMF18
  Name: test_t_modlink_defc_t2
  CPU:  z80 
  Section "": 0 bytes, ORG $1000
  Section code: 0 bytes
  Section lib: 0 bytes
  Symbols:
    L = $0000: chain1 (section lib) (file test_t_modlink_defc_t2.asm:11)
    L A $0000: chain2 (section lib) (file test_t_modlink_defc_t2.asm:12)
    G = $0000: computed_end (section lib) (file test_t_modlink_defc_t2.asm:10)
    G = $0000: func1_alias (section lib) (file test_t_modlink_defc_t2.asm:7)
    G = $0000: func2_alias (section lib) (file test_t_modlink_defc_t2.asm:8)
  Externs:
    U         func1
    U         func2
  Expressions:
    E =     $0000 $0000 0: func1_alias := func1 (section lib) (file test_t_modlink_defc_t2.asm:7)
    E =     $0000 $0000 0: func2_alias := func2 (section lib) (file test_t_modlink_defc_t2.asm:8)
    E =     $0000 $0000 0: computed_end := chain1+1 (section lib) (file test_t_modlink_defc_t2.asm:10)
    E =     $0000 $0000 0: chain1 := chain2-1 (section lib) (file test_t_modlink_defc_t2.asm:11)
  Strings:
    S   1 = "test_t_modlink_defc_t2.asm"
    S   2 = "lib"
    S   3 = "func1_alias"
    S   4 = "func1"
    S   5 = "func2_alias"
    S   6 = "func2"
    S   7 = "computed_end"
    S   8 = "chain1+1"
    S   9 = "chain1"
    S  10 = "chain2-1"
    S  11 = "chain2"
    S  12 = "test_t_modlink_defc_t2"
    S  13 = "code"
END


#------------------------------------------------------------------------------
# DEFC use case for library entry points
unlink_testfiles;

spew("${test}.asm", <<'END');
		PUBLIC asm_b_vector_at
		EXTERN asm_b_array_at

		DEFC asm_b_vector_at = asm_b_array_at
END

spew("${test}1.asm", <<'END');
		PUBLIC asm_b_array_at

	asm_b_array_at:				; 1000
		ret						; 1000 ;; C9
								; 1001
END

spew("${test}2.asm", <<'END');
		EXTERN asm_b_vector_at
		EXTERN asm_b_array_at

	start:						; 1001
		call asm_b_vector_at	; 1001 ;; CD 00 10
		call asm_b_array_at		; 1004 ;; CD 00 10
		ret						; 1007 ;; C9
END

$bin = bytes(0xC9,
			 0xCD, 0x00, 0x10,
			 0xCD, 0x00, 0x10,
			 0xC9);

# assemble and link
unlink("${test}.bin");
capture_ok("z88dk-z80asm -r0x1000 -b ${test}.asm ${test}1.asm ${test}2.asm", "");
check_bin_file("${test}.bin", $bin);

# link only
unlink("${test}.bin");
capture_ok("z88dk-z80asm -b ${test}.o ${test}1.o ${test}2.o", "");
check_bin_file("${test}.bin", $bin);

capture_ok("z88dk-z80nm -a ${test}.o ${test}1.o ${test}2.o", <<'END');
Object  file test_t_modlink_defc_t.o at $0000: Z80RMF18
  Name: test_t_modlink_defc_t
  CPU:  z80 
  Section "": 0 bytes, ORG $1000
  Symbols:
    G = $0000: asm_b_vector_at (section "") (file test_t_modlink_defc_t.asm:4)
  Externs:
    U         asm_b_array_at
  Expressions:
    E =     $0000 $0000 0: asm_b_vector_at := asm_b_array_at (section "") (file test_t_modlink_defc_t.asm:4)
  Strings:
    S   1 = "test_t_modlink_defc_t.asm"
    S   2 = "asm_b_vector_at"
    S   3 = "asm_b_array_at"
    S   4 = "test_t_modlink_defc_t"
Object  file test_t_modlink_defc_t1.o at $0000: Z80RMF18
  Name: test_t_modlink_defc_t1
  CPU:  z80 
  Section "": 1 bytes, ORG $1000
    C $0000: C9
  Symbols:
    G A $0000: asm_b_array_at (section "") (file test_t_modlink_defc_t1.asm:3)
  Strings:
    S   1 = "asm_b_array_at"
    S   2 = "test_t_modlink_defc_t1.asm"
    S   3 = "test_t_modlink_defc_t1"
Object  file test_t_modlink_defc_t2.o at $0000: Z80RMF18
  Name: test_t_modlink_defc_t2
  CPU:  z80 
  Section "": 7 bytes, ORG $1000
    C $0000: CD 00 00 CD 00 00 C9
  Symbols:
    L A $0000: start (section "") (file test_t_modlink_defc_t2.asm:4)
  Externs:
    U         asm_b_array_at
    U         asm_b_vector_at
  Expressions:
    E U16   $0000 $0001 3: asm_b_vector_at (section "") (file test_t_modlink_defc_t2.asm:5)
    E U16   $0003 $0004 3: asm_b_array_at (section "") (file test_t_modlink_defc_t2.asm:6)
  Strings:
    S   1 = "test_t_modlink_defc_t2.asm"
    S   2 = "asm_b_vector_at"
    S   3 = "asm_b_array_at"
    S   4 = "start"
    S   5 = "test_t_modlink_defc_t2"
END


unlink_testfiles;
done_testing;
