;       Stub for the SHARP MZ family
;
;       Stefano Bodrato - 5/5/2000
;
; 	UncleBod	-  2018-09-25
;	Changed default org to 1200
;       $Id: mz_crt0.asm $
;


    MODULE  mz_crt0



    defc    crt0 = 1
    INCLUDE "zcc_opt.def"


    EXTERN    _main           ;main() is always external to crt0 code

    PUBLIC    cleanup         ;jp'd to by exit()
    PUBLIC    l_dcal          ;jp(hl)


; Now, getting to the real stuff now!

IF      !DEFINED_CRT_ORG_CODE
    defc    CRT_ORG_CODE  = $1200
ENDIF

    defc    CONSOLE_COLUMNS = 40
    defc    CONSOLE_ROWS = 25

    defc	TAR__no_ansifont = 1
    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__register_sp = -1
    defc	__CPU_CLOCK = 4000000
    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE

start:
    ld      (__restore_sp_onexit+1),sp	;Save entry stack
    INCLUDE "crt/classic/crt_init_sp.inc"
    INCLUDE "crt/classic/crt_init_atexit.inc"
    call	crt0_init_bss
    ld      (exitsp),sp
    INCLUDE "crt/classic/crt_init_heap.asm"
    INCLUDE "crt/classic/crt_init_eidi.inc"


    call    _main

cleanup:
    call    crt0_exit


__restore_sp_onexit:
    ld      sp,0
IF (startup=2)
        ;jp	$EAA7	; MZ-1500 mode
    ret
ELSE
    jp      $AD	; Go back to monitor
ENDIF


l_dcal:	jp	(hl)		;Used for function pointer calls




        INCLUDE "crt/classic/crt_runtime_selection.inc"

        INCLUDE "crt/classic/crt_section.inc"

        SECTION code_crt_init
        ld      hl,$D000
        ld      (base_graphics),hl

