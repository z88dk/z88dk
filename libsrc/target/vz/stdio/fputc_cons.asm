;
;       VZ C Library
;
;	Print character to the screen
;
;       We will corrupt any register
;
;       We print over 16 lines at 32 columns
;
;       Stefano Bodrato - Apr.2000
;
;
;	$Id: fputc_cons.asm,v 1.5 2016-05-15 20:15:46 dom Exp $
;

	  SECTION code_clib
          PUBLIC  fputc_cons_native

;
; Entry:        hl points char to print
;

; 193 Inverse characters starting from "@".
; 64  "@" char (as normal).
; 127-192 Pseudo-Graphics Chars (like ZX81)


.fputc_cons_native
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	
	cp	12
	jr	nz,nocls
	ld	a,0
	ld	(6800h),a	; force TEXT mode
	jp	457
.nocls

IF STANDARDESCAPECHARS
	cp  10
	jr  nz,notCR
	ld	a,13
	jr setout
.notCR
ENDIF

	; Some undercase text?  Transform in UPPER !
	cp	97
	jr	c,nounder
	sub	32
	jr	setout
.nounder
	; Transform the UPPER to INVERSE TEXT
	; Naah! That was orrible!
	cp	65
	jr	c,noupper
	add	a,128
.noupper
	; Some more char remapping can stay here...
.setout
	jp	826

