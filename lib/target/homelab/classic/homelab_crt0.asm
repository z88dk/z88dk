;
;	Startup for Homelab
;

    MODULE  homelab_crt0


    defc    crt0 = 1
    INCLUDE "zcc_opt.def"



    EXTERN    _main           ;main() is always external to crt0 code
    EXTERN    asm_im1_handler

    PUBLIC    cleanup         ;jp'd to by exit()
    PUBLIC    l_dcal          ;jp(hl)


    defc    TAR__fputc_cons_generic = 1
    defc    TAR__clib_exit_stack_size = 4
    defc    TAR__register_sp = -1
    defc	CRT_KEY_DEL = 8
    defc	__CPU_CLOCK = 3000000
    INCLUDE "crt/classic/crt_rules.inc"

    defc    CRT_ORG_CODE = 0x4300

    org     CRT_ORG_CODE

program:
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
    ld      hl,0
    add     hl,sp
    ld      (exitsp),hl
    out     ($ff),a
IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF
    ld      hl,0
    push    hl	;argv
    push    hl	;argc
    call    _main
    pop     bc
    pop     bc
cleanup:
    jp      0

l_dcal:
    jp      (hl)            ;Used for function pointer calls



    INCLUDE "crt/classic/crt_runtime_selection.asm" 
    INCLUDE	"crt/classic/crt_section.asm"
