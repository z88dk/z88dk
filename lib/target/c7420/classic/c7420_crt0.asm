;
;       CRT0 for the Philips Videopac C7420 module
;
;       Stefano Bodrato 2015
;
;       $Id: c7420_crt0.asm,v 1.10 2016-07-15 21:03:25 dom Exp $
;


    MODULE  c7420_crt0


;--------
; Include zcc_opt.def to find out some info
;--------

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

    EXTERN    _main           ;main() is always external to crt0 code

    PUBLIC    __Exit         ;jp'd to by exit()
    PUBLIC    l_dcal          ;jp(hl)


IF      !DEFINED_CRT_ORG_CODE
    defc    CRT_ORG_CODE  = 35055
ENDIF   


    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__register_sp = -1
    defc    __CPU_CLOCK = 3574000
    INCLUDE	"crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE


start:
    ld      (__restore_sp_onexit+1),sp	;Save entry stack
    INCLUDE	"crt/classic/crt_init_sp.inc"

    call    crt0_init
    INCLUDE	"crt/classic/crt_init_atexit.inc"

    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"


    call    _main
__Exit:
    push	hl
    call    crt0_exit
    pop     hl
    INCLUDE "crt/classic/crt_exit_eidi.inc"
__restore_sp_onexit:
    ld      sp,0
    ld      a,l
    jp      $19f9	; $1994 for french version ??
                    ; perhaps we should first spot the right location,
                    ; looking around for the 47h, AFh sequence


l_dcal:
    jp      (hl)	; Used for function pointer calls



    INCLUDE "crt/classic/crt_runtime_selection.inc"
    INCLUDE	"crt/classic/crt_section.inc"


