;
;	Startup for m100
;	Stefano, February 2020
;
;	"appmake +trs80 --co" will prepare a valid binary file, to be invoked from within BASIC:
;	CLEAR 0,49999: RUNM "A.CO"
;

IF      !DEFINED_CRT_ORG_CODE
    defc  CRT_ORG_CODE  = 50000
ENDIF

IF !DEFINED_CRT_MAX_HEAP_ADDRESS
    defc    CRT_MAX_HEAP_ADDRESS = $F500
ENDIF

    org	  CRT_ORG_CODE

program:

    INCLUDE "crt/classic/crt_init_sp.inc"
    call    crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"


    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"

    push    bc	;argv
    push    bc	;argc
    call    _main
    pop     bc
    pop     bc
__Exit:
    push    hl
    call    crt0_exit
    pop     hl
    INCLUDE "crt/classic/crt_exit_eidi.inc"
    ret

