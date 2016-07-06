;
; Allow selection of the library functions at linktime
;
; Included by crt0 files
;


; scanf format picker

; Compatibility with the new library format picker. The classic library
; implements several of these together so there's an element of grouping.
;
; Default is to enable all converters except for float. 
;
; Use -pragma-define:CLIB_OPT_SCANF=0x..... to control formatters
;
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
; * bit 11 = $   800 = enable %I
; bit 12 = $  1000 = enable %ld
; bit 13 = $  2000 = enable %lu
; bit 14 = $  4000 = enable %lx
; bit 15 = $  8000 = enable %lx (duplicate)
; bit 16 = $ 10000 = enable %lo
; bit 17 = $ 20000 = enable %ln
; bit 18 = $ 40000 = enable %li
; bit 19 = $ 80000 = enable %lp
; bit 20 = $100000 = enable %lB
; * bit 21 = $200000 = enable %[
; * bit 22 = $  400000 = enable %a
; * bit 23 = $  800000 = enable %A
; bit 24 = $ 1000000 = enable %e
; bit 25 = $ 2000000 = enable %E
; bit 26 = $ 4000000 = enable %f
; bit 27 = $ 8000000 = enable %F
; bit 28 = $10000000 = enable %g
; bit 29 = $20000000 = enable %G

IF DEFINED_CLIB_OPT_SCANF
	; User has specified the configuration level - force scanf to be included
	UNDEFINE NEED_scanf
	DEFINE NEED_scanf
ELSE
	IF DEFINED_scanf_format
	    ;Only defined as part of sccz80
	    defc CLIB_OPT_SCANF = scanf_format
        ELSE
	    ; TODO: Some default configurations
        ENDIF
ENDIF


IF NEED_scanf
	PUBLIC	__scanf_format_table
	EXTERN	__scanf_handle_d
	EXTERN	__scanf_handle_u
	EXTERN	__scanf_handle_o
	EXTERN	__scanf_handle_x
	EXTERN	__scanf_handle_p
	EXTERN	__scanf_handle_B
	EXTERN	__scanf_handle_f
	EXTERN	__scanf_handle_s
	EXTERN	__scanf_handle_c
	EXTERN	__scanf_handle_n
	EXTERN	__scanf_handle_i
	EXTERN	__scanf_noop

__scanf_format_table:
IF CLIB_OPT_SCANF & $40040
	defb	'i'
	defw	__scanf_handle_i
	defc	temp_CLIB_OPT_SCANF = CLIB_OPT_SCANF
	UNDEFINE CLIB_OPT_SCANF
	defc	CLIB_OPT_SCANF = temp_CLIB_OPT_SCANF | 0x3003 | 0x8c08c | 0x10010 | 0x100100
ENDIF



IF CLIB_OPT_SCANF & $1001
	defb	'u'
	defw	__scanf_handle_u
ENDIF

IF CLIB_OPT_SCANF & $2002
	defb	'd'
	defw	__scanf_handle_d
ENDIF

IF CLIB_OPT_SCANF & $c00c
	defb	'x'
	defw	__scanf_handle_x
ENDIF

IF CLIB_OPT_SCANF & $80080
	defb	'p'
	defw	__scanf_handle_x
ENDIF

IF CLIB_OPT_SCANF & $10010
	defb	'o'
	defw	__scanf_handle_o
ENDIF

IF CLIB_OPT_SCANF & $100100
	defb	'B'
	defw	__scanf_handle_B
ENDIF

IF CLIB_OPT_SCANF & $20020
	defb	'n'
	defw	__scanf_handle_n
ENDIF

IF CLIB_OPT_SCANF & $200
	defb	's'
	defw	__scanf_handle_s
ENDIF

IF CLIB_OPT_SCANF & $400
	defb	'c'
	defw	__scanf_handle_c
ENDIF

IF CLIB_OPT_SCANF & $4000000
	defb	'f'
	defw	__scanf_handle_f
ENDIF

IF CLIB_OPT_SCANF & $1000000
	defb	'e'
	defw	__scanf_handle_f
ENDIF
IF CLIB_OPT_SCANF & $10000000
	defb	'g'
	defw	__scanf_handle_f
ENDIF

	defb	0	;end marker
ENDIF

;--------
; Printf picker - this is classic based at present
;
;--------
        PUBLIC  asm_vfprintf
IF DEFINED_floatstdio
        EXTERN  asm_vfprintf_level3
        defc    asm_vfprintf = asm_vfprintf_level3
ELSE
        IF DEFINED_complexstdio
                EXTERN  asm_vfprintf_level2
                defc    asm_vfprintf = asm_vfprintf_level2
        ELSE
		IF DEFINED_ministdio
                	EXTERN  asm_vfprintf_level1
                	defc    asm_vfprintf = asm_vfprintf_level1
		ENDIF
        ENDIF
ENDIF

;--------
; Allow a compile time switch between native output and ANSI terminal
;
; -pragma-need=ansiterminal
;--------

IF NEED_ansiterminal
	PUBLIC		fputc_cons
	PUBLIC		puts_cons
	PUBLIC		_fputc_cons
	PUBLIC		_puts_cons
	EXTERN		fputc_cons_ansi
	EXTERN		puts_cons_ansi
	defc DEFINED_fputc_cons = 1
	defc DEFINED_puts_cons = 1
	defc fputc_cons = fputc_cons_ansi
	defc puts_cons = puts_cons_ansi
	defc _fputc_cons = fputc_cons_ansi
	defc _puts_cons = puts_cons_ansi

        PUBLIC ansicolumns
        PUBLIC ansicharacter_pixelwidth
        PUBLIC ansifont
        PUBLIC ansifont_is_packed

        IF !DEFINED_ansicolumns
             defc ansicolumns = 64
        ENDIF

	IF (ansicolumns = 128)
	    defc ansicharacter_pixelwidth = 2
            IF !DEFINED_ansifont
            	EXTERN ansifont_f4pack
	    	defc ansifont = ansifont_f4pack
            	defc ansifont_is_packed = 1
            ENDIF
	ENDIF
	IF (ansicolumns = 85)
	    defc ansicharacter_pixelwidth = 3
            IF !DEFINED_ansifont
                EXTERN ansifont_f4pack
	        defc ansifont = ansifont_f4pack
                defc ansifont_is_packed = 1
	    ENDIF
	ENDIF
	IF (ansicolumns = 80)
	    defc ansicharacter_pixelwidth = 3
            IF !DEFINED_ansifont
                EXTERN ansifont_f4pack
	        defc ansifont = ansifont_f4pack
                defc ansifont_is_packed = 1
	    ENDIF
	ENDIF
	IF (ansicolumns = 64)
	    defc ansicharacter_pixelwidth = 4
            IF !DEFINED_ansifont
                EXTERN ansifont_f4pack
	        defc ansifont = ansifont_f4pack
                defc ansifont_is_packed = 1
	    ENDIF
	ENDIF
	IF (ansicolumns = 51)
	    defc ansicharacter_pixelwidth = 5
            IF !DEFINED_ansifont
                EXTERN ansifont_f5
	        defc ansifont = ansifont_f4
                defc ansifont_is_packed = 0
	    ENDIF
	ENDIF
	IF (ansicolumns = 42)
	    defc ansicharacter_pixelwidth = 6
            IF !DEFINED_ansifont
                EXTERN ansifont_f6
	        defc ansifont = ansifont_f6
                defc ansifont_is_packed = 0
	    ENDIF
	ENDIF
	IF (ansicolumns = 40)
	    defc ansicharacter_pixelwidth = 6
            IF !DEFINED_ansifont
                EXTERN ansifont_f6
	        defc ansifont = ansifont_f6
                defc ansifont_is_packed = 0
	    ENDIF
	ENDIF
	IF (ansicolumns = 36)
	    defc ansicharacter_pixelwidth = 7
            IF !DEFINED_ansifont
                EXTERN ansifont_f8
	        defc ansifont = ansifont_f8
                defc ansifont_is_packed = 0
	    ENDIF
	ENDIF
	IF (ansicolumns = 32)
	    defc ansicharacter_pixelwidth = 8
            IF !DEFINED_ansifont
                EXTERN ansifont_f8
	        defc ansifont = ansifont_f8
                defc ansifont_is_packed = 0
	    ENDIF
	ENDIF
	IF (ansicolumns = 28)
	    defc ansicharacter_pixelwidth = 8
            IF !DEFINED_ansifont
                EXTERN ansifont_f8
	        defc ansifont = ansifont_f8
                defc ansifont_is_packed = 0
	    ENDIF
	ENDIF
	IF (ansicolumns = 24)
	    defc ansicharacter_pixelwidth = 9
            IF !DEFINED_ansifont
                EXTERN ansifont_f8
	        defc ansifont = ansifont_f8
                defc ansifont_is_packed = 0
	    ENDIF
	ENDIF
		

ENDIF

; If it's not been overridden by anybody, lets use the native output
IF !DEFINED_fputc_cons
	PUBLIC		fputc_cons
	PUBLIC		_fputc_cons
	EXTERN		fputc_cons_native
	defc DEFINED_fputc_cons = 1
	defc fputc_cons = fputc_cons_native
	defc _fputc_cons = fputc_cons_native
ENDIF

; And the fallback puts_cons implementation
IF !DEFINED_puts_cons
	PUBLIC		puts_cons
	PUBLIC		_puts_cons
	EXTERN		puts_cons_native
	defc DEFINED_puts_cons = 1
	defc puts_cons = puts_cons_native
	defc _puts_cons = puts_cons_native
ENDIF

