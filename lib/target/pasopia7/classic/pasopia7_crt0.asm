;
;	Startup for test emulator
;
;	$Id: test_crt0.asm,v 1.12 2016-06-21 20:49:07 dom Exp $


	module pasopia7_crt0
	org	  0xd000


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


        defc    TAR__clib_exit_stack_size = 32
        defc    TAR__register_sp = 65280
	defc	CRT_KEY_DEL = 127
	defc	__CPU_CLOCK = 4000000
        INCLUDE "crt/classic/crt_rules.inc"

	di

program:
        INCLUDE "crt/classic/crt_init_sp.asm"
        INCLUDE "crt/classic/crt_init_atexit.asm"
	call    crt0_init_bss
	ld	(exitsp),sp
IF !__CPU_R2K__
    	ei
ENDIF
; Optional definition for auto MALLOC init
; it assumes we have free space between the end of
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF
	call	_main
cleanup:
	jp	0


l_dcal: jp      (hl)            ;Used for function pointer calls



	INCLUDE "crt/classic/crt_runtime_selection.asm" 
	
	INCLUDE	"crt/classic/crt_section.asm"

	SECTION rodata_clib
end:            defb    0               ; null file name
