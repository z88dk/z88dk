;
;	TI86 Routines
;
;	fgetc_cons() Wait for keypress
;
;	Stefano Bodrato - 9/5/2000
;
;

		XLIB	fgetc_cons

.fgetc_cons
		halt		; Power saving
		call	$55AA	; get key

		cp	6	; was it ENTER ?
		jr	nz,noenter
		ld	a,13
		jr	setout
.noenter

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

		ld	hl,TiKeyTab
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


.TiKeyTab


defb	1	;kRight
defb	9
defb	2	;kLeft
defb	8
defb	3	;kUp
defb	11
defb	4	;kDown
defb	10

;kClear	equ	008h
;kDel	equ	009h
;kIns	equ	00Ah
;kNext	equ	00Bh

defb	5
defb	':'
defb	6
defb	13	; ENTER
defb	7	; EXIT..
defb	27	; ..mapped to ESC
defb	$0C
defb	'+'
defb	$0D
defb	'-'
defb	$0E
defb	'*'
defb	$0F
defb	'/'
defb	$10
defb	'^'
defb	$11
defb	'('
defb	$12
defb	')'
defb	$13
defb	'['
defb	$14
defb	']'
defb	$15
defb	'='
defb	$18
defb	','
defb	$1B
defb	'.'
defb	$27
defb	' '

;kCapA	equ	028h
;..
;kCapZ	equ	041h
;ka	equ	042h
;..
;kz	equ	05Bh

;kStore	equ	016h
;kRecall	equ	017h
;kAng	equ	019h
;kChs	equ	01Ah
;kEE	equ	026h
;kVarx	equ	05Ch
;kAns	equ	05Dh
;kPi	equ	05Eh
;kInv	equ	05Fh
;kSin	equ	060h
;kASin	equ	061h
;kCos	equ	062h
;kACos	equ	063h
;kTan	equ	064h
;kATan	equ	065h
;kSquare	equ	066h
;kSqrt	equ	067h
;kLn	equ	068h
;kExp	equ	069h
;kLog	equ	06Ah
;kALog	equ	06Bh
;kMath	equ	06Ch
;kCplx	equ	06Dh
;kString	equ	06Eh
;kTest	equ	06Fh
;kConv	equ	070h
;kChar	equ	071h
;kBase	equ	072h
;kCustom	equ	073h
;kVars	equ	074h
;kCatalog	equ	075h
;kQuit	equ	076h
;kLastEnt	equ	077h
;kLinkIO	equ	078h
;kMem	equ	079h
;kList	equ	07Ah
;kVector	equ	07Bh
;kConst	equ	07Ch
;kMatrix	equ	07Dh
;kPoly	equ	07Eh
;kSimult	equ	07Fh
;kStat	equ	080h
;kGrMenu	equ	081h
;kMode	equ	082h
;kPrgm	equ	083h
;kCalcu	equ	084h
;kSolver	equ	085h
;kTable	equ	086h		; new key added for LEO
;kBOL	equ	087h
;kEOL	equ	088h
;kCUSTM	equ	093h
;kF1	equ	0C2h
;..
;kF10    equ     0CBh
;kGRAPH	equ	0FFh

defb	0
