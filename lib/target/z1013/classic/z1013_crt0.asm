;       CRT0 for the Robotron Z1013
;
;       Stefano Bodrato August 2016
;
;
; - - - - - - -
;
;       $Id: z1013_crt0.asm,v 1.2 2016-10-10 07:09:14 stefano Exp $
;
; - - - - - - -


    MODULE  Z1013_crt0

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

    EXTERN  _main           ;main() is always external to crt0 code
    PUBLIC  cleanup         ;jp'd to by exit()
    PUBLIC  l_dcal          ;jp(hl)


    defc    CONSOLE_ROWS = 32
    defc    CONSOLE_COLUMNS = 32


IF      !DEFINED_CRT_ORG_CODE
    defc    CRT_ORG_CODE  = 100h
ENDIF

    defc    TAR__no_ansifont = 1
    defc    TAR__fputc_cons_generic = 1
    defc    TAR__register_sp = 0xdfff
    defc    TAR__clib_exit_stack_size = 32
    defc    __CPU_CLOCK = 1000000
    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE

start:
    ld      (start1+1),sp	;Save entry stack

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

