;
;       ABC80 Graphics Functions
;
;       xorg ()  -- invert graphics on screen
;
;	routine found in "grafik.asm"
;	by Bengt Holgersson - 1986-03-13 22.58.30
;
;       imported by Stefano Bodrato - 29/12/2006  :o)
;
;
;       $Id: abc_inv.asm,v 1.3 2016-06-11 19:38:47 dom Exp $
;

		SECTION code_clib
		PUBLIC	abc_inv
		PUBLIC	_abc_inv

.abc_inv
._abc_inv
		ld	ix,884
		ld	b,24
.xorloop	push	bc
		ld	l,(ix+0)
		ld	h,(ix+1)
		ld	a,(590)
		ld	b,a
.xorloop1	ld	a,(hl)
		bit	5,a
		jr	z,nograf
		xor	95
		ld	(hl),a
.nograf		inc	hl
		djnz	xorloop1
		inc	ix
		inc	ix
		pop	bc
		djnz	xorloop
		ret
