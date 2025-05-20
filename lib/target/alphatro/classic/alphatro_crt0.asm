;       Triumph Adler Alphatronic PC crt0
;


    MODULE  alphatro_crt0



    defc    crt0 = 1
    INCLUDE "zcc_opt.def"


    EXTERN  _main           ; main() is always external to crt0 code

    PUBLIC  __Exit         ; jp'd to by exit()
    PUBLIC  l_dcal          ; jp(hl)



    defc    CRT_ORG_CODE = 0xa000
    defc    CRT_ORG_BSS = 0x6000

    defc    CONSOLE_ROWS = 24
    defc    CONSOLE_COLUMNS = 40

    defc    CRT_KEY_DEL = 12

    defc    TAR__fputc_cons_generic = 1
    defc    TAR__clib_exit_stack_size = 0
    defc    TAR__register_sp = -1
    defc    __CPU_CLOCK = 4000000 
    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE
    jp      start

start:
    ld      (__restore_sp_onexit+1),sp   ; Save entry stack
    INCLUDE "crt/classic/crt_init_sp.inc"
    call    crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"

    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"

    call    _main           ; Call user program
__Exit:
    push    hl              ; return code
    call    crt0_exit
    pop     bc              ; return code (still not sure it is teh right one !)

__restore_sp_onexit:
    ld      sp,0            ;Restore stack to entry value
endloop:
    jr      endloop


l_dcal: jp      (hl)            ;Used for function pointer calls



    INCLUDE "crt/classic/crt_runtime_selection.inc"

    defc    __crt_org_bss = CRT_ORG_BSS
IF DEFINED_CRT_MODEL
    defc __crt_model = CRT_MODEL
ELSE
    defc __crt_model = 1
ENDIF
    INCLUDE "crt/classic/crt_section.inc"
