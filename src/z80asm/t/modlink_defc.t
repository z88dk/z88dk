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

capture_ok("z88dk-z80nm -a ${test}.o", <<END);
Object  file ${test}.o at \$0000: Z80RMF18
  Name: ${test}
  CPU:  z80 
  Section "": 8 bytes, ORG \$0100
    C \$0000: 00 00 00 00 00 00 00 00
  Symbols:
    L A \$0000: start (section "") (file ${test}.asm:2)
    L A \$0008: end1 (section "") (file ${test}.asm:4)
    L A \$0008: end2 (section "") (file ${test}.asm:5)
    L A \$0008: end3 (section "") (file ${test}.asm:6)
  Expressions:
    E W \$0000 \$0000 2: start (section "") (file ${test}.asm:3)
    E W \$0000 \$0002 4: end1 (section "") (file ${test}.asm:3)
    E W \$0000 \$0004 6: end2 (section "") (file ${test}.asm:3)
    E W \$0000 \$0006 8: end3 (section "") (file ${test}.asm:3)
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

capture_ok("z88dk-z80nm -a ${test}.o ${test}1.o ${test}2.o", <<END);
Object  file ${test}.o at \$0000: Z80RMF18
  Name: ${test}
  CPU:  z80 
  Section "": 0 bytes, ORG \$1000
  Section code: 9 bytes
    C \$0000: CD 00 00 CD 00 00 C3 00 00
  Section lib: 0 bytes
  Externs:
    U         func1_alias
    U         func2_alias
    U         computed_end
  Expressions:
    E W \$0000 \$0001 3: func1_alias (section code) (file ${test}.asm:7)
    E W \$0003 \$0004 3: func2_alias (section code) (file ${test}.asm:8)
    E W \$0006 \$0007 3: computed_end (section code) (file ${test}.asm:9)
Object  file ${test}1.o at \$0000: Z80RMF18
  Name: ${test}1
  CPU:  z80 
  Section "": 0 bytes, ORG \$1000
  Section code: 1 bytes
    C \$0000: C8
  Section lib: 1 bytes
    C \$0000: C9
  Symbols:
    G A \$0000: func2 (section code) (file ${test}1.asm:10)
    G A \$0000: func1 (section lib) (file ${test}1.asm:7)
Object  file ${test}2.o at \$0000: Z80RMF18
  Name: ${test}2
  CPU:  z80 
  Section "": 0 bytes, ORG \$1000
  Section code: 0 bytes
  Section lib: 0 bytes
  Symbols:
    L = \$0000: chain1 (section lib) (file ${test}2.asm:11)
    L A \$0000: chain2 (section lib) (file ${test}2.asm:12)
    G = \$0000: func1_alias (section lib) (file ${test}2.asm:7)
    G = \$0000: func2_alias (section lib) (file ${test}2.asm:8)
    G = \$0000: computed_end (section lib) (file ${test}2.asm:10)
  Externs:
    U         func1
    U         func2
  Expressions:
    E = \$0000 \$0000 0: func1_alias := func1 (section lib) (file ${test}2.asm:7)
    E = \$0000 \$0000 0: func2_alias := func2 (section lib) (file ${test}2.asm:8)
    E = \$0000 \$0000 0: computed_end := chain1+1 (section lib) (file ${test}2.asm:10)
    E = \$0000 \$0000 0: chain1 := chain2-1 (section lib) (file ${test}2.asm:11)
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

capture_ok("z88dk-z80nm -a ${test}.o ${test}1.o ${test}2.o", <<END);
Object  file ${test}.o at \$0000: Z80RMF18
  Name: ${test}
  CPU:  z80 
  Section "": 0 bytes, ORG \$1000
  Symbols:
    G = \$0000: asm_b_vector_at (section "") (file ${test}.asm:4)
  Externs:
    U         asm_b_array_at
  Expressions:
    E = \$0000 \$0000 0: asm_b_vector_at := asm_b_array_at (section "") (file ${test}.asm:4)
Object  file ${test}1.o at \$0000: Z80RMF18
  Name: ${test}1
  CPU:  z80 
  Section "": 1 bytes, ORG \$1000
    C \$0000: C9
  Symbols:
    G A \$0000: asm_b_array_at (section "") (file ${test}1.asm:3)
Object  file ${test}2.o at \$0000: Z80RMF18
  Name: ${test}2
  CPU:  z80 
  Section "": 7 bytes, ORG \$1000
    C \$0000: CD 00 00 CD 00 00 C9
  Symbols:
    L A \$0000: start (section "") (file ${test}2.asm:4)
  Externs:
    U         asm_b_vector_at
    U         asm_b_array_at
  Expressions:
    E W \$0000 \$0001 3: asm_b_vector_at (section "") (file ${test}2.asm:5)
    E W \$0003 \$0004 3: asm_b_array_at (section "") (file ${test}2.asm:6)
END


unlink_testfiles;
done_testing;
