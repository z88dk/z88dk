divert(-1)

###############################################################
# C LIBRARY USER CONFIGURATION
# rebuild the library if changes are made
#

; #############################################################
; ## Multithreading ###########################################
; #############################################################

; Enables multithreading features of the library.
; Multithreading features are not complete so leave disabled.

define(`__CLIB_OPT_MULTITHREAD', 0x00)

define(`__CLIB_OPT_MULTITHREAD_LOCK_HEAPS', 0x01)
define(`__CLIB_OPT_MULTITHREAD_LOCK_FILES', 0x02)
define(`__CLIB_OPT_MULTITHREAD_LOCK_FLIST', 0x04)
define(`__CLIB_OPT_MULTITHREAD_LOCK_FDTBL', 0x08)
define(`__CLIB_OPT_MULTITHREAD_LOCK_FDSTR', 0x10)

; bit 0 = $01 = enable locking on heaps
; bit 1 = $02 = enable recursive locks on FILEs
; bit 2 = $04 = enable stdio lock on lists of FILEs
; bit 3 = $08 = enable fcntl lock on fd_table
; bit 4 = $10 = enable fdstruct locks

; Set to zero if you are making traditional single threaded
; programs.  Setting to zero will reduce code size and
; slightly speed up execution.
;
; When multithreading is enabled, the program can still
; bypass locking by calling the _unlocked versions of functions
; but if there are synchronization issues, you do so at
; your own risk.
;
; When multithreading is disabled, there is no difference
; between the _unlocked and regular function entry points.
; However, the locks are still present in the data structures
; and, for example, FILEs can still be locked via flockfile()
; and family.  Note that when multithreading is disabled,
; the stdio functions will not be blocked by a lock but the
; user program can perform its own synchronization by using
; flockfile() appropriately.

; #############################################################
; ## Integer Math Options #####################################
; #############################################################

; This option affects how multiplications and divisions
; of integers and longs are performed by the compiler
; and the library.

; Setting the value of this flag appropriately allows
; selection of an integer math lib that ranges from
; fast and big to slow and small.

define(`__CLIB_OPT_IMATH', 0)

; < 50 = select small integer math library
; > 50 = select fast integer math library

; The specific integer math library selected above
; can be further tailored by choosing options below.

; FAST INTEGER MATH LIBRARY OPTIONS

define(`__CLIB_OPT_IMATH_FAST', 0x0f)

define(`__CLIB_OPT_IMATH_FAST_DIV_UNROLL', 0x01)
define(`__CLIB_OPT_IMATH_FAST_DIV_LZEROS', 0x02)
define(`__CLIB_OPT_IMATH_FAST_MUL_UNROLL', 0x04)
define(`__CLIB_OPT_IMATH_FAST_MUL_LZEROS', 0x08)
define(`__CLIB_OPT_IMATH_FAST_LIA', 0x80)

; bit 0 = $01 = enable loop unrolling in division
; bit 1 = $02 = enable leading zero elimination in division
; bit 2 = $04 = enable loop unrolling in multiplication
; bit 3 = $08 = enable leading zero elimination in multiplication
; bit 7 = $80 = enable LIA-1 overflow saturation for multiplication

; Notes:
;
; The C standard specifies that unsigned multiplication
; is performed modulo the bit width of the type size
; (ie multiplies "wrap").  In contrast, LIA-1 specifies
; that overflowing multiplies should saturate.  The LIA-1
; option causes multiplications to adopt this behaviour :-
; overflowing multiplies saturate to maximum value and
; errno is set to indicate an overflow condition.  Adopting
; this option not only leads to more correct results but
; also leads to faster multiplication code.
;
; The compilers cannot generate code for LIA-1 mode at this time.

; The following flag allows selection between small+slow
; and big+fast implementations of some integer math operations:

define(`__CLIB_OPT_IMATH_SELECT', 0x00)

define(`__CLIB_OPT_IMATH_SELECT_FAST_ASR', 0x01)
define(`__CLIB_OPT_IMATH_SELECT_FAST_LSR', 0x02)
define(`__CLIB_OPT_IMATH_SELECT_FAST_LSL', 0x04)

; bit 0 = $01 = choose fast arithmetic shift right operator
; bit 1 = $02 = choose fast logical shift right operator
; bit 2 = $04 = choose fast shift left operator

; #############################################################
; ## Text to Number Conversion ################################
; #############################################################

; Specialized functions are available for fast conversion
; of binary, octal, decimal and hex numbers.
;
; Setting the appropriate bits in this flag will enable
; use of those specialized functions by the library.

define(`__CLIB_OPT_TXT2NUM', 0x04)

define(`__CLIB_OPT_TXT2NUM_INT_BIN', 0x01)
define(`__CLIB_OPT_TXT2NUM_INT_OCT', 0x02)
define(`__CLIB_OPT_TXT2NUM_INT_DEC', 0x04)
define(`__CLIB_OPT_TXT2NUM_INT_HEX', 0x08)

define(`__CLIB_OPT_TXT2NUM_LONG_BIN', 0x10)
define(`__CLIB_OPT_TXT2NUM_LONG_OCT', 0x20)
define(`__CLIB_OPT_TXT2NUM_LONG_DEC', 0x40)
define(`__CLIB_OPT_TXT2NUM_LONG_HEX', 0x80)

; bit 0 = $01 = enable specialized binary conversion for integers
; bit 1 = $02 = enable specialized octal conversion for integers
; bit 2 = $04 = enable specialized decimal conversion for integers
; bit 3 = $08 = enable specialized hex conversion for integers
;
; bit 4 = $10 = enable specialized binary conversion for longs
; bit 5 = $20 = enable specialized octal conversion for longs
; bit 6 = $40 = enable specialized decimal conversion for longs
; bit 7 = $80 = enable specialized hex conversion for longs

; Note: Normally, enabling specialized long functions will also
; cause their integer counterparts to be pulled into the user code.
; This is because the specialized long functions will try to
; perform the conversion using faster 16#bit code when it can.
; If you use a specialized long function, you may want to try
; enabling the specialized integer function to see if code
; size remains unchanged.
;
; Note: Some library functions such as printf and scanf may
; use the specialized integer text to decimal conversion
; function directly, in which case enabling that bit will
; result in no additional code size.

; There are two implementations of each specialized function.
; One uses smaller but slower code and the other uses larger
; but faster code.  Choose the faster code by setting the
; appropriate bit in the following flag:

define(`__CLIB_OPT_TXT2NUM_SELECT', 0x00)

define(`__CLIB_OPT_TXT2NUM_SELECT_FAST_BIN', 0x01)
define(`__CLIB_OPT_TXT2NUM_SELECT_FAST_OCT', 0x02)
define(`__CLIB_OPT_TXT2NUM_SELECT_FAST_DEC', 0x04)
define(`__CLIB_OPT_TXT2NUM_SELECT_FAST_HEX', 0x08)

; bit 0 = $01 = choose fast binary conversion
; bit 1 = $02 = choose fast octal conversion
; bit 2 = $04 = choose fast decimal conversion
; bit 3 = $08 = choose fast hex conversion

; #############################################################
; ## Number to Text Conversion ################################
; #############################################################

; Specialized functions are available for fast conversion
; of binary, octal, decimal and hex numbers.
;
; Setting the appropriate bits in this flag will enable
; use of those specialized functions by the library.

define(`__CLIB_OPT_NUM2TXT', 0x00)

define(`__CLIB_OPT_NUM2TXT_INT_BIN', 0x01)
define(`__CLIB_OPT_NUM2TXT_INT_OCT', 0x02)
define(`__CLIB_OPT_NUM2TXT_INT_DEC', 0x04)
define(`__CLIB_OPT_NUM2TXT_INT_HEX', 0x08)

define(`__CLIB_OPT_NUM2TXT_LONG_BIN', 0x10)
define(`__CLIB_OPT_NUM2TXT_LONG_OCT', 0x20)
define(`__CLIB_OPT_NUM2TXT_LONG_DEC', 0x40)
define(`__CLIB_OPT_NUM2TXT_LONG_HEX', 0x80)

; bit 0 = $01 = enable specialized binary conversion for integers
; bit 1 = $02 = enable specialized octal conversion for integers
; bit 2 = $04 = enable specialized decimal conversion for integers
; bit 3 = $08 = enable specialized hex conversion for integers
;
; bit 4 = $10 = enable specialized binary conversion for longs
; bit 5 = $20 = enable specialized octal conversion for longs
; bit 6 = $40 = enable specialized decimal conversion for longs
; bit 7 = $80 = enable specialized hex conversion for longs

; Note: Normally, enabling specialized long functions will also
; cause their integer counterparts to be pulled into the user code.
; This is because the specialized long functions will try to
; perform the conversion using faster 16#bit code when it can.
; If you use a specialized long function, you may want to try
; enabling the specialized integer function to see if code
; size remains unchanged.

; There are two implementations of each specialized function.
; One uses smaller but slower code and the other uses larger
; but faster code.  Choose the faster code by setting the
; appropriate bit in the following flag:

define(`__CLIB_OPT_NUM2TXT_SELECT', 0x00)

define(`__CLIB_OPT_NUM2TXT_SELECT_FAST_BIN', 0x01)
define(`__CLIB_OPT_NUM2TXT_SELECT_FAST_OCT', 0x02)
define(`__CLIB_OPT_NUM2TXT_SELECT_FAST_DEC', 0x04)
define(`__CLIB_OPT_NUM2TXT_SELECT_FAST_HEX', 0x08)

; bit 0 = $01 = choose fast binary conversion
; bit 1 = $02 = choose fast octal conversion
; bit 2 = $04 = choose fast decimal conversion
; bit 3 = $08 = choose fast hex conversion

; #############################################################
; ## STDIO Options ############################################
; #############################################################

define(`__CLIB_OPT_STDIO', 0x00)

define(`__CLIB_OPT_STDIO_VALID', 0x01)

; bit 0 = $01 = stdio checks the validity of the FILE
;               prior to every operation.

; The following define some clib-side ascii character codes

define(`CHAR_CR', 13)
define(`CHAR_LF', 10)

define(`CHAR_BS',     12)
define(`CHAR_ESC',    27)
define(`CHAR_CAPS',    6)
define(`CHAR_BELL',    7)
define(`CHAR_CTRL_C',  3)
define(`CHAR_CTRL_D',  4)
define(`CHAR_CTRL_Z', 26)

define(`CHAR_CURSOR_UC', 45)
define(`CHAR_CURSOR_LC', 95)
define(`CHAR_PASSWORD',  42)

; #############################################################
; ## PRINTF Converter Selection ###############################
; #############################################################

; You can select which printf converters are included in
; the library.  Omitting unused ones can reduce code size.
; Note the bit assignments are the same as for scanf.

define(`__CLIB_OPT_PRINTF', 0x002ff6ff)

define(`__CLIB_OPT_PRINTF_d',  0x00000001)
define(`__CLIB_OPT_PRINTF_u',  0x00000002)
define(`__CLIB_OPT_PRINTF_x',  0x00000004)
define(`__CLIB_OPT_PRINTF_X',  0x00000008)
define(`__CLIB_OPT_PRINTF_o',  0x00000010)
define(`__CLIB_OPT_PRINTF_n',  0x00000020)
define(`__CLIB_OPT_PRINTF_i',  0x00000040)
define(`__CLIB_OPT_PRINTF_p',  0x00000080)
define(`__CLIB_OPT_PRINTF_B',  0x00000100)
define(`__CLIB_OPT_PRINTF_s',  0x00000200)
define(`__CLIB_OPT_PRINTF_c',  0x00000400)
define(`__CLIB_OPT_PRINTF_I',  0x00000800)
define(`__CLIB_OPT_PRINTF_ld', 0x00001000)
define(`__CLIB_OPT_PRINTF_lu', 0x00002000)
define(`__CLIB_OPT_PRINTF_lx', 0x00004000)
define(`__CLIB_OPT_PRINTF_lX', 0x00008000)
define(`__CLIB_OPT_PRINTF_lo', 0x00010000)
define(`__CLIB_OPT_PRINTF_ln', 0x00020000)
define(`__CLIB_OPT_PRINTF_li', 0x00040000)
define(`__CLIB_OPT_PRINTF_lp', 0x00080000)
define(`__CLIB_OPT_PRINTF_lB', 0x00100000)
define(`__CLIB_OPT_PRINTF_a',  0x00400000)
define(`__CLIB_OPT_PRINTF_A',  0x00800000)
define(`__CLIB_OPT_PRINTF_e',  0x01000000)
define(`__CLIB_OPT_PRINTF_E',  0x02000000)
define(`__CLIB_OPT_PRINTF_f',  0x04000000)
define(`__CLIB_OPT_PRINTF_F',  0x08000000)
define(`__CLIB_OPT_PRINTF_g',  0x10000000)
define(`__CLIB_OPT_PRINTF_G',  0x20000000)

; bit 0 =  $      01 = enable %d
; bit 1 =  $      02 = enable %u
; bit 2 =  $      04 = enable %x
; bit 3 =  $      08 = enable %X
; bit 4 =  $      10 = enable %o
; bit 5 =  $      20 = enable %n
; bit 6 =  $      40 = enable %i
; bit 7 =  $      80 = enable %p
; bit 8 =  $     100 = enable %B
; bit 9 =  $     200 = enable %s
; bit 10 = $     400 = enable %c
; bit 11 = $     800 = enable %I
; bit 12 = $    1000 = enable %ld
; bit 13 = $    2000 = enable %lu
; bit 14 = $    4000 = enable %lx
; bit 15 = $    8000 = enable %lX
; bit 16 = $   10000 = enable %lo
; bit 17 = $   20000 = enable %ln
; bit 18 = $   40000 = enable %li
; bit 19 = $   80000 = enable %lp
; bit 20 = $  100000 = enable %lB
; bit 21 = $  200000 = ignored
; bit 22 = $  400000 = enable %a
; bit 23 = $  800000 = enable %A
; bit 24 = $ 1000000 = enable %e
; bit 25 = $ 2000000 = enable %E
; bit 26 = $ 4000000 = enable %f
; bit 27 = $ 8000000 = enable %F
; bit 28 = $10000000 = enable %g
; bit 29 = $20000000 = enable %G

define(`__CLIB_OPT_PRINTF_2', 0x00)

define(`__CLIB_OPT_PRINTF_2_lld', 0x01)
define(`__CLIB_OPT_PRINTF_2_llu', 0x02)
define(`__CLIB_OPT_PRINTF_2_llx', 0x04)
define(`__CLIB_OPT_PRINTF_2_llX', 0x08)
define(`__CLIB_OPT_PRINTF_2_llo', 0x10)
define(`__CLIB_OPT_PRINTF_2_lli', 0x40)

; bit 0 =  $      01 = enable %lld
; bit 1 =  $      02 = enable %llu
; bit 2 =  $      04 = enable %llx
; bit 3 =  $      08 = enable %llX
; bit 4 =  $      10 = enable %llo
; bit 5 =  $      20 = ignored
; bit 6 =  $      40 = enable %lli

; Setting all flag bits to zero will remove the % logic
; from printf entirely, meaning printf can only be used
; to output format text to the stream.

; #############################################################
; ## SCANF Converter Selection ################################
; #############################################################

; You can select which scanf converters are included in
; the library.  Omitting unused ones can reduce code size.
; Note the bit assignments are the same as for printf.

define(`__CLIB_OPT_SCANF', 0x002ff6ff)

define(`__CLIB_OPT_SCANF_d',  0x00000001)
define(`__CLIB_OPT_SCANF_u',  0x00000002)
define(`__CLIB_OPT_SCANF_x',  0x00000004)
define(`__CLIB_OPT_SCANF_X',  0x00000008)
define(`__CLIB_OPT_SCANF_o',  0x00000010)
define(`__CLIB_OPT_SCANF_n',  0x00000020)
define(`__CLIB_OPT_SCANF_i',  0x00000040)
define(`__CLIB_OPT_SCANF_p',  0x00000080)
define(`__CLIB_OPT_SCANF_B',  0x00000100)
define(`__CLIB_OPT_SCANF_s',  0x00000200)
define(`__CLIB_OPT_SCANF_c',  0x00000400)
define(`__CLIB_OPT_SCANF_I',  0x00000800)
define(`__CLIB_OPT_SCANF_ld', 0x00001000)
define(`__CLIB_OPT_SCANF_lu', 0x00002000)
define(`__CLIB_OPT_SCANF_lx', 0x00004000)
define(`__CLIB_OPT_SCANF_lX', 0x00008000)
define(`__CLIB_OPT_SCANF_lo', 0x00010000)
define(`__CLIB_OPT_SCANF_ln', 0x00020000)
define(`__CLIB_OPT_SCANF_li', 0x00040000)
define(`__CLIB_OPT_SCANF_lp', 0x00080000)
define(`__CLIB_OPT_SCANF_lB', 0x00100000)
define(`__CLIB_OPT_SCANF_BRACKET', 0x00200000)
define(`__CLIB_OPT_SCANF_a',  0x00400000)
define(`__CLIB_OPT_SCANF_A',  0x00800000)
define(`__CLIB_OPT_SCANF_e',  0x01000000)
define(`__CLIB_OPT_SCANF_E',  0x02000000)
define(`__CLIB_OPT_SCANF_f',  0x04000000)
define(`__CLIB_OPT_SCANF_F',  0x08000000)
define(`__CLIB_OPT_SCANF_g',  0x10000000)
define(`__CLIB_OPT_SCANF_G',  0x20000000)

; bit 0 =  $    01 = enable %d
; bit 1 =  $    02 = enable %u
; bit 2 =  $    04 = enable %x
; bit 3 =  $    08 = enable %x (duplicate)
; bit 4 =  $    10 = enable %o
; bit 5 =  $    20 = enable %n
; bit 6 =  $    40 = enable %i
; bit 7 =  $    80 = enable %p
; bit 8 =  $   100 = enable %B
; bit 9 =  $   200 = enable %s
; bit 10 = $   400 = enable %c
; bit 11 = $   800 = enable %I
; bit 12 = $  1000 = enable %ld
; bit 13 = $  2000 = enable %lu
; bit 14 = $  4000 = enable %lx
; bit 15 = $  8000 = enable %lx (duplicate)
; bit 16 = $ 10000 = enable %lo
; bit 17 = $ 20000 = enable %ln
; bit 18 = $ 40000 = enable %li
; bit 19 = $ 80000 = enable %lp
; bit 20 = $100000 = enable %lB
; bit 21 = $200000 = enable %[

define(`__CLIB_OPT_SCANF_2', 0x00)

define(`__CLIB_OPT_SCANF_2_lld', 0x01)
define(`__CLIB_OPT_SCANF_2_llu', 0x02)
define(`__CLIB_OPT_SCANF_2_llx', 0x04)
define(`__CLIB_OPT_SCANF_2_llX', 0x08)
define(`__CLIB_OPT_SCANF_2_llo', 0x10)
define(`__CLIB_OPT_SCANF_2_lli', 0x40)

; bit 0 =  $      01 = enable %lld
; bit 1 =  $      02 = enable %llu
; bit 2 =  $      04 = enable %llx
; bit 3 =  $      08 = enable %llX
; bit 4 =  $      10 = enable %llo
; bit 5 =  $      20 = ignored
; bit 6 =  $      40 = enable %lli

; Setting all flag bits to zero will remove the % logic
; from scanf entirely, meaning scanf can only be used to
; match format text against the stream.

; #############################################################
; ## STDLIB Options ###########################################
; #############################################################

; Select whether fast memset and fast memcpy are enabled.
; For copies of minimum size unrolled loops will be used.

define(`__CLIB_OPT_FASTCOPY', 0x00)

define(`__CLIB_OPT_FASTCOPY_MEMCPY',     0x01)
define(`__CLIB_OPT_FASTCOPY_MEMSET',     0x02)
define(`__CLIB_OPT_FASTCOPY_LDIR',       0x20)
define(`__CLIB_OPT_FASTCOPY_LDIR_SMC',   0x40)
define(`__CLIB_OPT_FASTCOPY_MEMCPY_SMC', 0x80)

; bit 0 = $01 = enable fast memcpy
; bit 1 = $02 = enable fast memset
; bit 5 = $20 = enable fast ldir for some library functions
; bit 6 = $40 = enable self-modifying fast ldir implementation for the library
;         (faster but makes code non#reentrant)
; bit 7 = $80 = self-modifying l_fast_memcpy_smc made available for user code only
;         (does not enable self-modifying code for the lib; bit 6 set also makes available)

; Select whether strtod() and atof() include code to parse
; hex floats and nan/inf strings.

define(`__CLIB_OPT_STRTOD', 0x00)

define(`__CLIB_OPT_STRTOD_NAN', 0x01)
define(`__CLIB_OPT_STRTOD_INF', 0x01)
define(`__CLIB_OPT_STRTOD_HEX', 0x02)

; bit 0 = $01 = enable parsing of nan/inf strings
; bit 1 = $02 = enable parsing of hex floats

; Select which sorting algorithm is used by qsort()

define(`__CLIB_OPT_SORT', 1)

define(`__CLIB_OPT_SORT_INSERTION', 0)
define(`__CLIB_OPT_SORT_SHELL', 1)
define(`__CLIB_OPT_SORT_QUICK', 2)

; 0 = insertion sort
; 1 = shell sort (not reentrant)
; 2 = quick sort

; Some sorting algorithms have selectable options.

define(`__CLIB_OPT_SORT_QSORT', 0x0c)

define(`__CLIB_OPT_SORT_QSORT_PIVOT',        0x3)
define(`__CLIB_OPT_SORT_QSORT_PIVOT_MID',    0x0)
define(`__CLIB_OPT_SORT_QSORT_PIVOT_RAN',    0x1)
define(`__CLIB_OPT_SORT_QSORT_ENABLE_INSERTION', 0x04)
define(`__CLIB_OPT_SORT_QSORT_ENABLE_EQUAL', 0x08)

; bit 10 = pivot selection
;          $00 = pivot is middle item
;          $01 = pivot is random item
; bit  2 = $04 = enable insertion sort for small partitions
; bit  3 = $08 = enable equal items distribution

; #############################################################
; ## Error Strings ############################################
; #############################################################

define(`__CLIB_OPT_ERROR', 0x00)

define(`__CLIB_OPT_ERROR_ENABLED', 0x01)
define(`__CLIB_OPT_ERROR_VERBOSE', 0x02)

; bit 0 = $01 = enable error strings
; bit 1 = $02 = select verbose error strings

; Set to zero to reduce binary footprint.

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__CLIB_OPT_MULTITHREAD'

PUBLIC `__CLIB_OPT_MULTITHREAD_LOCK_HEAPS'
PUBLIC `__CLIB_OPT_MULTITHREAD_LOCK_FILES'
PUBLIC `__CLIB_OPT_MULTITHREAD_LOCK_FLIST'
PUBLIC `__CLIB_OPT_MULTITHREAD_LOCK_FDTBL'
PUBLIC `__CLIB_OPT_MULTITHREAD_LOCK_FDSTR'

PUBLIC `__CLIB_OPT_IMATH'

PUBLIC `__CLIB_OPT_IMATH_FAST'

PUBLIC `__CLIB_OPT_IMATH_FAST_DIV_UNROLL'
PUBLIC `__CLIB_OPT_IMATH_FAST_DIV_LZEROS'
PUBLIC `__CLIB_OPT_IMATH_FAST_MUL_UNROLL'
PUBLIC `__CLIB_OPT_IMATH_FAST_MUL_LZEROS'
PUBLIC `__CLIB_OPT_IMATH_FAST_LIA'

PUBLIC `__CLIB_OPT_IMATH_SELECT'

PUBLIC `__CLIB_OPT_IMATH_SELECT_FAST_ASR'
PUBLIC `__CLIB_OPT_IMATH_SELECT_FAST_LSR'
PUBLIC `__CLIB_OPT_IMATH_SELECT_FAST_LSL'

PUBLIC `__CLIB_OPT_TXT2NUM'

PUBLIC `__CLIB_OPT_TXT2NUM_INT_BIN'
PUBLIC `__CLIB_OPT_TXT2NUM_INT_OCT'
PUBLIC `__CLIB_OPT_TXT2NUM_INT_DEC'
PUBLIC `__CLIB_OPT_TXT2NUM_INT_HEX'

PUBLIC `__CLIB_OPT_TXT2NUM_LONG_BIN'
PUBLIC `__CLIB_OPT_TXT2NUM_LONG_OCT'
PUBLIC `__CLIB_OPT_TXT2NUM_LONG_DEC'
PUBLIC `__CLIB_OPT_TXT2NUM_LONG_HEX'

PUBLIC `__CLIB_OPT_TXT2NUM_SELECT'

PUBLIC `__CLIB_OPT_TXT2NUM_SELECT_FAST_BIN'
PUBLIC `__CLIB_OPT_TXT2NUM_SELECT_FAST_OCT'
PUBLIC `__CLIB_OPT_TXT2NUM_SELECT_FAST_DEC'
PUBLIC `__CLIB_OPT_TXT2NUM_SELECT_FAST_HEX'

PUBLIC `__CLIB_OPT_NUM2TXT'

PUBLIC `__CLIB_OPT_NUM2TXT_INT_BIN'
PUBLIC `__CLIB_OPT_NUM2TXT_INT_OCT'
PUBLIC `__CLIB_OPT_NUM2TXT_INT_DEC'
PUBLIC `__CLIB_OPT_NUM2TXT_INT_HEX'

PUBLIC `__CLIB_OPT_NUM2TXT_LONG_BIN'
PUBLIC `__CLIB_OPT_NUM2TXT_LONG_OCT'
PUBLIC `__CLIB_OPT_NUM2TXT_LONG_DEC'
PUBLIC `__CLIB_OPT_NUM2TXT_LONG_HEX'

PUBLIC `__CLIB_OPT_NUM2TXT_SELECT'

PUBLIC `__CLIB_OPT_NUM2TXT_SELECT_FAST_BIN'
PUBLIC `__CLIB_OPT_NUM2TXT_SELECT_FAST_OCT'
PUBLIC `__CLIB_OPT_NUM2TXT_SELECT_FAST_DEC'
PUBLIC `__CLIB_OPT_NUM2TXT_SELECT_FAST_HEX'

PUBLIC `__CLIB_OPT_STDIO'

PUBLIC `__CLIB_OPT_STDIO_VALID'

PUBLIC `CHAR_CR'
PUBLIC `CHAR_LF'
PUBLIC `CHAR_BS'
PUBLIC `CHAR_ESC'
PUBLIC `CHAR_CAPS'
PUBLIC `CHAR_BELL'
PUBLIC `CHAR_CTRL_C'
PUBLIC `CHAR_CTRL_D'
PUBLIC `CHAR_CTRL_Z'
PUBLIC `CHAR_CURSOR_UC'
PUBLIC `CHAR_CURSOR_LC'
PUBLIC `CHAR_PASSWORD'

PUBLIC `__CLIB_OPT_PRINTF'

PUBLIC `__CLIB_OPT_PRINTF_d'
PUBLIC `__CLIB_OPT_PRINTF_u'
PUBLIC `__CLIB_OPT_PRINTF_x'
PUBLIC `__CLIB_OPT_PRINTF_X'
PUBLIC `__CLIB_OPT_PRINTF_o'
PUBLIC `__CLIB_OPT_PRINTF_n'
PUBLIC `__CLIB_OPT_PRINTF_i'
PUBLIC `__CLIB_OPT_PRINTF_p'
PUBLIC `__CLIB_OPT_PRINTF_B'
PUBLIC `__CLIB_OPT_PRINTF_s'
PUBLIC `__CLIB_OPT_PRINTF_c'
PUBLIC `__CLIB_OPT_PRINTF_I'
PUBLIC `__CLIB_OPT_PRINTF_ld'
PUBLIC `__CLIB_OPT_PRINTF_lu'
PUBLIC `__CLIB_OPT_PRINTF_lx'
PUBLIC `__CLIB_OPT_PRINTF_lX'
PUBLIC `__CLIB_OPT_PRINTF_lo'
PUBLIC `__CLIB_OPT_PRINTF_ln'
PUBLIC `__CLIB_OPT_PRINTF_li'
PUBLIC `__CLIB_OPT_PRINTF_lp'
PUBLIC `__CLIB_OPT_PRINTF_lB'
PUBLIC `__CLIB_OPT_PRINTF_a'
PUBLIC `__CLIB_OPT_PRINTF_A'
PUBLIC `__CLIB_OPT_PRINTF_e'
PUBLIC `__CLIB_OPT_PRINTF_E'
PUBLIC `__CLIB_OPT_PRINTF_f'
PUBLIC `__CLIB_OPT_PRINTF_F'
PUBLIC `__CLIB_OPT_PRINTF_g'
PUBLIC `__CLIB_OPT_PRINTF_G'

PUBLIC `__CLIB_OPT_PRINTF_2'

PUBLIC `__CLIB_OPT_PRINTF_2_lld'
PUBLIC `__CLIB_OPT_PRINTF_2_llu'
PUBLIC `__CLIB_OPT_PRINTF_2_llx'
PUBLIC `__CLIB_OPT_PRINTF_2_llX'
PUBLIC `__CLIB_OPT_PRINTF_2_llo'
PUBLIC `__CLIB_OPT_PRINTF_2_lli'

PUBLIC `__CLIB_OPT_SCANF'

PUBLIC `__CLIB_OPT_SCANF_d'
PUBLIC `__CLIB_OPT_SCANF_u'
PUBLIC `__CLIB_OPT_SCANF_x'
PUBLIC `__CLIB_OPT_SCANF_X'
PUBLIC `__CLIB_OPT_SCANF_o'
PUBLIC `__CLIB_OPT_SCANF_n'
PUBLIC `__CLIB_OPT_SCANF_i'
PUBLIC `__CLIB_OPT_SCANF_p'
PUBLIC `__CLIB_OPT_SCANF_B'
PUBLIC `__CLIB_OPT_SCANF_s'
PUBLIC `__CLIB_OPT_SCANF_c'
PUBLIC `__CLIB_OPT_SCANF_I'
PUBLIC `__CLIB_OPT_SCANF_ld'
PUBLIC `__CLIB_OPT_SCANF_lu'
PUBLIC `__CLIB_OPT_SCANF_lx'
PUBLIC `__CLIB_OPT_SCANF_lX'
PUBLIC `__CLIB_OPT_SCANF_lo'
PUBLIC `__CLIB_OPT_SCANF_ln'
PUBLIC `__CLIB_OPT_SCANF_li'
PUBLIC `__CLIB_OPT_SCANF_lp'
PUBLIC `__CLIB_OPT_SCANF_lB'
PUBLIC `__CLIB_OPT_SCANF_BRACKET'
PUBLIC `__CLIB_OPT_SCANF_a'
PUBLIC `__CLIB_OPT_SCANF_A'
PUBLIC `__CLIB_OPT_SCANF_e'
PUBLIC `__CLIB_OPT_SCANF_E'
PUBLIC `__CLIB_OPT_SCANF_f'
PUBLIC `__CLIB_OPT_SCANF_F'
PUBLIC `__CLIB_OPT_SCANF_g'
PUBLIC `__CLIB_OPT_SCANF_G'

PUBLIC `__CLIB_OPT_SCANF_2'

PUBLIC `__CLIB_OPT_SCANF_2_lld'
PUBLIC `__CLIB_OPT_SCANF_2_llu'
PUBLIC `__CLIB_OPT_SCANF_2_llx'
PUBLIC `__CLIB_OPT_SCANF_2_llX'
PUBLIC `__CLIB_OPT_SCANF_2_llo'
PUBLIC `__CLIB_OPT_SCANF_2_lli'

PUBLIC `__CLIB_OPT_FASTCOPY'

PUBLIC `__CLIB_OPT_FASTCOPY_MEMCPY'
PUBLIC `__CLIB_OPT_FASTCOPY_MEMSET'
PUBLIC `__CLIB_OPT_FASTCOPY_LDIR'
PUBLIC `__CLIB_OPT_FASTCOPY_LDIR_SMC'
PUBLIC `__CLIB_OPT_FASTCOPY_MEMCPY_SMC'

PUBLIC `__CLIB_OPT_STRTOD'

PUBLIC `__CLIB_OPT_STRTOD_NAN'
PUBLIC `__CLIB_OPT_STRTOD_INF'
PUBLIC `__CLIB_OPT_STRTOD_HEX'

PUBLIC `__CLIB_OPT_SORT'

PUBLIC `__CLIB_OPT_SORT_INSERTION'
PUBLIC `__CLIB_OPT_SORT_SHELL'
PUBLIC `__CLIB_OPT_SORT_QUICK'

PUBLIC `__CLIB_OPT_SORT_QSORT'

PUBLIC `__CLIB_OPT_SORT_QSORT_PIVOT'
PUBLIC `__CLIB_OPT_SORT_QSORT_PIVOT_MID'
PUBLIC `__CLIB_OPT_SORT_QSORT_PIVOT_RAN'
PUBLIC `__CLIB_OPT_SORT_QSORT_ENABLE_INSERTION'
PUBLIC `__CLIB_OPT_SORT_QSORT_ENABLE_EQUAL'

PUBLIC `__CLIB_OPT_ERROR'

PUBLIC `__CLIB_OPT_ERROR_ENABLED'
PUBLIC `__CLIB_OPT_ERROR_VERBOSE'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__CLIB_OPT_MULTITHREAD' = __CLIB_OPT_MULTITHREAD

defc `__CLIB_OPT_MULTITHREAD_LOCK_HEAPS' = __CLIB_OPT_MULTITHREAD_LOCK_HEAPS
defc `__CLIB_OPT_MULTITHREAD_LOCK_FILES' = __CLIB_OPT_MULTITHREAD_LOCK_FILES
defc `__CLIB_OPT_MULTITHREAD_LOCK_FLIST' = __CLIB_OPT_MULTITHREAD_LOCK_FLIST
defc `__CLIB_OPT_MULTITHREAD_LOCK_FDTBL' = __CLIB_OPT_MULTITHREAD_LOCK_FDTBL
defc `__CLIB_OPT_MULTITHREAD_LOCK_FDSTR' = __CLIB_OPT_MULTITHREAD_LOCK_FDSTR

defc `__CLIB_OPT_IMATH' = __CLIB_OPT_IMATH

defc `__CLIB_OPT_IMATH_FAST' = __CLIB_OPT_IMATH_FAST

defc `__CLIB_OPT_IMATH_FAST_DIV_UNROLL' = __CLIB_OPT_IMATH_FAST_DIV_UNROLL
defc `__CLIB_OPT_IMATH_FAST_DIV_LZEROS' = __CLIB_OPT_IMATH_FAST_DIV_LZEROS
defc `__CLIB_OPT_IMATH_FAST_MUL_UNROLL' = __CLIB_OPT_IMATH_FAST_MUL_UNROLL
defc `__CLIB_OPT_IMATH_FAST_MUL_LZEROS' = __CLIB_OPT_IMATH_FAST_MUL_LZEROS
defc `__CLIB_OPT_IMATH_FAST_LIA' = __CLIB_OPT_IMATH_FAST_LIA

defc `__CLIB_OPT_IMATH_SELECT' = __CLIB_OPT_IMATH_SELECT

defc `__CLIB_OPT_IMATH_SELECT_FAST_ASR' = __CLIB_OPT_IMATH_SELECT_FAST_ASR
defc `__CLIB_OPT_IMATH_SELECT_FAST_LSR' = __CLIB_OPT_IMATH_SELECT_FAST_LSR
defc `__CLIB_OPT_IMATH_SELECT_FAST_LSL' = __CLIB_OPT_IMATH_SELECT_FAST_LSL

defc `__CLIB_OPT_TXT2NUM' = __CLIB_OPT_TXT2NUM

defc `__CLIB_OPT_TXT2NUM_INT_BIN' = __CLIB_OPT_TXT2NUM_INT_BIN
defc `__CLIB_OPT_TXT2NUM_INT_OCT' = __CLIB_OPT_TXT2NUM_INT_OCT
defc `__CLIB_OPT_TXT2NUM_INT_DEC' = __CLIB_OPT_TXT2NUM_INT_DEC
defc `__CLIB_OPT_TXT2NUM_INT_HEX' = __CLIB_OPT_TXT2NUM_INT_HEX

defc `__CLIB_OPT_TXT2NUM_LONG_BIN' = __CLIB_OPT_TXT2NUM_LONG_BIN
defc `__CLIB_OPT_TXT2NUM_LONG_OCT' = __CLIB_OPT_TXT2NUM_LONG_OCT
defc `__CLIB_OPT_TXT2NUM_LONG_DEC' = __CLIB_OPT_TXT2NUM_LONG_DEC
defc `__CLIB_OPT_TXT2NUM_LONG_HEX' = __CLIB_OPT_TXT2NUM_LONG_HEX

defc `__CLIB_OPT_TXT2NUM_SELECT' = __CLIB_OPT_TXT2NUM_SELECT

defc `__CLIB_OPT_TXT2NUM_SELECT_FAST_BIN' = __CLIB_OPT_TXT2NUM_SELECT_FAST_BIN
defc `__CLIB_OPT_TXT2NUM_SELECT_FAST_OCT' = __CLIB_OPT_TXT2NUM_SELECT_FAST_OCT
defc `__CLIB_OPT_TXT2NUM_SELECT_FAST_DEC' = __CLIB_OPT_TXT2NUM_SELECT_FAST_DEC
defc `__CLIB_OPT_TXT2NUM_SELECT_FAST_HEX' = __CLIB_OPT_TXT2NUM_SELECT_FAST_HEX

defc `__CLIB_OPT_NUM2TXT' = __CLIB_OPT_NUM2TXT

defc `__CLIB_OPT_NUM2TXT_INT_BIN' = __CLIB_OPT_NUM2TXT_INT_BIN
defc `__CLIB_OPT_NUM2TXT_INT_OCT' = __CLIB_OPT_NUM2TXT_INT_OCT
defc `__CLIB_OPT_NUM2TXT_INT_DEC' = __CLIB_OPT_NUM2TXT_INT_DEC
defc `__CLIB_OPT_NUM2TXT_INT_HEX' = __CLIB_OPT_NUM2TXT_INT_HEX

defc `__CLIB_OPT_NUM2TXT_LONG_BIN' = __CLIB_OPT_NUM2TXT_LONG_BIN
defc `__CLIB_OPT_NUM2TXT_LONG_OCT' = __CLIB_OPT_NUM2TXT_LONG_OCT
defc `__CLIB_OPT_NUM2TXT_LONG_DEC' = __CLIB_OPT_NUM2TXT_LONG_DEC
defc `__CLIB_OPT_NUM2TXT_LONG_HEX' = __CLIB_OPT_NUM2TXT_LONG_HEX

defc `__CLIB_OPT_NUM2TXT_SELECT' = __CLIB_OPT_NUM2TXT_SELECT

defc `__CLIB_OPT_NUM2TXT_SELECT_FAST_BIN' = __CLIB_OPT_NUM2TXT_SELECT_FAST_BIN
defc `__CLIB_OPT_NUM2TXT_SELECT_FAST_OCT' = __CLIB_OPT_NUM2TXT_SELECT_FAST_OCT
defc `__CLIB_OPT_NUM2TXT_SELECT_FAST_DEC' = __CLIB_OPT_NUM2TXT_SELECT_FAST_DEC
defc `__CLIB_OPT_NUM2TXT_SELECT_FAST_HEX' = __CLIB_OPT_NUM2TXT_SELECT_FAST_HEX

defc `__CLIB_OPT_STDIO' = __CLIB_OPT_STDIO

defc `__CLIB_OPT_STDIO_VALID' = __CLIB_OPT_STDIO_VALID

defc `CHAR_CR' = CHAR_CR
defc `CHAR_LF' = CHAR_LF
defc `CHAR_BS' = CHAR_BS
defc `CHAR_ESC' = CHAR_ESC
defc `CHAR_CAPS' = CHAR_CAPS
defc `CHAR_BELL' = CHAR_BELL
defc `CHAR_CTRL_C' = CHAR_CTRL_C
defc `CHAR_CTRL_D' = CHAR_CTRL_D
defc `CHAR_CTRL_Z' = CHAR_CTRL_Z
defc `CHAR_CURSOR_UC' = CHAR_CURSOR_UC
defc `CHAR_CURSOR_LC' = CHAR_CURSOR_LC
defc `CHAR_PASSWORD' = CHAR_PASSWORD

defc `__CLIB_OPT_PRINTF' = __CLIB_OPT_PRINTF

defc `__CLIB_OPT_PRINTF_d' = __CLIB_OPT_PRINTF_d
defc `__CLIB_OPT_PRINTF_u' = __CLIB_OPT_PRINTF_u
defc `__CLIB_OPT_PRINTF_x' = __CLIB_OPT_PRINTF_x
defc `__CLIB_OPT_PRINTF_X' = __CLIB_OPT_PRINTF_X
defc `__CLIB_OPT_PRINTF_o' = __CLIB_OPT_PRINTF_o
defc `__CLIB_OPT_PRINTF_n' = __CLIB_OPT_PRINTF_n
defc `__CLIB_OPT_PRINTF_i' = __CLIB_OPT_PRINTF_i
defc `__CLIB_OPT_PRINTF_p' = __CLIB_OPT_PRINTF_p
defc `__CLIB_OPT_PRINTF_B' = __CLIB_OPT_PRINTF_B
defc `__CLIB_OPT_PRINTF_s' = __CLIB_OPT_PRINTF_s
defc `__CLIB_OPT_PRINTF_c' = __CLIB_OPT_PRINTF_c
defc `__CLIB_OPT_PRINTF_I' = __CLIB_OPT_PRINTF_I
defc `__CLIB_OPT_PRINTF_ld' = __CLIB_OPT_PRINTF_ld
defc `__CLIB_OPT_PRINTF_lu' = __CLIB_OPT_PRINTF_lu
defc `__CLIB_OPT_PRINTF_lx' = __CLIB_OPT_PRINTF_lx
defc `__CLIB_OPT_PRINTF_lX' = __CLIB_OPT_PRINTF_lX
defc `__CLIB_OPT_PRINTF_lo' = __CLIB_OPT_PRINTF_lo
defc `__CLIB_OPT_PRINTF_ln' = __CLIB_OPT_PRINTF_ln
defc `__CLIB_OPT_PRINTF_li' = __CLIB_OPT_PRINTF_li
defc `__CLIB_OPT_PRINTF_lp' = __CLIB_OPT_PRINTF_lp
defc `__CLIB_OPT_PRINTF_lB' = __CLIB_OPT_PRINTF_lB
defc `__CLIB_OPT_PRINTF_a' = __CLIB_OPT_PRINTF_a
defc `__CLIB_OPT_PRINTF_A' = __CLIB_OPT_PRINTF_A
defc `__CLIB_OPT_PRINTF_e' = __CLIB_OPT_PRINTF_e
defc `__CLIB_OPT_PRINTF_E' = __CLIB_OPT_PRINTF_E
defc `__CLIB_OPT_PRINTF_f' = __CLIB_OPT_PRINTF_f
defc `__CLIB_OPT_PRINTF_F' = __CLIB_OPT_PRINTF_F
defc `__CLIB_OPT_PRINTF_g' = __CLIB_OPT_PRINTF_g
defc `__CLIB_OPT_PRINTF_G' = __CLIB_OPT_PRINTF_G

defc `__CLIB_OPT_PRINTF_2' = __CLIB_OPT_PRINTF_2

defc `__CLIB_OPT_PRINTF_2_lld' = __CLIB_OPT_PRINTF_2_lld
defc `__CLIB_OPT_PRINTF_2_llu' = __CLIB_OPT_PRINTF_2_llu
defc `__CLIB_OPT_PRINTF_2_llx' = __CLIB_OPT_PRINTF_2_llx
defc `__CLIB_OPT_PRINTF_2_llX' = __CLIB_OPT_PRINTF_2_llX
defc `__CLIB_OPT_PRINTF_2_llo' = __CLIB_OPT_PRINTF_2_llo
defc `__CLIB_OPT_PRINTF_2_lli' = __CLIB_OPT_PRINTF_2_lli

defc `__CLIB_OPT_SCANF' = __CLIB_OPT_SCANF

defc `__CLIB_OPT_SCANF_d' = __CLIB_OPT_SCANF_d
defc `__CLIB_OPT_SCANF_u' = __CLIB_OPT_SCANF_u
defc `__CLIB_OPT_SCANF_x' = __CLIB_OPT_SCANF_x
defc `__CLIB_OPT_SCANF_X' = __CLIB_OPT_SCANF_X
defc `__CLIB_OPT_SCANF_o' = __CLIB_OPT_SCANF_o
defc `__CLIB_OPT_SCANF_n' = __CLIB_OPT_SCANF_n
defc `__CLIB_OPT_SCANF_i' = __CLIB_OPT_SCANF_i
defc `__CLIB_OPT_SCANF_p' = __CLIB_OPT_SCANF_p
defc `__CLIB_OPT_SCANF_B' = __CLIB_OPT_SCANF_B
defc `__CLIB_OPT_SCANF_s' = __CLIB_OPT_SCANF_s
defc `__CLIB_OPT_SCANF_c' = __CLIB_OPT_SCANF_c
defc `__CLIB_OPT_SCANF_I' = __CLIB_OPT_SCANF_I
defc `__CLIB_OPT_SCANF_ld' = __CLIB_OPT_SCANF_ld
defc `__CLIB_OPT_SCANF_lu' = __CLIB_OPT_SCANF_lu
defc `__CLIB_OPT_SCANF_lx' = __CLIB_OPT_SCANF_lx
defc `__CLIB_OPT_SCANF_lX' = __CLIB_OPT_SCANF_lX
defc `__CLIB_OPT_SCANF_lo' = __CLIB_OPT_SCANF_lo
defc `__CLIB_OPT_SCANF_ln' = __CLIB_OPT_SCANF_ln
defc `__CLIB_OPT_SCANF_li' = __CLIB_OPT_SCANF_li
defc `__CLIB_OPT_SCANF_lp' = __CLIB_OPT_SCANF_lp
defc `__CLIB_OPT_SCANF_lB' = __CLIB_OPT_SCANF_lB
defc `__CLIB_OPT_SCANF_BRACKET' = __CLIB_OPT_SCANF_BRACKET
defc `__CLIB_OPT_SCANF_a' = __CLIB_OPT_SCANF_a
defc `__CLIB_OPT_SCANF_A' = __CLIB_OPT_SCANF_A
defc `__CLIB_OPT_SCANF_e' = __CLIB_OPT_SCANF_e
defc `__CLIB_OPT_SCANF_E' = __CLIB_OPT_SCANF_E
defc `__CLIB_OPT_SCANF_f' = __CLIB_OPT_SCANF_f
defc `__CLIB_OPT_SCANF_F' = __CLIB_OPT_SCANF_F
defc `__CLIB_OPT_SCANF_g' = __CLIB_OPT_SCANF_g
defc `__CLIB_OPT_SCANF_G' = __CLIB_OPT_SCANF_G

defc `__CLIB_OPT_SCANF_2' = __CLIB_OPT_SCANF_2

defc `__CLIB_OPT_SCANF_2_lld' = __CLIB_OPT_SCANF_2_lld
defc `__CLIB_OPT_SCANF_2_llu' = __CLIB_OPT_SCANF_2_llu
defc `__CLIB_OPT_SCANF_2_llx' = __CLIB_OPT_SCANF_2_llx
defc `__CLIB_OPT_SCANF_2_llX' = __CLIB_OPT_SCANF_2_llX
defc `__CLIB_OPT_SCANF_2_llo' = __CLIB_OPT_SCANF_2_llo
defc `__CLIB_OPT_SCANF_2_lli' = __CLIB_OPT_SCANF_2_lli

defc `__CLIB_OPT_FASTCOPY' = __CLIB_OPT_FASTCOPY

defc `__CLIB_OPT_FASTCOPY_MEMCPY' = __CLIB_OPT_FASTCOPY_MEMCPY
defc `__CLIB_OPT_FASTCOPY_MEMSET' = __CLIB_OPT_FASTCOPY_MEMSET
defc `__CLIB_OPT_FASTCOPY_LDIR' = __CLIB_OPT_FASTCOPY_LDIR
defc `__CLIB_OPT_FASTCOPY_LDIR_SMC' = __CLIB_OPT_FASTCOPY_LDIR_SMC
defc `__CLIB_OPT_FASTCOPY_MEMCPY_SMC' = __CLIB_OPT_FASTCOPY_MEMCPY_SMC

defc `__CLIB_OPT_STRTOD' = __CLIB_OPT_STRTOD

defc `__CLIB_OPT_STRTOD_NAN' = __CLIB_OPT_STRTOD_NAN
defc `__CLIB_OPT_STRTOD_INF' = __CLIB_OPT_STRTOD_INF
defc `__CLIB_OPT_STRTOD_HEX' = __CLIB_OPT_STRTOD_HEX

defc `__CLIB_OPT_SORT' = __CLIB_OPT_SORT

defc `__CLIB_OPT_SORT_INSERTION' = __CLIB_OPT_SORT_INSERTION
defc `__CLIB_OPT_SORT_SHELL' = __CLIB_OPT_SORT_SHELL
defc `__CLIB_OPT_SORT_QUICK' = __CLIB_OPT_SORT_QUICK

defc `__CLIB_OPT_SORT_QSORT' = __CLIB_OPT_SORT_QSORT

defc `__CLIB_OPT_SORT_QSORT_PIVOT' = __CLIB_OPT_SORT_QSORT_PIVOT
defc `__CLIB_OPT_SORT_QSORT_PIVOT_MID' = __CLIB_OPT_SORT_QSORT_PIVOT_MID
defc `__CLIB_OPT_SORT_QSORT_PIVOT_RAN' = __CLIB_OPT_SORT_QSORT_PIVOT_RAN
defc `__CLIB_OPT_SORT_QSORT_ENABLE_INSERTION' = __CLIB_OPT_SORT_QSORT_ENABLE_INSERTION
defc `__CLIB_OPT_SORT_QSORT_ENABLE_EQUAL' = __CLIB_OPT_SORT_QSORT_ENABLE_EQUAL

defc `__CLIB_OPT_ERROR' = __CLIB_OPT_ERROR

defc `__CLIB_OPT_ERROR_ENABLED' = __CLIB_OPT_ERROR_ENABLED
defc `__CLIB_OPT_ERROR_VERBOSE' = __CLIB_OPT_ERROR_VERBOSE
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#define' `__CLIB_OPT_MULTITHREAD'  __CLIB_OPT_MULTITHREAD

`#define' `__CLIB_OPT_MULTITHREAD_LOCK_HEAPS'  __CLIB_OPT_MULTITHREAD_LOCK_HEAPS
`#define' `__CLIB_OPT_MULTITHREAD_LOCK_FILES'  __CLIB_OPT_MULTITHREAD_LOCK_FILES
`#define' `__CLIB_OPT_MULTITHREAD_LOCK_FLIST'  __CLIB_OPT_MULTITHREAD_LOCK_FLIST
`#define' `__CLIB_OPT_MULTITHREAD_LOCK_FDTBL'  __CLIB_OPT_MULTITHREAD_LOCK_FDTBL
`#define' `__CLIB_OPT_MULTITHREAD_LOCK_FDSTR'  __CLIB_OPT_MULTITHREAD_LOCK_FDSTR

`#define' `__CLIB_OPT_IMATH'  __CLIB_OPT_IMATH

`#define' `__CLIB_OPT_IMATH_FAST'  __CLIB_OPT_IMATH_FAST

`#define' `__CLIB_OPT_IMATH_FAST_DIV_UNROLL'  __CLIB_OPT_IMATH_FAST_DIV_UNROLL
`#define' `__CLIB_OPT_IMATH_FAST_DIV_LZEROS'  __CLIB_OPT_IMATH_FAST_DIV_LZEROS
`#define' `__CLIB_OPT_IMATH_FAST_MUL_UNROLL'  __CLIB_OPT_IMATH_FAST_MUL_UNROLL
`#define' `__CLIB_OPT_IMATH_FAST_MUL_LZEROS'  __CLIB_OPT_IMATH_FAST_MUL_LZEROS
`#define' `__CLIB_OPT_IMATH_FAST_LIA'  __CLIB_OPT_IMATH_FAST_LIA

`#define' `__CLIB_OPT_IMATH_SELECT'  __CLIB_OPT_IMATH_SELECT

`#define' `__CLIB_OPT_IMATH_SELECT_FAST_ASR'  __CLIB_OPT_IMATH_SELECT_FAST_ASR
`#define' `__CLIB_OPT_IMATH_SELECT_FAST_LSR'  __CLIB_OPT_IMATH_SELECT_FAST_LSR
`#define' `__CLIB_OPT_IMATH_SELECT_FAST_LSL'  __CLIB_OPT_IMATH_SELECT_FAST_LSL

`#define' `__CLIB_OPT_TXT2NUM'  __CLIB_OPT_TXT2NUM

`#define' `__CLIB_OPT_TXT2NUM_INT_BIN'  __CLIB_OPT_TXT2NUM_INT_BIN
`#define' `__CLIB_OPT_TXT2NUM_INT_OCT'  __CLIB_OPT_TXT2NUM_INT_OCT
`#define' `__CLIB_OPT_TXT2NUM_INT_DEC'  __CLIB_OPT_TXT2NUM_INT_DEC
`#define' `__CLIB_OPT_TXT2NUM_INT_HEX'  __CLIB_OPT_TXT2NUM_INT_HEX

`#define' `__CLIB_OPT_TXT2NUM_LONG_BIN'  __CLIB_OPT_TXT2NUM_LONG_BIN
`#define' `__CLIB_OPT_TXT2NUM_LONG_OCT'  __CLIB_OPT_TXT2NUM_LONG_OCT
`#define' `__CLIB_OPT_TXT2NUM_LONG_DEC'  __CLIB_OPT_TXT2NUM_LONG_DEC
`#define' `__CLIB_OPT_TXT2NUM_LONG_HEX'  __CLIB_OPT_TXT2NUM_LONG_HEX

`#define' `__CLIB_OPT_TXT2NUM_SELECT'  __CLIB_OPT_TXT2NUM_SELECT

`#define' `__CLIB_OPT_TXT2NUM_SELECT_FAST_BIN'  __CLIB_OPT_TXT2NUM_SELECT_FAST_BIN
`#define' `__CLIB_OPT_TXT2NUM_SELECT_FAST_OCT'  __CLIB_OPT_TXT2NUM_SELECT_FAST_OCT
`#define' `__CLIB_OPT_TXT2NUM_SELECT_FAST_DEC'  __CLIB_OPT_TXT2NUM_SELECT_FAST_DEC
`#define' `__CLIB_OPT_TXT2NUM_SELECT_FAST_HEX'  __CLIB_OPT_TXT2NUM_SELECT_FAST_HEX

`#define' `__CLIB_OPT_NUM2TXT'  __CLIB_OPT_NUM2TXT

`#define' `__CLIB_OPT_NUM2TXT_INT_BIN'  __CLIB_OPT_NUM2TXT_INT_BIN
`#define' `__CLIB_OPT_NUM2TXT_INT_OCT'  __CLIB_OPT_NUM2TXT_INT_OCT
`#define' `__CLIB_OPT_NUM2TXT_INT_DEC'  __CLIB_OPT_NUM2TXT_INT_DEC
`#define' `__CLIB_OPT_NUM2TXT_INT_HEX'  __CLIB_OPT_NUM2TXT_INT_HEX

`#define' `__CLIB_OPT_NUM2TXT_LONG_BIN'  __CLIB_OPT_NUM2TXT_LONG_BIN
`#define' `__CLIB_OPT_NUM2TXT_LONG_OCT'  __CLIB_OPT_NUM2TXT_LONG_OCT
`#define' `__CLIB_OPT_NUM2TXT_LONG_DEC'  __CLIB_OPT_NUM2TXT_LONG_DEC
`#define' `__CLIB_OPT_NUM2TXT_LONG_HEX'  __CLIB_OPT_NUM2TXT_LONG_HEX

`#define' `__CLIB_OPT_NUM2TXT_SELECT'  __CLIB_OPT_NUM2TXT_SELECT

`#define' `__CLIB_OPT_NUM2TXT_SELECT_FAST_BIN'  __CLIB_OPT_NUM2TXT_SELECT_FAST_BIN
`#define' `__CLIB_OPT_NUM2TXT_SELECT_FAST_OCT'  __CLIB_OPT_NUM2TXT_SELECT_FAST_OCT
`#define' `__CLIB_OPT_NUM2TXT_SELECT_FAST_DEC'  __CLIB_OPT_NUM2TXT_SELECT_FAST_DEC
`#define' `__CLIB_OPT_NUM2TXT_SELECT_FAST_HEX'  __CLIB_OPT_NUM2TXT_SELECT_FAST_HEX

`#define' `__CLIB_OPT_STDIO'  __CLIB_OPT_STDIO

`#define' `__CLIB_OPT_STDIO_VALID'  __CLIB_OPT_STDIO_VALID

`#define' `CHAR_CR'  CHAR_CR
`#define' `CHAR_LF'  CHAR_LF
`#define' `CHAR_BS'  CHAR_BS
`#define' `CHAR_ESC'  CHAR_ESC
`#define' `CHAR_CAPS'  CHAR_CAPS
`#define' `CHAR_BELL'  CHAR_BELL
`#define' `CHAR_CTRL_C'  CHAR_CTRL_C
`#define' `CHAR_CTRL_D'  CHAR_CTRL_D
`#define' `CHAR_CTRL_Z'  CHAR_CTRL_Z
`#define' `CHAR_CURSOR_UC'  CHAR_CURSOR_UC
`#define' `CHAR_CURSOR_LC'  CHAR_CURSOR_LC
`#define' `CHAR_PASSWORD'  CHAR_PASSWORD

`#define' `__CLIB_OPT_PRINTF'  __CLIB_OPT_PRINTF

`#define' `__CLIB_OPT_PRINTF_d'  __CLIB_OPT_PRINTF_d
`#define' `__CLIB_OPT_PRINTF_u'  __CLIB_OPT_PRINTF_u
`#define' `__CLIB_OPT_PRINTF_x'  __CLIB_OPT_PRINTF_x
`#define' `__CLIB_OPT_PRINTF_X'  __CLIB_OPT_PRINTF_X
`#define' `__CLIB_OPT_PRINTF_o'  __CLIB_OPT_PRINTF_o
`#define' `__CLIB_OPT_PRINTF_n'  __CLIB_OPT_PRINTF_n
`#define' `__CLIB_OPT_PRINTF_i'  __CLIB_OPT_PRINTF_i
`#define' `__CLIB_OPT_PRINTF_p'  __CLIB_OPT_PRINTF_p
`#define' `__CLIB_OPT_PRINTF_B'  __CLIB_OPT_PRINTF_B
`#define' `__CLIB_OPT_PRINTF_s'  __CLIB_OPT_PRINTF_s
`#define' `__CLIB_OPT_PRINTF_c'  __CLIB_OPT_PRINTF_c
`#define' `__CLIB_OPT_PRINTF_I'  __CLIB_OPT_PRINTF_I
`#define' `__CLIB_OPT_PRINTF_ld'  __CLIB_OPT_PRINTF_ld
`#define' `__CLIB_OPT_PRINTF_lu'  __CLIB_OPT_PRINTF_lu
`#define' `__CLIB_OPT_PRINTF_lx'  __CLIB_OPT_PRINTF_lx
`#define' `__CLIB_OPT_PRINTF_lX'  __CLIB_OPT_PRINTF_lX
`#define' `__CLIB_OPT_PRINTF_lo'  __CLIB_OPT_PRINTF_lo
`#define' `__CLIB_OPT_PRINTF_ln'  __CLIB_OPT_PRINTF_ln
`#define' `__CLIB_OPT_PRINTF_li'  __CLIB_OPT_PRINTF_li
`#define' `__CLIB_OPT_PRINTF_lp'  __CLIB_OPT_PRINTF_lp
`#define' `__CLIB_OPT_PRINTF_lB'  __CLIB_OPT_PRINTF_lB
`#define' `__CLIB_OPT_PRINTF_a'  __CLIB_OPT_PRINTF_a
`#define' `__CLIB_OPT_PRINTF_A'  __CLIB_OPT_PRINTF_A
`#define' `__CLIB_OPT_PRINTF_e'  __CLIB_OPT_PRINTF_e
`#define' `__CLIB_OPT_PRINTF_E'  __CLIB_OPT_PRINTF_E
`#define' `__CLIB_OPT_PRINTF_f'  __CLIB_OPT_PRINTF_f
`#define' `__CLIB_OPT_PRINTF_F'  __CLIB_OPT_PRINTF_F
`#define' `__CLIB_OPT_PRINTF_g'  __CLIB_OPT_PRINTF_g
`#define' `__CLIB_OPT_PRINTF_G'  __CLIB_OPT_PRINTF_G

`#define' `__CLIB_OPT_PRINTF_2'  __CLIB_OPT_PRINTF_2

`#define' `__CLIB_OPT_PRINTF_2_lld'  __CLIB_OPT_PRINTF_2_lld
`#define' `__CLIB_OPT_PRINTF_2_llu'  __CLIB_OPT_PRINTF_2_llu
`#define' `__CLIB_OPT_PRINTF_2_llx'  __CLIB_OPT_PRINTF_2_llx
`#define' `__CLIB_OPT_PRINTF_2_llX'  __CLIB_OPT_PRINTF_2_llX
`#define' `__CLIB_OPT_PRINTF_2_llo'  __CLIB_OPT_PRINTF_2_llo
`#define' `__CLIB_OPT_PRINTF_2_lli'  __CLIB_OPT_PRINTF_2_lli

`#define' `__CLIB_OPT_SCANF'  __CLIB_OPT_SCANF

`#define' `__CLIB_OPT_SCANF_d'  __CLIB_OPT_SCANF_d
`#define' `__CLIB_OPT_SCANF_u'  __CLIB_OPT_SCANF_u
`#define' `__CLIB_OPT_SCANF_x'  __CLIB_OPT_SCANF_x
`#define' `__CLIB_OPT_SCANF_X'  __CLIB_OPT_SCANF_X
`#define' `__CLIB_OPT_SCANF_o'  __CLIB_OPT_SCANF_o
`#define' `__CLIB_OPT_SCANF_n'  __CLIB_OPT_SCANF_n
`#define' `__CLIB_OPT_SCANF_i'  __CLIB_OPT_SCANF_i
`#define' `__CLIB_OPT_SCANF_p'  __CLIB_OPT_SCANF_p
`#define' `__CLIB_OPT_SCANF_B'  __CLIB_OPT_SCANF_B
`#define' `__CLIB_OPT_SCANF_s'  __CLIB_OPT_SCANF_s
`#define' `__CLIB_OPT_SCANF_c'  __CLIB_OPT_SCANF_c
`#define' `__CLIB_OPT_SCANF_I'  __CLIB_OPT_SCANF_I
`#define' `__CLIB_OPT_SCANF_ld'  __CLIB_OPT_SCANF_ld
`#define' `__CLIB_OPT_SCANF_lu'  __CLIB_OPT_SCANF_lu
`#define' `__CLIB_OPT_SCANF_lx'  __CLIB_OPT_SCANF_lx
`#define' `__CLIB_OPT_SCANF_lX'  __CLIB_OPT_SCANF_lX
`#define' `__CLIB_OPT_SCANF_lo'  __CLIB_OPT_SCANF_lo
`#define' `__CLIB_OPT_SCANF_ln'  __CLIB_OPT_SCANF_ln
`#define' `__CLIB_OPT_SCANF_li'  __CLIB_OPT_SCANF_li
`#define' `__CLIB_OPT_SCANF_lp'  __CLIB_OPT_SCANF_lp
`#define' `__CLIB_OPT_SCANF_lB'  __CLIB_OPT_SCANF_lB
`#define' `__CLIB_OPT_SCANF_BRACKET'  __CLIB_OPT_SCANF_BRACKET
`#define' `__CLIB_OPT_SCANF_a'  __CLIB_OPT_SCANF_a
`#define' `__CLIB_OPT_SCANF_A'  __CLIB_OPT_SCANF_A
`#define' `__CLIB_OPT_SCANF_e'  __CLIB_OPT_SCANF_e
`#define' `__CLIB_OPT_SCANF_E'  __CLIB_OPT_SCANF_E
`#define' `__CLIB_OPT_SCANF_f'  __CLIB_OPT_SCANF_f
`#define' `__CLIB_OPT_SCANF_F'  __CLIB_OPT_SCANF_F
`#define' `__CLIB_OPT_SCANF_g'  __CLIB_OPT_SCANF_g
`#define' `__CLIB_OPT_SCANF_G'  __CLIB_OPT_SCANF_G

`#define' `__CLIB_OPT_SCANF_2'  __CLIB_OPT_SCANF_2

`#define' `__CLIB_OPT_SCANF_2_lld'  __CLIB_OPT_SCANF_2_lld
`#define' `__CLIB_OPT_SCANF_2_llu'  __CLIB_OPT_SCANF_2_llu
`#define' `__CLIB_OPT_SCANF_2_llx'  __CLIB_OPT_SCANF_2_llx
`#define' `__CLIB_OPT_SCANF_2_llX'  __CLIB_OPT_SCANF_2_llX
`#define' `__CLIB_OPT_SCANF_2_llo'  __CLIB_OPT_SCANF_2_llo
`#define' `__CLIB_OPT_SCANF_2_lli'  __CLIB_OPT_SCANF_2_lli

`#define' `__CLIB_OPT_FASTCOPY'  __CLIB_OPT_FASTCOPY

`#define' `__CLIB_OPT_FASTCOPY_MEMCPY'  __CLIB_OPT_FASTCOPY_MEMCPY
`#define' `__CLIB_OPT_FASTCOPY_MEMSET'  __CLIB_OPT_FASTCOPY_MEMSET
`#define' `__CLIB_OPT_FASTCOPY_LDIR'  __CLIB_OPT_FASTCOPY_LDIR
`#define' `__CLIB_OPT_FASTCOPY_LDIR_SMC'  __CLIB_OPT_FASTCOPY_LDIR_SMC
`#define' `__CLIB_OPT_FASTCOPY_MEMCPY_SMC'  __CLIB_OPT_FASTCOPY_MEMCPY_SMC

`#define' `__CLIB_OPT_STRTOD'  __CLIB_OPT_STRTOD

`#define' `__CLIB_OPT_STRTOD_NAN'  __CLIB_OPT_STRTOD_NAN
`#define' `__CLIB_OPT_STRTOD_INF'  __CLIB_OPT_STRTOD_INF
`#define' `__CLIB_OPT_STRTOD_HEX'  __CLIB_OPT_STRTOD_HEX

`#define' `__CLIB_OPT_SORT'  __CLIB_OPT_SORT

`#define' `__CLIB_OPT_SORT_INSERTION'  __CLIB_OPT_SORT_INSERTION
`#define' `__CLIB_OPT_SORT_SHELL'  __CLIB_OPT_SORT_SHELL
`#define' `__CLIB_OPT_SORT_QUICK'  __CLIB_OPT_SORT_QUICK

`#define' `__CLIB_OPT_SORT_QSORT'  __CLIB_OPT_SORT_QSORT

`#define' `__CLIB_OPT_SORT_QSORT_PIVOT'  __CLIB_OPT_SORT_QSORT_PIVOT
`#define' `__CLIB_OPT_SORT_QSORT_PIVOT_MID'  __CLIB_OPT_SORT_QSORT_PIVOT_MID
`#define' `__CLIB_OPT_SORT_QSORT_PIVOT_RAN'  __CLIB_OPT_SORT_QSORT_PIVOT_RAN
`#define' `__CLIB_OPT_SORT_QSORT_ENABLE_INSERTION'  __CLIB_OPT_SORT_QSORT_ENABLE_INSERTION
`#define' `__CLIB_OPT_SORT_QSORT_ENABLE_EQUAL'  __CLIB_OPT_SORT_QSORT_ENABLE_EQUAL

`#define' `__CLIB_OPT_ERROR'  __CLIB_OPT_ERROR

`#define' `__CLIB_OPT_ERROR_ENABLED'  __CLIB_OPT_ERROR_ENABLED
`#define' `__CLIB_OPT_ERROR_VERBOSE'  __CLIB_OPT_ERROR_VERBOSE
')
