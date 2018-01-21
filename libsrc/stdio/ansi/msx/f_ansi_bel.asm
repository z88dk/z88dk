;
; 	ANSI Video handling for the MSX
;
; 	BEL - chr(7)   Beep it out
;
;
;	Stefano Bodrato - Oct. 2017
;
;
;	$Id: f_ansi_bel.asm $
;

	SECTION  code_clib
	
	PUBLIC	ansi_BEL
	EXTERN	msxbios

IF FORmsx
        INCLUDE "target/msx/def/msxbios.def"
ELSE
        INCLUDE "target/svi/def/svibios.def"
ENDIF


.ansi_BEL
	push	ix	;save callers
	ld	ix,BEEP	; Print char
	call	msxbios
	pop	ix	;restore callers
	ret

