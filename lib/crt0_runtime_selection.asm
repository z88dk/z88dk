;
; Allow selection of the library functions at linktime
;
; Included by crt0 files
;



; scanf format picker

IF DEFINED_floatscanf
	PUBLIC	scanf_handle_f
	EXTERN	__scanf_handle_f
	defc	scanf_handle_f = __scanf_handle_f
ELSE
	PUBLIC	scanf_handle_f
	EXTERN	__scanf_handle_f
	EXTERN  __scanf_noop
	defc	scanf_handle_f = __scanf_noop
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
                EXTERN  asm_vfprintf_level1
                defc    asm_vfprintf = asm_vfprintf_level1
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

