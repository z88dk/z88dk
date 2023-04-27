;
; There's only 512 bytes of user memory to play with on this machine,
; so strip everything down as much as we can
;
;

    MODULE  krokha_crt0


    defc    crt0 = 1
    INCLUDE "zcc_opt.def"


    EXTERN  _main           ;main() is always external to crt0 code
    EXTERN  asm_im1_handler

    PUBLIC  cleanup         ;jp'd to by exit()
    PUBLIC  l_dcal          ;jp(hl)


    defc    TAR__clib_exit_stack_size = 0
    defc    TAR__register_sp = 0xea00
    defc    TAR__fputc_cons_generic = 1
    defc    CRT_KEY_DEL = 127
    defc    __CPU_CLOCK = 2000000

    ; RAM trimming
    defc    DEFINED_CLIB_FOPEN_MAX = 1
    defc    CLIB_FOPEN_MAX = 3
    defc    DEFINED_basegraphics = 1 


    defc    CRT_ORG_CODE = 0x0000
    defc    CRT_ORG_BSS = 0xe000
    defc    __crt_org_bss = CRT_ORG_BSS

    defc    TAR__crt_enable_rst = $8080
    EXTERN  asm_im1_handler
    defc    _z80_rst_38h = asm_im1_handler

    defc    CONSOLE_COLUMNS = 48
    defc    CONSOLE_ROWS = 32

    defc    TAR__crt_enable_eidi = 0x02     ;Enable interrupts on start
    defc    TAR__crt_on_exit = 0x0000       ;Jump to exit

    INCLUDE "crt/classic/crt_rules.inc"


    org	  CRT_ORG_CODE

IF CRT_ORG_CODE = 0x0000

if (ASMPC<>$0000)
    defs    CODE_ALIGNMENT_ERROR
endif

    jp      start
    INCLUDE	"crt/classic/crt_z80_rsts.asm"
ENDIF

start:
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
    ld      hl,0
    add     hl,sp
    ld      (exitsp),hl
    INCLUDE "crt/classic/crt_init_amalloc.asm"
    INCLUDE "crt/classic/crt_start_eidi.inc"
    ld      hl,0
    push    hl	;argv
    push    hl	;argc
    call    _main
cleanup:
    call    crt0_exit
    INCLUDE "crt/classic/crt_terminate.inc"


l_dcal: jp      (hl)            ;Used for function pointer calls


    ; If we were given a model then use it
IFDEF CRT_MODEL
    defc __crt_model = CRT_MODEL
ELSE
    defc __crt_model = 1
ENDIF

    INCLUDE "crt/classic/crt_runtime_selection.asm" 
    INCLUDE	"crt/classic/crt_section.asm"