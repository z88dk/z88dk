;
;       CRT0 for the Philips Videopac C7420 module
;
;       Stefano Bodrato 2015
;
;       $Id: c7420_crt0.asm,v 1.10 2016-07-15 21:03:25 dom Exp $
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

        IF      !DEFINED_CRT_ORG_CODE
                defc    CRT_ORG_CODE  = 35055
        ENDIF   

        org     CRT_ORG_CODE


start:
        ld      (start1+1),sp	;Save entry stack
        IF !STACKPTR
        ;ld      hl,-64
        ;add     hl,sp
        ;ld      sp,hl
		ELSE
        ld      sp,STACKPTR-64
		ENDIF

		call    crt0_init_bss
        ld      (exitsp),sp
		
; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "amalloc.def"
	ENDIF

		call    _main
cleanup:
		push	hl
;
;       Deallocate memory which has been allocated here!
;

IF !DEFINED_nostreams
		EXTERN	closeall
		call	closeall
ENDIF

		pop	hl
start1:
		ld  sp,0
		ld	a,l
		jp	$19f9	; $1994 for french version ??
				; perhaps we should first spot the right location,
				; looking around for the 47h, AFh sequence


l_dcal:
		jp	(hl)	; Used for function pointer calls



	INCLUDE "crt0_runtime_selection.asm"
	INCLUDE	"crt0_section.asm"


