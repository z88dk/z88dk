;       CRT0 for the Philips Videopac C7420 module
;
;       Stefano Bodrato 2015
;
;       $Id: c7420_crt0.asm,v 1.6 2016-06-02 22:24:57 dom Exp $
;


        MODULE  c7420_crt0

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
                defc    myzorg  = 35055
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
	push	hl
cleanup:
;
;       Deallocate memory which has been allocated here!
;

IF !DEFINED_nostreams
	EXTERN	closeall
	call	closeall
ENDIF

	pop	hl
start1:
        ld      sp,0
	ld	a,l
        jp	$19f9	; $1994 for french version ??
			; perhaps we should first spot the right location,
						; looking around for the 47h, AFh sequence


l_dcal:	jp	(hl)		;Used for function pointer calls


IF NEED_floatpack
        INCLUDE         "float.asm"
ENDIF

        INCLUDE "crt0_runtime_selection.asm"
	INCLUDE	"crt0_section.asm"


