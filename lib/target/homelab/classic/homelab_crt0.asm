;
;	Startup for Homelab
;

    MODULE  homelab_crt0


    defc    crt0 = 1
    INCLUDE "zcc_opt.def"



    EXTERN    _main           ;main() is always external to crt0 code
    EXTERN    asm_im1_handler

    PUBLIC    __Exit         ;jp'd to by exit()
    PUBLIC    l_dcal          ;jp(hl)


    defc    TAR__fputc_cons_generic = 1
    defc    TAR__clib_exit_stack_size = 4
    defc    TAR__register_sp = -1
    defc	CRT_KEY_DEL = 8
    defc	__CPU_CLOCK = 3000000

    defc    TAR__crt_on_exit = 0            ;Jump to 0 at finish
    defc    TAR__crt_enable_eidi = $00      ;No special behaviour

    INCLUDE "crt/classic/crt_rules.inc"

    defc    CRT_ORG_CODE = 0x4300

    org     CRT_ORG_CODE

start:
    INCLUDE "crt/classic/crt_init_sp.inc"
    call    crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"
    out     ($ff),a
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
