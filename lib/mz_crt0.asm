;       Stub for the SHARP MZ family
;
;       Stefano Bodrato - 5/5/2000
;
;       $Id: mz_crt0.asm,v 1.19 2016-05-18 20:25:28 dom Exp $
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

        IF      !myzorg
                defc    myzorg  = $1300
        ENDIF


        org     myzorg

start:
        ld      (start1+1),sp	;Save entry stack
        ld      hl,-64
        add     hl,sp
        ld      sp,hl
        ld      (exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "amalloc.def"
	ENDIF

	call	crt0_init_bss

        call    _main

cleanup:
;
;       Deallocate memory which has been allocated here!
;

IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
	EXTERN	closeall
	call	closeall
ENDIF
ENDIF

start1:
        ld      sp,0
        jp	$AD	; Go back to monitor



l_dcal:	jp	(hl)		;Used for function pointer calls


IF NEED_floatpack
        INCLUDE "float.asm"
ENDIF

	defm  "Small C+ SHARP MZ"
	defb	0

        INCLUDE "crt0_runtime_selection.asm"

        INCLUDE "crt0_section.asm"

        SECTION code_crt_init
        ld      hl,$D000
        ld      (base_graphics),hl

