;
;   ABC80 'point' instruction
;	2x3 graphics symbols
;
;	Loosely based on a routine found in "grafik.asm"
;	by Bengt Holgersson - 1986-03-13 22.58.30
;
;       imported by Stefano Bodrato - 29/12/2006  :o)
;
;
;	$Id: pointxy.asm,v 1.4 2016-07-02 09:01:35 dom Exp $
;

			SECTION smc_clib
			PUBLIC	pointxy
			
			EXTERN	__gfx_coords

.pointxy
			ld	d,l
			ld	e,h
			inc	e
			inc	e
			ld	a,e
			
			cp	2
			ret	c

			ld	(__gfx_coords),hl
			
			push	bc
			ld	b,0
			ld	h,b
			ld	c,d
			ld	l,e
			ld	a,(22eeh)
			cp	124
			ld	a,e
			jr	z,old
			call	22ech
			jr	setit
.old			call	22eeh
.setit			jr	c,doret
				and	(hl)	; <-
.doret			pop	bc
			ret
