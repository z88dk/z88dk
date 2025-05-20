;       CRT0 for the SORD M5
;
;       Stefano Bodrato Maj. 2000
;
;       If an error occurs eg break we just drop back to BASIC
;
;       $Id: m5_crt0.asm,v 1.22 2016-07-15 21:03:25 dom Exp $
;



IF      !DEFINED_CRT_ORG_CODE
    defc    CRT_ORG_CODE  = $7300
ENDIF

    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__register_sp = -1
    INCLUDE "crt/classic/crt_rules.inc"
    org     CRT_ORG_CODE

start:
    ld      (__restore_sp_onexit+1),sp
    INCLUDE "crt/classic/crt_init_sp.inc"
    call    crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"
    INCLUDE "crt/classic/tms99x8/tms99x8_mode_init.inc"

    INCLUDE "crt/classic/crt_init_heap.inc"

    exx
    push    hl
    INCLUDE "crt/classic/crt_init_eidi.inc"

    call    _main
        
__Exit:
    push    hl
    call    crt0_exit
    INCLUDE "crt/classic/tms99x8/tms99x8_mode_exit.inc"

    pop     bc
    exx
    pop     hl
    exx
    INCLUDE "crt/classic/crt_exit_eidi.inc"
__restore_sp_onexit:
    ld      sp,0
    ret


