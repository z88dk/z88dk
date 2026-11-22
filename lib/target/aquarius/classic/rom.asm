;       CRT0 (rom) stub for Aquarius carts
;

    ; Constants for ROM mode (-startup=2)

    defc    CRT_ORG_CODE  = 0xe000
    defc    TAR__register_sp = 0x3fff
    defc    TAR__clib_exit_stack_size = 0
    defc    TAR__crt_on_exit = 0x10001  ;Loop forever
    defc	RAM_Start = 0x3900
    INCLUDE	"crt/classic/crt_rules.inc"


    org     CRT_ORG_CODE

    ; Aquarius Cartridge Header (SuperCart I, 8K Mode)
    defb    $53,$43,$30,$38,$4B,$9C,$B5,$B0,$A8,$6C,$AC,$64,$CC,$A8,$06,$70

program:
    INCLUDE "crt/classic/crt_init_sp.inc"

    call    crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"

    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"

; Entry to the user code
    call    _main

__Exit:
    call    crt0_exit
    INCLUDE "crt/classic/crt_exit_eidi.inc"
    INCLUDE "crt/classic/crt_terminate.inc"

    defc	__crt_org_bss = RAM_Start
    ; If we were given a model then use it
    IF DEFINED_CRT_MODEL
        defc __crt_model = CRT_MODEL
    ELSE
        defc __crt_model = 1
    ENDIF
