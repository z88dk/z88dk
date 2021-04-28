;       CRT0 for the Robotron Z9001, KC85/1, KC87
;
;       Stefano Bodrato August 2016
;
;
; - - - - - - -
;
;       $Id: z9001_crt0.asm,v 1.3 2016-10-10 07:09:14 stefano Exp $
;
; - - - - - - -


    MODULE  z9001_crt0

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"


    EXTERN    _main           ;main() is always external to crt0 code
    PUBLIC    cleanup         ;jp'd to by exit()
    PUBLIC    l_dcal          ;jp(hl)


IF      !DEFINED_CRT_ORG_CODE
    defc    CRT_ORG_CODE  = 1000h
ENDIF


    defc    CONSOLE_COLUMNS = 40
    defc    CONSOLE_ROWS = 24

    defc    TAR__no_ansifont = 1
    defc    TAR__register_sp = CRT_ORG_CODE - 2
    defc    TAR__clib_exit_stack_size = 32
    defc    __CPU_CLOCK = 2457600
    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE

start:
    ld      (start1+1),sp

    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
    ld      (exitsp),sp


IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF

    call    _main   ;Call user program

cleanup:
    push    hl
    call    crt0_exit
    pop     bc
start1:
    ld      sp,0    ;Restore stack to entry value
    jp      $F000

l_dcal: 
    jp      (hl)    ;Used for function pointer calls


    INCLUDE "crt/classic/crt_runtime_selection.asm"
    INCLUDE "crt/classic/crt_section.asm"

    SECTION code_crt_init
    ld      hl,$EC00
    ld      (base_graphics),hl

