;
; 	ANSI Video handling for the ZX81
;	By Stefano Bodrato - Apr. 2000
;
;	set it up with:
;	.text_cols	= max columns
;	.text_rows	= max rows
;
;	Display a char in location (ansi_ROW),(ansi_COLUMN)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm,v 1.2 2001-04-13 14:13:59 stefano Exp $
;

	XLIB	ansi_CHAR
	
	XDEF	text_cols
	XDEF	text_rows

	XREF	ansi_ROW
	XREF	ansi_COLUMN
	
	XREF	zx_inverse

.text_cols   defb 32
.text_rows   defb 24


.ansi_CHAR
	cp	48	; Between 0 and 9 ?
	jr	c,isntnum
	cp	58
	jr	nc,isntnum
	add	a,108	; Ok, re-code to the ZX81 charset
	jr	setout	; .. and put it out
.isntnum
	cp	97	; Between a and z ?
	jr	c,isntlower
	cp	123
	jr	nc,isntlower
	sub	32	; Then transform in UPPER !
.isntlower
	cp	65	; Between A and Z ?
	jr	c,isntchar
	cp	91
	jr	nc,isntchar
	add	a,101	; Ok, re-code to the ZX81 charset
	jr	setout	; .. and put it out
.isntchar
	ld	hl,cnvtab
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
	ld	a,128	; Else (space, exclamation mark, ..), blank.

.setout
	ld	hl,zx_inverse
	sub	(hl)

	push	af
	ld	hl,(16396)
	inc	hl
	ld	a,(ansi_ROW)
	and	a
	jr	z,r_zero
	ld	b,a
	ld	de,33	; 32+1. Every text line ends with an HALT
.r_loop
	add	hl,de
	djnz	r_loop
.r_zero
	ld	a,(ansi_COLUMN)
	ld	d,0
	ld	e,a
	add	hl,de
	pop	af
	ld	(hl),a
	ret

.cnvtab
	defb	'"'
	defb	139
	defb	'£'
	defb	140
	defb	'$'
	defb	141
	defb	':'
	defb	142
	defb	'?'
	defb	143
	defb	'('
	defb	144
	defb	')'
	defb	145
	defb	'>'
	defb	146
	defb	'<'
	defb	147
	defb	'='
	defb	148
	defb	'+'
	defb	149
	defb	'-'
	defb	150
	defb	'*'
	defb	151
	defb	'/'
	defb	152
	defb	';'
	defb	153
	defb	','
	defb	154
	defb	'.'
	defb	155
	defb	'!'
	defb	151 ; * stands for !
	defb	'{'
	defb	147 ; <
	defb	'}'
	defb	146 ; >
	defb	'@'
	defb	137
	defb	'#'
	defb	8
	defb	'&'
	defb	130
	defb	'%'
	defb	6
	defb	'~'
	defb	139
	defb	'['
	defb	133
	defb	']'
	defb	5
	defb	'_'
	defb	131
	defb	39 ;"'"
	defb	129
			
	defb	0
	