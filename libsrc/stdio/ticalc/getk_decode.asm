;
;	TI calc Routines
;
;	getk_decode() Translates key code
;
;	Stefano Bodrato - Dec 2000
;
;
;	$Id: getk_decode.asm,v 1.7 2016-06-12 17:32:01 dom Exp $
;

        	SECTION code_clib
		PUBLIC	getk_decode

		INCLUDE	"stdio/ansi/ticalc/ticalc.inc"

.getk_decode

IF FORti82
; **** If we have a TI82 and we use CRASH, ****
; **** letters and numbers are in sequence ****
;
; Numbers.
		cp	143	; >= '0' ?
		jr	c,isntnum
		cp	153	
		jr	nc,isntnum ; < '9'+1
		sub	a,95	; Ok, re-code to the ASCII charset
		jr	setout
.isntnum
		cp	155	; Between A and Z ?
		jr	c,isntupper
		cp	181
		jr	nc,isntupper
		sub	a,90	; Ok, re-code to the ASCII charset
		jr	setout
.isntupper
; **** End of TI82 specific key handling ****
ENDIF


IF FORti86
; **** We have a TI86. Letters and numbers are in sequence ****
;
; Numbers. (XZ81 has the same number coding !)
		cp	28	; Between 0 and 9 ?
		jr	c,isntnum
		cp	38
		jr	nc,isntnum
		add	a,20	; Ok, re-code to the ASCII charset
		jr	setout
.isntnum
		cp	$28	; Between A and Z ?
		jr	c,isntupper
		cp	$42
		jr	nc,isntupper
		add	a,25	; Ok, re-code to the ASCII charset
		jr	setout
.isntupper
		cp	$42	; Between a and z ?
		jr	c,isntlower
		cp	$5C
		jr	nc,isntlower
		dec	a	; Ok, re-code to the ASCII charset
		jr	setout
.isntlower
; **** End of TI86 specific key handling ****
ENDIF


; - **** ALPHA KEY **** - Switch Numeric / Alphanumeric key tables -
		cp	TIALPHAKEY
		jr	nz,no2nd

		ld	a,(KFlag)
		xor	255
		ld	(KFlag),a
		jr	z,KFReset

		ld	hl,TiKeyTab1
		ld	(KTabPointer+1),hl
		jr	KFSet
.KFReset
		ld	hl,TiKeyTab2
		ld	(KTabPointer+1),hl
.KFSet

		xor	a
		jr	setout
.no2nd
; - **** ALPHA KEY **** - END -

.KTabPointer
		ld	hl,TiKeyTab1
.symloop
		cp	(hl)
		jr	z,chfound
		inc	hl
		inc	hl
		push	af
		xor	a
		or	(hl)
		jr	z,isntsym
		pop	af
		jr	symloop
.chfound
		inc	hl
		ld	a,(hl)
		jr	setout
.isntsym
		pop	af

.setout
		ld	l,a
		ld	h,0
		ret
.KFlag
defb	0


; TI82 ROM key handler
;IF FORti82
;	INCLUDE	"stdio/ticalc/ti82tab.inc"
;ENDIF

; CRASH re-written key handler
IF FORti82
	INCLUDE	"stdio/ticalc/ti82crtab.inc"
ENDIF

IF FORti83
	INCLUDE	"stdio/ticalc/ti83tab.inc"
ENDIF

IF FORti83p
	INCLUDE	"stdio/ticalc/ti83tab.inc"
ENDIF

IF FORti85
	INCLUDE	"stdio/ticalc/ti85tab.inc"
ENDIF

IF FORti86
	INCLUDE	"stdio/ticalc/ti86tab.inc"
ENDIF
