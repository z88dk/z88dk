;       Galaksija  Program boot
;
;       Stefano Bodrato 2008
;
;       $Id: gal_crt0.asm,v 1.14 2016-06-21 20:49:06 dom Exp $
;



	MODULE  gal_crt0
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

IF      !DEFINED_CRT_ORG_CODE
	defc	CRT_ORG_CODE = 0x2c3a
ENDIF

        defc    CONSOLE_COLUMNS = 32
        defc    CONSOLE_ROWS = 16

	defc	TAR__no_ansifont = 1
        defc    TAR__clib_exit_stack_size = 32
        defc    TAR__register_sp = -1
	defc __CPU_CLOCK = 3072000
	INCLUDE	"crt/classic/crt_rules.inc"

        org     CRT_ORG_CODE

start:
        ld      (start1+1),sp   ;Save entry stack
	INCLUDE	"crt/classic/crt_init_sp.asm"
	INCLUDE	"crt/classic/crt_init_atexit.asm"
	call	crt0_init_bss
        ld      (exitsp),sp

IF DEFINED_USING_amalloc
	INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF

        call    _main           ;Call user program

cleanup:
;
;       Deallocate memory which has been allocated here!
;
IF CRT_ENABLE_STDIO = 1
        EXTERN     closeall
        call    closeall
ENDIF

cleanup_exit:
start1: ld      sp,0            ;Restore stack to entry value
        ret

l_dcal: jp      (hl)            ;Used for function pointer calls




        INCLUDE "crt/classic/crt_runtime_selection.asm"

	INCLUDE "crt/classic/crt_section.asm"


	SECTION	code_crt_init
	ld	hl,$2800
	ld	(base_graphics),hl

