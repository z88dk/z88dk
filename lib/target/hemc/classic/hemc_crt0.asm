;
;	Startup for Hübler/Evert-MC
;
;	https://hc-ddr.hucki.net/wiki/doku.php/homecomputer/huebler#hueblerevert-mc
;

    MODULE  hemc_crt0

    INCLUDE "target/hemc/def/hemc.def"


    defc    crt0 = 1
    INCLUDE "zcc_opt.def"



    EXTERN  _main           ;main() is always external to crt0 code
    EXTERN  asm_im1_handler

    PUBLIC  cleanup         ;jp'd to by exit()
    PUBLIC  l_dcal          ;jp(hl)


    defc    TAR__clib_exit_stack_size = 4
    defc    TAR__register_sp = $e800
    defc	CRT_KEY_DEL = 8
    defc	__CPU_CLOCK = 2457600
    defc    CONSOLE_COLUMNS = 64
    defc    CONSOLE_ROWS = 24
    defc    GRAPHICS_CHAR_SET = 128 + 32
    defc    GRAPHICS_CHAR_UNSET = 32
    PUBLIC  GRAPHICS_CHAR_SET
    PUBLIC  GRAPHICS_CHAR_UNSET

    defc    TAR__crt_enable_rst = $8080
    EXTERN  asm_im1_handler
    defc    _z80_rst_38h = asm_im1_handler

    defc    TAR__crt_on_exit = RESTART
    defc    TAR__crt_enable_eidi = $02      ;Enable ei on startup

    INCLUDE "crt/classic/crt_rules.inc"

    defc    CRT_ORG_CODE = 0x0000

    org     CRT_ORG_CODE


if (ASMPC<>$0000)
    defs    CODE_ALIGNMENT_ERROR
endif

    jp  start

    INCLUDE "crt/classic/crt_z80_rsts.asm"


start:
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
    ld      hl,0
    add     hl,sp
    ld      (exitsp),hl
IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF
    INCLUDE "crt/classic/crt_start_eidi.inc"
    ld      hl,0
    push    hl	;argv
    push    hl	;argc
    call    _main
    pop     bc
    pop     bc
cleanup:
    INCLUDE "crt/classic/crt_terminate.inc"
    
l_dcal:
    jp      (hl)            ;Used for function pointer calls



    INCLUDE "crt/classic/crt_runtime_selection.asm" 
    INCLUDE	"crt/classic/crt_section.asm"
