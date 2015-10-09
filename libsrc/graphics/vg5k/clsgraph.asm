;
;       Philips VG-5000 Graphics Functions
;
;       cls ()  -- clear screen
;
;       Stefano Bodrato - Oct 2015
;
;
;       $Id: clsgraph.asm,v 1.1 2015-10-09 13:02:42 stefano Exp $
;


        PUBLIC    cleargraphics
		EXTERN	base_graphics

.cleargraphics
;	ld d,' '
;	ld e,7 ; white on black
	
	ld h,25+6
.loop2
	ld l,40
.loop1
	push  hl
	ld de,128+32+64+16+64*256
	dec l
	call  92h
	pop   hl
	dec l
	jr  nz,loop1
	dec h
	ld  a,h
	cp  7
	jr  nz,loop2
	ld h,0
	ld l,40
.loop3
	push  hl
	ld de,128+32+64+16+64*256
	dec l
	call  92h
	pop   hl
	dec l
	jr  nz,loop3
	
	ret
