;
; 	ANSI Video handling for the SHARP MZ
;
;	set it up with:
;	.text_cols	= max columns
;	.text_rows	= max rows
;
;	Display a char in location (ansi_ROW),(ansi_COLUMN)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm,v 1.6 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_CHAR
	
	PUBLIC	text_cols
	PUBLIC	text_rows

	EXTERN	ansi_ROW
	EXTERN	ansi_COLUMN

	EXTERN	current_attr
	

.text_cols   defb 40
.text_rows   defb 25

; 0=space
; 1=A..Z
; 128=a..z
; 32=0..9
; 96=!..

.ansi_CHAR


.nospace
	cp	48	; Between 0 and 9 ?
	jr	c,isntnum
	cp	58
	jr	nc,isntnum
	sub	16	; Ok, re-code to the Sharp Display set
	jr	setout	; .. and put it out
.isntnum
	cp	97	; Between a and z ?
	jr	c,isntlower
	cp	123
	jr	nc,isntlower
	add	a,32
	jr	setout
.isntlower
	cp	65	; Between A and Z ?
	jr	c,isntchar
	cp	91
	jr	nc,isntchar
	sub	64
	jr	setout
.isntchar
	;add	a,63 ; For now...
	
	ld	hl,chmap
.maploop
	ld	e,a
	ld	a,(hl)
	and	a
	ret	z	; We don't display the character since it isn't mapped
	ld	a,e
	cp	(hl)
	inc	hl
	jr	z,chfound
	inc	hl
	jr	maploop
.chfound
	ld	a,(hl)
	
.setout
	push	af
	ld	hl,$D000
	ld	a,(ansi_ROW)
	and	a
	jr	z,r_zero
	ld	b,a
	ld	de,40
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
	
	ld	a,8	; Set the character color
	add	a,h
	ld	h,a
	ld	a,(current_attr)
	ld	(hl),a
	
	ret

.chmap
	defb	' ',0
	defb	'£',$1b
	defb	'-',$2a
	defb	'=',$2b
	defb	';',$2c
	defb	'/',$2d
	defb	'.',$2e
	defb	',',$2f
	defb	'_',$3c
	defb	'?',$49
	defb	':',$4f
	defb	'}',$40
	defb	'^',$50
	defb	'<',$51
	defb	'[',$52
	defb	']',$54
	defb	'@',$55
	defb	'>',$57
	defb	'\\',$59
	defb	'!',$61
	defb	'"',$62
	defb	'#',$63
	defb	'$',$64
	defb	'%',$65
	defb	'&',$66
	defb	39,$67
	defb	96,$67
	defb	'(',$68
	defb	')',$69
	defb	'+',$6a
	defb	'*',$6b
	defb	'|',$79
	defb	0
	
