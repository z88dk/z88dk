;
;       Philips VG-5000 Graphics Functions
;
;       cls ()  -- clear screen
;
;       Stefano Bodrato - Oct 2015
;
;
;       $Id: clsgraph.asm,v 1.3 2017-01-02 22:57:59 aralbrec Exp $
;

        SECTION code_clib
        PUBLIC    cleargraphics
        PUBLIC    _cleargraphics
	EXTERN	base_graphics

.cleargraphics
._cleargraphics
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
