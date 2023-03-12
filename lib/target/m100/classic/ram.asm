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

    org	  CRT_ORG_CODE

program:

    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
    ld      hl,0
    add     hl,sp
    ld      (exitsp),hl

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
    defc    CRT_MAX_HEAP_ADDRESS = $F500
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF

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

