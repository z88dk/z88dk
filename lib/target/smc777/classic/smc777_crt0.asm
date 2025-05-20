;
;	Startup for Sony SMC-777


    module  smc777_crt0


    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

    EXTERN    _main           ;main() is always external to crt0 code
    EXTERN    asm_im1_handler

    PUBLIC    __Exit         ;jp'd to by exit()
    PUBLIC    l_dcal          ;jp(hl)


    IFNDEF CLIB_FGETC_CONS_DELAY
        defc CLIB_FGETC_CONS_DELAY = 150
    ENDIF
    defc    CONSOLE_COLUMNS = 80
    defc    CONSOLE_ROWS = 25
    defc    TAR__fputc_cons_generic = 1
    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__register_sp = $0000
    defc    TAR__crt_enable_eidi = 0x02     ;Enable interrupts on start
    defc    TAR__crt_on_exit = 0x10001      ;Just loop

    defc    CRT_KEY_DEL = 127
    defc    __CPU_CLOCK = 4000000



    INCLUDE "crt/classic/crt_rules.inc"



IF      !DEFINED_CRT_ORG_CODE
    defc CRT_ORG_CODE = 0x0100
ENDIF

    org     CRT_ORG_CODE

program:
    INCLUDE "crt/classic/crt_init_sp.inc"
    call    crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"


    ld      a,195
    ld      ($0038),a
    ld      hl,asm_im1_handler
    ld      ($0039),hl

    ; Set mode 1
    EXTERN  __smc777_mode
    EXTERN  __console_w
    ld      a,1
    ld      (__smc777_mode),a
    ld      l,@10000000
    in      a,($20)
    or      l
    out     ($20),a
    ld      a,40
    ld      (__console_w),a

    ; TODO: Add a keyboard interrupt handler?

    INCLUDE "crt/classic/crt_init_heap.inc"

    ; Enable interrupts (by default)
    INCLUDE "crt/classic/crt_init_eidi.inc"

    ld      hl,0
    push    hl      ;argv
    push    hl      ;argc
    call    _main
    pop     bc
    pop     bc
__Exit:
    call    crt0_exit
    INCLUDE "crt/classic/crt_exit_eidi.inc"
    INCLUDE "crt/classic/crt_terminate.inc"


loop:
    jp      loop        ;Restart


l_dcal: jp      (hl)            ;Used for function pointer calls



    INCLUDE "crt/classic/crt_runtime_selection.inc" 

    INCLUDE "crt/classic/crt_section.inc"

    SECTION rodata_clib
end:            defb    0               ; null file name


    INCLUDE "target/smc777/classic/bootstrap.asm"
