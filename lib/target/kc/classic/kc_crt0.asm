;
;       CRT0 for the Robotron KC85/2 .. KC85/5
;
;       Stefano Bodrato October 2016
;		few hints were found on the sdcc lib by Andreas Ziermann and Bert Lange
;
; - - - - - - -
;
;       $Id: kc_crt0.asm,v 1.2 2016-10-10 07:09:14 stefano Exp $
;
; - - - - - - -
;
; NB. Compiled with -IXIY so all iy references are actually iy


    MODULE  kc_crt0


    defc    crt0 = 1
    INCLUDE "zcc_opt.def"


    EXTERN  _main           ;main() is always external to crt0 code

    PUBLIC  cleanup         ;jp'd to by exit()
    PUBLIC  l_dcal          ;jp(hl)


IF      !DEFINED_CRT_ORG_CODE
    defc    CRT_ORG_CODE  = $1000
ENDIF
    defc    CONSOLE_COLUMNS = 40
    defc    CONSOLE_ROWS = 32

    defc    TAR__fputc_cons_generic = 1
    defc	TAR__register_sp = CRT_ORG_CODE-2
    defc    TAR__clib_exit_stack_size = 32
    defc	__CPU_CLOCK = 2000000
    INCLUDE	"crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE


start:
    ld      (__restore_sp_onexit+1),sp	;Save entry stack
    INCLUDE "crt/classic/crt_init_sp.asm"	
    INCLUDE "crt/classic/crt_init_atexit.asm"	
    call    crt0_init_bss
    ld      (exitsp),sp



IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF


    call    _main	;Call user program

cleanup:
    push    hl
    call    crt0_exit


	pop	bc
__restore_sp_onexit:
    ld      sp,0    ;Restore stack to entry value
    ; use call LOOP instead of ret, works also
    ; with direct load+start on simulator
    call    $f003   ; PV1 - parameter in regs, PVnr after callPV1
    defb    $12     ;FNLOOP - returns control to CAOS without memory initialization


l_dcal:	jp	(hl)		;Used for function pointer calls

    INCLUDE "crt/classic/crt_runtime_selection.asm"
    INCLUDE "crt/classic/crt_section.asm"

    SECTION code_crt_init
    ld      hl,$8000
    ld      (base_graphics),hl

