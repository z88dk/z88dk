;       CRT0 (rom) stub for Aquarius carts
;

    ; Constants for ROM mode (-startup=2)

    defc    CRT_ORG_CODE  = 0xe000
    defc    TAR__register_sp = 0x3fff
    defc    TAR__clib_exit_stack_size = 0
    defc	RAM_Start = 0x3900
    INCLUDE	"crt/classic/crt_rules.inc"


    org     CRT_ORG_CODE

    ; Aquarius Cartridge Header (SuperCart I, 8K Mode)
    defb    $53,$43,$30,$38,$4B,$9C,$B5,$B0,$A8,$6C,$AC,$64,$CC,$A8,$06,$70

program:

; Make room for the atexit() stack
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"

    call    crt0_init_bss
    ld      (exitsp),sp


IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF

; Entry to the user code
    call    _main

cleanup:
    push    hl
    call    crt0_exit

endloop:
    jr      endloop


    defc	__crt_org_bss = RAM_Start
    ; If we were given a model then use it
    IF DEFINED_CRT_MODEL
        defc __crt_model = CRT_MODEL
    ELSE
        defc __crt_model = 1
    ENDIF
