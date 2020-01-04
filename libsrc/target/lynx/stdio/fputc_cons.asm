;
;       Camputers Lynx C Library
;
;	Print character to the screen
;
;       Stefano Bodrato - 2014
;
;
;	$Id: fputc_cons.asm,v 1.4 2016-05-15 20:15:45 dom Exp $
;

	  SECTION code_clib
          PUBLIC  fputc_cons_native


.fputc_cons_native
	ld  hl,2
	add hl,sp
	ld  a,(hl)
	cp  12
	jr  nz,nocls
	ld  hl,$6255
	ld  a,5	; reset vert. cursor position
	ld  (hl),a
	ld  a,3 ; reset horiz. cursor position
	dec hl
	ld (hl),a

;	ld  e,10
;	call setscroll

;	ld  bc,$86
;	ld  a,12
;	out (c),a
;	inc bc
;	ld  a,1
;	out (c),a

	jp  $8e5
.nocls
IF STANDARDESCAPECHARS
	cp	13
	ret	z
	cp	10
	jr	nz,setout
	ld	a,13
ENDIF

.setout
;	ld  hl,$6255
;	push af
;	ld	a,(hl)
;	ld	e,a
;	pop af
;	push hl
;	push de
	rst 8
;	pop de
;	pop hl
;	ld	a,e
;	ld	a,(hl)
;	cp  e
;	ret nc
;	ld  a,e
;	ld  (hl),a

	
;	ld  bc,$86
;	ld  a,12
;	out (c),a
;	inc bc
;	ld  a,1
;	out (c),a
	
;	ld  e,0
;	call setscroll

		
	ret

;.setscroll
;	ld  a,13
;	dec bc
;	out  (c),a
;	ld  a,24
;	sub e
;	push af
;	rrca
;	rrca
;    and @11000000
;	inc bc
;	out (c),a
;	ld  a,12
;	dec bc
;	out (c),a
;	pop af
;	rrca
;	rrca
;    and @00000111
;	inc bc
;	out (c),a
;	ret

