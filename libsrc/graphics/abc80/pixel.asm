;
;       Generic pseudo graphics routines for text-only platforms
;	Version for the 2x3 graphics symbols
;
;	routine found in "grafik.asm"
;	by Bengt Holgersson - 1986-03-13 22.58.30
;
;       imported by Stefano Bodrato - 29/12/2006  :o)
;
;
;       Plot/unplot/invert pixel at (x,y) coordinate.
;
;
;	$Id: pixel.asm,v 1.3 2015-01-19 01:32:45 pauloscustodio Exp $
;


			PUBLIC	pixel
			
			PUBLIC	pixmode

			EXTERN	coords

.pixel
			ld	d,l
			ld	e,h
			inc	e
			inc	e
			ld	a,e
			
			cp	2
			ret	c

			ld	(coords),hl
			
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
.pixmode		or	(hl)	; <-
			nop
			or	32
			ld	(hl),a
.doret			pop	bc
			ret
