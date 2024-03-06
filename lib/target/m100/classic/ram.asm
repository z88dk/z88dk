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
    INCLUDE "crt/classic/crt_init_atexit.inc"
    call    crt0_init_bss
    ld      hl,0
    add     hl,sp
    ld      (exitsp),hl

    INCLUDE "crt/classic/crt_init_heap.asm"
    INCLUDE "crt/classic/crt_init_eidi.inc"

    push    bc	;argv
    push    bc	;argc
    call    _main
    pop     bc
    pop     bc
cleanup:
    push    hl
    call    crt0_exit
    pop     hl
    ret

