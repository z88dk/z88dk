;       PC-G8xx / PC-E2xx  Program boot
;
;       Stefano Bodrato 2017
;
;       $Id: g800_crt0.asm - Stefano Exp $
;



	MODULE  g800_crt0
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


;--------
; Set an origin for the application (-zorg=) default to $100
;--------

IF      !DEFINED_CRT_ORG_CODE
	defc    CRT_ORG_CODE  = $100
ENDIF

        defc    CONSOLE_COLUMNS = 24
        defc    CONSOLE_ROWS = 4

	;defc	TAR__no_ansifont = 1

        defc    TAR__clib_exit_stack_size = 32
        defc    TAR__register_sp = -1
	INCLUDE	"crt/classic/crt_rules.inc"

	org     CRT_ORG_CODE

start:

    ld      (__restore_sp_onexit+1),sp   ;Save entry stack
    INCLUDE	"crt/classic/crt_init_sp.asm"
    INCLUDE	"crt/classic/crt_init_atexit.asm"
    call	crt0_init_bss
    ld      (exitsp),sp

IF DEFINED_USING_amalloc
	INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF

        call    _main           ;Call user program

cleanup:
        call    crt0_exit


cleanup_exit:
__restore_sp_onexit:ld      sp,0            ;Restore stack to entry value
        ret

l_dcal: jp      (hl)            ;Used for function pointer calls




        INCLUDE "crt/classic/crt_runtime_selection.asm"

	INCLUDE	"crt/classic/crt_section.asm"

	SECTION code_crt_init

;	ld	hl,??
;	ld	(base_graphics),hl



