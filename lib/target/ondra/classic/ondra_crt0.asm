;
;	Startup for Ondra
;

	module ondra_crt0


;--------
; Include zcc_opt.def to find out some info
;--------

        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        EXTERN    _main           ;main() is always external to crt0 code

        PUBLIC    cleanup         ;jp'd to by exit()
        PUBLIC    l_dcal          ;jp(hl)
	EXTERN  __BSS_END_tail


        IFNDEF CLIB_FGETC_CONS_DELAY
                defc CLIB_FGETC_CONS_DELAY = 150
        ENDIF

        defc    CONSOLE_ROWS = 32
        defc    CONSOLE_COLUMNS = 40
        defc    TAR__clib_exit_stack_size = 32
        defc    TAR__register_sp = 0xbfff
	defc	CRT_KEY_DEL = 127
	defc	__CPU_CLOCK = 2000000
        INCLUDE "crt/classic/crt_rules.inc"


IF      !DEFINED_CRT_ORG_CODE
        defc CRT_ORG_CODE = 0x4000
ENDIF

	org	  CRT_ORG_CODE - 5

	defb      0x01		;data block
	defw      CRT_ORG_CODE  ;starting address
        defw      +((__BSS_END_tail - CRT_ORG_CODE - 3))

program:
        INCLUDE "crt/classic/crt_init_sp.asm"
        INCLUDE "crt/classic/crt_init_atexit.asm"
	call    crt0_init_bss
	ld	hl,0
	add	hl,sp
	ld	(exitsp),hl
	ld	a, @00000001
	out	(3),a
	di
; Optional definition for auto MALLOC init
; it assumes we have free space between the end of
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF
	ld	bc,0
	push	bc
	push	bc
	call	_main
	pop	bc
	pop	bc
cleanup:
	push	hl
	call	crt0_exit
	pop	hl
	jp	0

l_dcal: jp      (hl)            ;Used for function pointer calls



	INCLUDE "crt/classic/crt_runtime_selection.asm" 
	
	INCLUDE	"crt/classic/crt_section.asm"

	SECTION BSS_END
	defb	2
	defw	CRT_ORG_CODE
