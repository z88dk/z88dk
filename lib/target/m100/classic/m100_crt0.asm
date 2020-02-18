;
;	Startup for m100
;   Stefano, 2020
;
;   "appmake +trs80 --co" will prepare a valid binary file, to be invoked from within BASIC:
;        CLEAR 0,39999: RUNM"A.CO"
;



	module m100_crt0


;--------
; Include zcc_opt.def to find out some info
;--------

        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        EXTERN    _main           ;main() is always external to crt0 code
        ;EXTERN    asm_im1_handler

        PUBLIC    cleanup         ;jp'd to by exit()
        PUBLIC    l_dcal          ;jp(hl)

        IF !CLIB_FGETC_CONS_DELAY
                defc CLIB_FGETC_CONS_DELAY = 150
        ENDIF

        defc    TAR__clib_exit_stack_size = 4
	defc    TAR__fputc_cons_generic = 1
        defc    TAR__register_sp = -1 
	defc	CRT_KEY_DEL = 12
	defc	__CPU_CLOCK = 2048000

	defc	CONSOLE_COLUMNS = 80
	defc	CONSOLE_ROWS = 8

        INCLUDE "crt/classic/crt_rules.inc"

        IF      !DEFINED_CRT_ORG_CODE
                    defc  CRT_ORG_CODE  = 40000
        ENDIF

	org	  CRT_ORG_CODE



program:

        INCLUDE "crt/classic/crt_init_sp.asm"
        INCLUDE "crt/classic/crt_init_atexit.asm"
	call    crt0_init_bss
	ld	hl,0
	add	hl,sp
	ld	(exitsp),hl

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
	defc	CRT_MAX_HEAP_ADDRESS = $F500
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF

	push	bc	;argv
	push	bc	;argc
	call	_main
	pop	bc
	pop	bc
cleanup:
	push	hl
	call	crt0_exit
	pop	hl

	ret



l_dcal: jp      (hl)            ;Used for function pointer calls



	INCLUDE "crt/classic/crt_runtime_selection.asm" 
	
	INCLUDE	"crt/classic/crt_section.asm"

