;       Stub for the SHARP MZ family
;
;       Stefano Bodrato - 5/5/2000
;
;       $Id: mz_crt0.asm,v 1.24 2016-07-15 21:03:25 dom Exp $
;


                MODULE  mz_crt0

;--------
; Include zcc_opt.def to find out some info
;--------

        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        EXTERN    _main           ;main() is always external to crt0 code

        PUBLIC    cleanup         ;jp'd to by exit()
        PUBLIC    l_dcal          ;jp(hl)


; Now, getting to the real stuff now!

        IF      !DEFINED_CRT_ORG_CODE
                defc    CRT_ORG_CODE  = $1300
        ENDIF

        defc    TAR__clib_exit_stack_size = 32
        defc    TAR__register_sp = -1
        INCLUDE "crt/crt_rules.inc"

        org     CRT_ORG_CODE

start:
        ld      (start1+1),sp	;Save entry stack
        INCLUDE "crt/crt_init_sp.asm"
        INCLUDE "crt/crt_init_atexit.asm"
	call	crt0_init_bss
        ld      (exitsp),sp
IF DEFINED_USING_amalloc
	INCLUDE "amalloc.def"
ENDIF


        call    _main

cleanup:
;
;       Deallocate memory which has been allocated here!
;

IF !DEFINED_nostreams
	EXTERN	closeall
	call	closeall
ENDIF

start1:
        ld      sp,0
        jp	$AD	; Go back to monitor



l_dcal:	jp	(hl)		;Used for function pointer calls



	defm  "Small C+ SHARP MZ"
	defb	0

        INCLUDE "crt0_runtime_selection.asm"

        INCLUDE "crt0_section.asm"

        SECTION code_crt_init
        ld      hl,$D000
        ld      (base_graphics),hl

