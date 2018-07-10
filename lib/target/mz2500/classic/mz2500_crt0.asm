;
;	CRT0 for the Sharp MZ-2500
;
;    $Id: mz2500_crt0.asm $
;

	MODULE mz2500_crt0

;
; Initially include the zcc_opt.def file to find out lots of lovely
; information about what we should do..
;

        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        EXTERN    _main
        EXTERN    _mz2500_printf

        PUBLIC    cleanup 
        PUBLIC    l_dcal


;--------
; ORG at 0x8000, to leave space for video memory
;--------
		defc    CRT_ORG_CODE  = 32768
       	defc    TAR__register_sp = -1

        ;defc    CONSOLE_COLUMNS = 80
		defc    CONSOLE_COLUMNS = 40
        defc    CONSOLE_ROWS = 25

	defc	TAR__no_ansifont = 1
        defc    TAR__clib_exit_stack_size = 32
	defc	__CPU_CLOCK = 6000000
        INCLUDE "crt/classic/crt_rules.inc"

        org     CRT_ORG_CODE


;--------
; Execution starts here
;--------
start:
	DI

	XOR	A
	OUT	(0B4h), A
	OUT	(0B5h), A
	
	xor a
	rst 18h
	defb 70h	; clear text

 
	INCLUDE	"crt/classic/crt_init_sp.asm"
	
;	im 2
;	ei


	INCLUDE	"crt/classic/crt_init_atexit.asm"
	call	crt0_init_bss

; INIT math identify platform

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
	ld	hl,0
	add	hl,sp
	INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF

        call    _main

cleanup:

IF CRT_ENABLE_STDIO = 1
        EXTERN     closeall
        call    closeall
ENDIF

	push    hl				; return code

	rst	0

cleanup_exit:
	ret


;IF (!DEFINED_startup | (startup=1))
;
;        defs    56-cleanup_exit-1
;
;if (ASMPC<>$0038)
;        defs    CODE_ALIGNMENT_ERROR
;endif
;
;ENDIF



l_dcal:
        jp      (hl)


	IF !DEFINED_ansicolumns
		 defc DEFINED_ansicolumns = 1
		 defc ansicolumns = 40
	ENDIF

        INCLUDE "crt/classic/crt_runtime_selection.asm"

	INCLUDE	"crt/classic/crt_section.asm"


	SECTION	code_crt_init
	ld	hl,TAR__register_sp
	ld	(exitsp),hl


