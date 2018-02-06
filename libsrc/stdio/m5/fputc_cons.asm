;
; 	Basic video handling for the SORD M5
;
;	(HL)=char to display
;
;	$Id: fputc_cons.asm,v 1.6+ (GIT imported) $
;

	SECTION code_clib
	PUBLIC	fputc_cons_native
	EXTERN	msxbios

	INCLUDE "target/m5/def/m5bios.def"

.fputc_cons_native
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
IF STANDARDESCAPECHARS
	cp  10
	jr	nz,nocr
	ld	a,13
.nocr
ENDIF

	ld	ix,DSPCH
	jp	msxbios
