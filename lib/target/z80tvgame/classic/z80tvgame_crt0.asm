;
;   Z80 TV Game


    MODULE  z80tvgame_crt0


    defc    crt0 = 1
    INCLUDE "zcc_opt.def"


    EXTERN    _main           ; main() is always external to crt0 code

    PUBLIC    cleanup         ; jp'd to by exit()
    PUBLIC    l_dcal          ; jp(hl)




    defc    CRT_ORG_CODE = 0x0000
    defc    CRT_ORG_BSS = 0x8000

    defc    CONSOLE_ROWS = 26
    defc    CONSOLE_COLUMNS = 21

    defc    TAR__fputc_cons_generic = 1
    defc    TAR__clib_exit_stack_size = 0
    defc    TAR__register_sp = 0xc000
    defc	__CPU_CLOCK = 4000000

    defc TAR__crt_enable_rst = $8080
    EXTERN asm_im1_handler
    defc _z80_rst_38h = asm_im1_handler

    defc    TAR__crt_on_exit = 0            ;Jump to 0 at finish
    defc    TAR__crt_enable_eidi = $02      ;Enable ei on startup 


    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE

if (ASMPC<>$0000)
        defs    CODE_ALIGNMENT_ERROR
endif

    jp      start 
    INCLUDE	"crt/classic/crt_z80_rsts.asm"

start:
    di
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call	crt0_init_bss
    INCLUDE "crt/classic/crt_start_eidi.inc"
    INCLUDE "crt/classic/crt_init_amalloc.asm"
    call    _main           ; Call user program
cleanup:
    call    crt0_exit
    INCLUDE "crt/classic/crt_terminate.inc"

l_dcal: 
    jp      (hl)            ;Used for function pointer calls


    INCLUDE "crt/classic/crt_runtime_selection.asm"

    defc    __crt_org_bss = CRT_ORG_BSS
    IF DEFINED_CRT_MODEL
        defc __crt_model = CRT_MODEL
    ELSE
        defc __crt_model = 1
    ENDIF
    INCLUDE "crt/classic/crt_section.asm"



