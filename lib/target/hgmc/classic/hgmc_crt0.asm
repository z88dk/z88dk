;
;	Startup for Hübler Grafik MC
;
;	https://hc-ddr.hucki.net/wiki/doku.php/homecomputer/hueblergrafik
;

    MODULE hgmc_crt0

    INCLUDE	"target/hgmc/def/hgmc.def"


    defc    crt0 = 1
    INCLUDE "zcc_opt.def"



    EXTERN    _main           ;main() is always external to crt0 code
    EXTERN    asm_im1_handler

    PUBLIC    __Exit         ;jp'd to by exit()
    PUBLIC    l_dcal          ;jp(hl)


    defc    TAR__clib_exit_stack_size = 4
    defc    TAR__register_sp = -1		; $c000
    defc	CRT_KEY_DEL = 8
    defc	__CPU_CLOCK = 1500000
    defc    CONSOLE_COLUMNS = 32
    defc    CONSOLE_ROWS = 32
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

    jp      start

    INCLUDE "crt/classic/crt_z80_rsts.inc"

start:
    INCLUDE "crt/classic/crt_init_sp.inc"
    call    crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"
    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"
    ld      hl,0
    push    hl	;argv
    push    hl	;argc
    call    _main
    pop     bc
    pop     bc
__Exit:
    call    crt0_exit
    INCLUDE "crt/classic/crt_exit_eidi.inc"
    INCLUDE "crt/classic/crt_terminate.inc"

l_dcal:
    jp      (hl)            ;Used for function pointer calls


    INCLUDE "crt/classic/crt_runtime_selection.inc" 
    INCLUDE	"crt/classic/crt_section.inc"
