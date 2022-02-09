;       CRT0 for the NASCOM1/2
;
;       Stefano Bodrato May 2003
;
;
; - - - - - - -
;
;       $Id: nascom_crt0.asm,v 1.23 2016-08-05 07:04:09 stefano Exp $
;
; - - - - - - -


    MODULE  nascom_crt0


    defc    crt0 = 1
    INCLUDE "zcc_opt.def"



    EXTERN  _main           ;main() is always external to crt0 code

    PUBLIC  cleanup         ;jp'd to by exit()
    PUBLIC  l_dcal          ;jp(hl)


    PUBLIC  montest         ;NASCOM: check the monitor type

    defc    CONSOLE_ROWS = 16
    defc    CONSOLE_COLUMNS = 48 

IF      !DEFINED_CRT_ORG_CODE
    defc    CRT_ORG_CODE  = 1000h
ENDIF

    defc	TAR__no_ansifont = 1
    defc    TAR__fputc_cons_generic = 1
    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__register_sp = 0xe000
    defc	__CPU_CLOCK = 2000000
    INCLUDE "crt/classic/crt_rules.inc"
    org     CRT_ORG_CODE

; NASSYS1..NASSYS3
;  IF (startup=1) | (startup=2) | (startup=3)
;
;
;  ENDIF

start:

    ld      (__restore_sp_onexit+1),sp	;Save entry stack
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
    ld      (exitsp),sp

IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF


    call    _main	;Call user program

cleanup:
    push    hl
    call    crt0_exit
    pop     bc

__restore_sp_onexit:
    ld      sp,0        ;Restore stack to entry value
    rst     18h
    defb    5bh
    ;ret

l_dcal:
    jp      (hl)        ;Used for function pointer calls


;------------------------------------
; Check which monitor we have in ROM
;------------------------------------

montest: 
    ld      a,(1)	; "T" monitor or NAS-SYS?
    cp      33h	; 31 00 10     / 31 33 0C
    ret

    INCLUDE "crt/classic/crt_runtime_selection.asm"
    INCLUDE "crt/classic/crt_section.asm"

