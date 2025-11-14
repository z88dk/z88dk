;       Bandai RX78 CRT0
;


    MODULE  rx78_crt0

    


    defc    crt0 = 1
    INCLUDE "zcc_opt.def"



    EXTERN    _main           ; main() is always external to crt0 code

    PUBLIC    __Exit         ; jp'd to by exit()
    PUBLIC    l_dcal          ; jp(hl)



;--------
; Set an origin for the application (-zorg=) default to 32768
;--------

    defc    CRT_ORG_CODE = 0x2000
    defc    CRT_ORG_BSS = 0xb000

    defc    CONSOLE_ROWS = 23
    defc    CONSOLE_COLUMNS = 24

    PUBLIC  __IO_SN76489_PORT
    defc    __IO_SN76489_PORT = $ff


    defc    TAR__fputc_cons_generic = 1
    defc    TAR__clib_exit_stack_size = 0
    defc    TAR__register_sp = 0xebff
    defc    TAR__crt_enable_eidi = $02
    defc    TAR__crt_on_exit = $0000
    defc    __CPU_CLOCK = 4090909
    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE

    defb    0x01
    defb    0
    defb    0

start:
    di
    INCLUDE "crt/classic/crt_init_sp.inc"
    INCLUDE "crt/classic/crt_init_atexit.inc"
    ld      hl,interrupt
    ld      (0xe788),hl		;RAM interrupt vector
    call    crt0_init

    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"


    call    _main           ; Call user program
__Exit:
    call    crt0_exit
    INCLUDE "crt/classic/crt_exit_eidi.inc"
    INCLUDE "crt/classic/crt_terminate.inc"
    
interrupt:
    ei
    ret

l_dcal:
    jp      (hl)            ;Used for function pointer calls


    INCLUDE "crt/classic/crt_runtime_selection.inc"

    defc    __crt_org_bss = CRT_ORG_BSS
    IF DEFINED_CRT_MODEL
        defc __crt_model = CRT_MODEL
    ELSE
        defc __crt_model = 1
    ENDIF
    INCLUDE "crt/classic/crt_section.inc"



