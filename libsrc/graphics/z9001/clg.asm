;
;       Fast CLS for the Robotron Z9001
;       Stefano - Sept 2016
;
;
;	$Id: clg.asm,v 1.2 2017-01-02 22:57:59 aralbrec Exp $
;

		SECTION code_clib
                PUBLIC    clg
                PUBLIC    _clg

.clg
._clg
		ld	hl,0
		ld	d,h
		ld	e,h
		add	hl,sp

		ld	b,8
		ld	a,@00001000		; GFX mode bit
.g_gcls1
		out	($B8), a
		ld	sp,$ec00+960
		
		ld	b,30		; 30*16*2 = 960 bytes bank
.clgloop
		push	de
		push	de
		push	de
		push	de

		push	de
		push	de
		push	de
		push	de

		push	de
		push	de
		push	de
		push	de

		push	de
		push	de
		push	de
		push	de
		djnz	clgloop
		
		inc	a
		cp	16
		jr nz,g_gcls1

		ld	sp,$e800+960	; color attributes
		ld	b,40		; 40*12*2 = 960 bytes
		ld	a,7
		ld	($0027),a	; ATRIB - current color attribute
		ld	d,a
		ld	e,a
.attrloop
		push	de
		push	de
		push	de
		push	de

		push	de
		push	de
		push	de
		push	de

		push	de
		push	de
		push	de
		push	de
		djnz	attrloop

		ld	sp,hl
		ret
