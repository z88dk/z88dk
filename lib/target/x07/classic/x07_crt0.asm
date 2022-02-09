;
;       Startup for Canon X-07
;
;       $Id: x07_crt0.asm,v 1.13 2016-07-15 21:03:25 dom Exp $
;

    MODULE  x07_crt0

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"



    EXTERN  _main		;main() is always external to crt0

    PUBLIC  cleanup		;jp'd to by exit()
    PUBLIC  l_dcal		;jp(hl)


IF      !DEFINED_CRT_ORG_CODE
    defc    CRT_ORG_CODE  = $800
ENDIF

    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__register_sp = -1
    defc    __CPU_CLOCK = 3840000
    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE

;----------------------
; Execution starts here
;----------------------
start:
    ;di

    ld      (__restore_sp_onexit+1),sp	;Save entry stack
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call	crt0_init_bss
    ld      (exitsp),sp


IF DEFINED_USING_amalloc
	INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF

    ;ld a,65	; (Debugging:  print 'A' char)
    ;call $009F
    call    _main   ;Call user code
    ;ld a,65	; (Debugging:  print 'A' char)
    ;call $009F

cleanup:
    call    crt0_exit

__restore_sp_onexit:
    ld      sp,0    ;Pick up entry sp
    ret             ; End of program

l_dcal:
    jp  (hl)    ;Used for call by function ptr


end:
    defb    0   ; null file name

    INCLUDE "crt/classic/crt_runtime_selection.asm"

    INCLUDE	"crt/classic/crt_section.asm"


