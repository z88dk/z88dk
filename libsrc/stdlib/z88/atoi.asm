;
;	Machine code atoi for z88
;
;	djm 25/4/2000
;
;	int atoi(char *);
;
; -----
; $Id: atoi.asm,v 1.3 2001-04-18 12:43:04 stefano Exp $


		INCLUDE	"#integer.def"

		XLIB	atoi

.atoi
	pop	bc
	pop	hl	;string
	push	hl
	push	bc
	ld	de,2	;reutn in bc
	ld	b,254	;well, ya never know where it is!
	call_oz(gn_gdn)
	ld	l,c
	ld	h,b
	ret	z	;was a number
	ld	hl,0
	ret

