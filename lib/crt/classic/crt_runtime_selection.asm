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
; bit 3 =  $    08 = enable %X (duplicate)
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
; bit 15 = $  8000 = enable %lX (duplicate)
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
; bit 30 = $40000000 = enable flags handling

IF DEFINED_CLIB_OPT_SCANF
	; User has specified the configuration level - force scanf to be included
	UNDEFINE NEED_scanf
	DEFINE NEED_scanf
ELSE
	IF DEFINED_CRT_scanf_format
	    ;Only defined as part of sccz80
	    defc CLIB_OPT_SCANF = CRT_scanf_format
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



IF CLIB_OPT_SCANF & $2002
	defb	'u'
	defw	__scanf_handle_u
ENDIF

IF CLIB_OPT_SCANF & $1001
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

;
; printf format picker
;


IF DEFINED_CLIB_OPT_PRINTF
	; User has specified the configuration level - force printf to be included
	UNDEFINE NEED_printf
	DEFINE NEED_printf
ELSE
	IF DEFINED_CRT_printf_format
	    ;Only defined as part of sccz80
	    defc CLIB_OPT_PRINTF = CRT_printf_format
        ELSE
	    ; Default configurations to match old behaviour
	    ; The built in one is roughly the old ministdio
	    IF DEFINED_complexstdio
                defc CLIB_OPT_PRINTF = 0x851BF7BF
            ELSE
	        defc CLIB_OPT_PRINTF = 0x801BF7BF
            ENDIF
        ENDIF
ENDIF

IF DEFINED_CLIB_OPT_PRINTF_2
	; User has specified the configuration level - force printf to be included
	UNDEFINE NEED_printf
	DEFINE NEED_printf
ENDIF

IF NEED_printf
	PUBLIC	__printf_format_table
	PUBLIC  __printf_format_table64
	EXTERN	__printf_handle_d
	EXTERN	__printf_handle_u
	EXTERN	__printf_handle_o
	EXTERN	__printf_handle_x
	EXTERN	__printf_handle_X
	EXTERN	__printf_handle_p
	EXTERN	__printf_handle_e
	EXTERN	__printf_handle_f
	EXTERN	__printf_handle_s
	EXTERN	__printf_handle_c
	EXTERN	__printf_handle_n
	EXTERN	__printf_handle_B
	EXTERN	__printf_handle_ll
	EXTERN	__printf_handle_lld
	EXTERN	__printf_handle_llu
	EXTERN	__printf_handle_llo
	EXTERN	__printf_handle_llx
	EXTERN	__printf_handle_llX
	EXTERN	__printf_handle_llB

__printf_format_table:

IF CLIB_OPT_PRINTF & $2002
	defb	'u'
	defw	__printf_handle_u
ENDIF

IF CLIB_OPT_PRINTF & $1001
	defb	'd'
	defw	__printf_handle_d
ENDIF

IF CLIB_OPT_PRINTF & $4004
	defb	'x'
	defw	__printf_handle_x
ENDIF

IF CLIB_OPT_PRINTF & $8008
	defb	'X'
	defw	__printf_handle_X
ENDIF

IF CLIB_OPT_PRINTF & $80080
	defb	'p'
	defw	__printf_handle_x
ENDIF

IF CLIB_OPT_PRINTF & $100100
	defb	'B'
	defw	__printf_handle_B
ENDIF

IF CLIB_OPT_PRINTF  & $10010
	defb	'o'
	defw	__printf_handle_o
ENDIF

IF CLIB_OPT_PRINTF & $20020
	defb	'n'
	defw	__printf_handle_n
ENDIF

IF CLIB_OPT_PRINTF & $200
	defb	's'
	defw	__printf_handle_s
ENDIF

IF CLIB_OPT_PRINTF & $400
	defb	'c'
	defw	__printf_handle_c
ENDIF

IF CLIB_OPT_PRINTF & $4000000
	defb	'f'
	defw	__printf_handle_f
ENDIF

IF CLIB_OPT_PRINTF  & $1000000
	defb	'e'
	defw	__printf_handle_e
ENDIF
IF CLIB_OPT_PRINTF & $10000000
	defb	'g'
	defw	__printf_handle_f
ENDIF
IF CLIB_OPT_PRINTF_2
	defb	'l'
	defw	__printf_handle_ll
ENDIF
	defb	0	;end marker

__printf_format_table64:

IF CLIB_OPT_PRINTF_2 & $02
	defb	'u'
	defw	__printf_handle_llu
ENDIF

IF CLIB_OPT_PRINTF_2 & $01
	defb	'd'
	defw	__printf_handle_lld
ENDIF

IF CLIB_OPT_PRINTF_2 & $04
	defb	'x'
	defw	__printf_handle_llx
ENDIF

IF CLIB_OPT_PRINTF_2 & $08
	defb	'X'
	defw	__printf_handle_llX
ENDIF
IF CLIB_OPT_PRINTF_2  & $10
	defb	'o'
	defw	__printf_handle_llo
ENDIF
IF CLIB_OPT_PRINTF_2 & $100
	defb	'B'
	defw	__printf_handle_llB
ENDIF
	defb	0	;endmarker



IF CLIB_OPT_PRINTF & $40000000
	EXTERN	__printf_get_flags_impl
	PUBLIC	__printf_get_flags
	defc	__printf_get_flags = __printf_get_flags_impl
ELSE
	EXTERN	__printf_get_flags_noop
	PUBLIC	__printf_get_flags
	defc	__printf_get_flags = __printf_get_flags_noop
ENDIF

ENDIF


;--------
; Allow a compile time switch between native output and ANSI terminal
;
; -pragma-need=ansiterminal
;--------

IF NEED_ansiterminal
	PUBLIC		fputc_cons
	EXTERN		fputc_cons_ansi
	EXTERN		puts_cons_ansi
	defc DEFINED_fputc_cons = 1
	defc DEFINED_puts_cons = 1
	defc fputc_cons = fputc_cons_ansi

	; Bridge VT100 to gencon
        IF DEFINED_CLIB_ANSITERMINAL_BRIDGE & CLIB_ANSITERMINAL_BRIDGE != 0
            PUBLIC ansi_attr
            PUBLIC ansi_BEL
            PUBLIC ansi_cls
            PUBLIC ansi_CHAR
            PUBLIC ansi_del_line
            PUBLIC ansi_SCROLLUP
            EXTERN __gencon_ansi_attr
            EXTERN __gencon_ansi_BEL
            EXTERN __gencon_ansi_cls
            EXTERN __gencon_ansi_CHAR
            EXTERN __gencon_ansi_del_line
            EXTERN __gencon_ansi_SCROLLUP
            defc ansi_attr = __gencon_ansi_attr
            defc ansi_BEL = __gencon_ansi_BEL
            defc ansi_cls = __gencon_ansi_cls
            defc ansi_CHAR = __gencon_ansi_CHAR
            defc ansi_del_line = __gencon_ansi_del_line
            defc ansi_SCROLLUP = __gencon_ansi_SCROLLUP

            ; We're using gencon, don't include an ANSIfont
            UNDEFINE TAR__no_ansifont
            defc TAR__no_ansifont = 1
	    IF !DEFINED_ansicolumns
                defc ansicolumns = CONSOLE_COLUMNS
                defc DEFINED_ansicolumns = 1
            ENDIF
        ENDIF

       	PUBLIC ansicolumns

	IF !TAR__no_ansifont
        	PUBLIC ansicharacter_pixelwidth
		PUBLIC ansifont
        	PUBLIC ansifont_is_packed
        ELSE
                defc DEFINED_ansifont = 1
	ENDIF

	IF !ansipixels
		defc ansipixels = 256
	ENDIF

	IF !DEFINED_ansicolumns
		 defc ansicolumns = 64
	ENDIF

	UNDEFINE CONSOLE_COLUMNS
	defc CONSOLE_COLUMNS = ansicolumns

	IF DEFINED_ansirows
		UNDEFINE CONSOLE_ROWS
		defc CONSOLE_ROWS = ansirows
	ENDIF


	IF (ansicolumns = (ansipixels/2))
	    defc ansicharacter_pixelwidth = 2
            IF !DEFINED_ansifont
            	EXTERN ansifont_f4pack
	    	defc ansifont = ansifont_f4pack
            	defc ansifont_is_packed = 1
            ENDIF
	ENDIF
	IF (ansicolumns = (ansipixels/3))
	    defc ansicharacter_pixelwidth = 3
            IF !DEFINED_ansifont
                EXTERN ansifont_f4pack
	        defc ansifont = ansifont_f4pack
                defc ansifont_is_packed = 1
	    ENDIF
	ENDIF
	IF (ansicolumns = (ansipixels/4))
	    defc ansicharacter_pixelwidth = 4
            IF !DEFINED_ansifont
                EXTERN ansifont_f4pack
	        defc ansifont = ansifont_f4pack
                defc ansifont_is_packed = 1
	    ENDIF
	ENDIF
	IF (ansicolumns = (ansipixels/5))
	    defc ansicharacter_pixelwidth = 5
            IF !DEFINED_ansifont
                EXTERN ansifont_f5
	        defc ansifont = ansifont_f5
                defc ansifont_is_packed = 0
	    ENDIF
	ENDIF
	IF (ansicolumns = (ansipixels/6))
	    defc ansicharacter_pixelwidth = 6
            IF !DEFINED_ansifont
                EXTERN ansifont_f6
	        defc ansifont = ansifont_f6
                defc ansifont_is_packed = 0
	    ENDIF
	ENDIF
	IF (ansicolumns = (ansipixels/7))
	    defc ansicharacter_pixelwidth = 7
            IF !DEFINED_ansifont
                EXTERN ansifont_f8
	        defc ansifont = ansifont_f8
                defc ansifont_is_packed = 0
	    ENDIF
	ENDIF
	IF (ansicolumns = (ansipixels/8))
	    defc ansicharacter_pixelwidth = 8
            IF !DEFINED_ansifont
                EXTERN ansifont_f8
	        defc ansifont = ansifont_f8
                defc ansifont_is_packed = 0
	    ENDIF
	ENDIF
	IF (ansicolumns = (ansipixels/9))
	    defc ansicharacter_pixelwidth = 9
            IF !DEFINED_ansifont
                EXTERN ansifont_f8
	        defc ansifont = ansifont_f8
                defc ansifont_is_packed = 0
	    ENDIF
	ENDIF

	IF (ansipixels = 512)	
		IF (ansicolumns = 48)
			defc ansicharacter_pixelwidth = 9
			IF !DEFINED_ansifont
				EXTERN ansifont_f8
				defc ansifont = ansifont_f8
				defc ansifont_is_packed = 0
			ENDIF
		ENDIF
		IF (ansicolumns = 80)
			defc ansicharacter_pixelwidth = 6
			IF !DEFINED_ansifont
				EXTERN ansifont_f6
				defc ansifont = ansifont_f6
				defc ansifont_is_packed = 0
			ENDIF
		ENDIF
		IF (ansicolumns = 160)
			defc ansicharacter_pixelwidth = 3
			IF !DEFINED_ansifont
				EXTERN ansifont_f4pack
				defc ansifont = ansifont_f4pack
				defc ansifont_is_packed = 1
			ENDIF
		ENDIF	
	ENDIF
	
	IF (ansipixels = 256)	
		IF (ansicolumns = 24)
			defc ansicharacter_pixelwidth = 9
			IF !DEFINED_ansifont
				EXTERN ansifont_f8
				defc ansifont = ansifont_f8
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
		IF (ansicolumns = 80)
			defc ansicharacter_pixelwidth = 3
			IF !DEFINED_ansifont
				EXTERN ansifont_f4pack
				defc ansifont = ansifont_f4pack
				defc ansifont_is_packed = 1
			ENDIF
		ENDIF	
	ENDIF

ENDIF

; If it's not been overridden by anybody, lets use the native output
IF !DEFINED_fputc_cons
	PUBLIC		fputc_cons
	defc DEFINED_fputc_cons = 1
        IF !TAR__fputc_cons_generic
	     EXTERN	fputc_cons_native
  	     defc fputc_cons = fputc_cons_native
        ELSE
	     EXTERN	fputc_cons_generic
  	     defc fputc_cons = fputc_cons_generic
        ENDIF
ENDIF

IF DEFINED_fputc_cons
	PUBLIC		_fputc_cons
	defc		_fputc_cons = fputc_cons

ENDIF

IF !DEFINED_getk
   IF !DEFINED_fgetc_cons
      IF TAR__fgetc_cons_inkey
          EXTERN fgetc_cons_inkey
          EXTERN getk_inkey
          PUBLIC fgetc_cons
          PUBLIC _fgetc_cons
          PUBLIC getk
          PUBLIC _getk
          defc fgetc_cons = fgetc_cons_inkey
          defc _fgetc_cons = fgetc_cons_inkey
          defc getk = getk_inkey
          defc _getk = getk_inkey
      ENDIF
   ENDIF
ENDIF

IF DEFINED_fgetc_cons
  IF !DEFINED__fgetc_cons
      PUBLIC _fgetc_cons
      defc _fgetc_cons = fgetc_cons
  ENDIF
ENDIF

IF DEFINED_getk
  IF !DEFINED__getk
      PUBLIC _getk
      defc _getk = getk
  ENDIF
ENDIF


;TODO: These need to go into rules
IF CONSOLE_COLUMNS
	PUBLIC CONSOLE_COLUMNS
ENDIF
IF CONSOLE_ROWS
	PUBLIC CONSOLE_ROWS
ENDIF

IF !CONSOLE_XOFFSET
    defc CONSOLE_XOFFSET = 0
ENDIF
PUBLIC CONSOLE_XOFFSET
IF !CONSOLE_YOFFSET
    defc CONSOLE_YOFFSET = 0
ENDIF
PUBLIC CONSOLE_YOFFSET

IF !CLIB_KBHIT_NOSTORE
    defc CLIB_KBHIT_NOSTORE = 0
ENDIF
PUBLIC CLIB_KBHIT_NOSTORE


