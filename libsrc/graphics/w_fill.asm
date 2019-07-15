;       Z88DK Small C+ Graphics Functions
;       Fills a screen area
;
;	Generic and simple version, slower and wasting a bit of memory
;
;	$Id: w_fill.asm $
;

	INCLUDE	"graphics/grafix.inc"


		SECTION         code_graphics
        
		PUBLIC	fill
		PUBLIC	_fill
        
		EXTERN	l_graphics_cmp
	
		EXTERN   point
        EXTERN   plot


;ix points to the table on stack (above)

;Entry:
;       hl=x0 de=y0

;fill(int x, int y)
;{
;    if (!point(x,y)) {
;        plot(x, y);
;        fill(x+1, y);
;        fill(x-1, y);
;        fill(x, y+1);
;        fill(x, y-1);
;    }
;}

.fill
._fill
		pop bc
		pop de  ; y
		pop hl  ; x
		push hl
		push de
		push bc
		
		push    hl
		ld      hl,maxy
		call    l_graphics_cmp
		pop     hl
		ret     nc               ; Return if Y overflows

		push    de
		ld      de,maxx
		call    l_graphics_cmp
		pop     de
		ret     c               ; Return if X overflows
		
		push	hl
		push	de
		call	point
		pop		de
		pop		hl
		
		ret		nz
		
		;	-- -- -- -- -- -- -- --
		
		push	hl
		push	de
		call	plot
		pop		de
		pop		hl
		
		inc	hl
		
		push	hl
		push	de
		call	fill
		pop		de
		pop		hl

		dec	hl
		dec	hl
		
		push	hl
		push	de
		call	fill
		pop		de
		pop		hl

		inc	hl
		inc	de
		
		push	hl
		push	de
		call	fill
		pop		de
		pop		hl

		dec	de
		dec	de
		
		push	hl
		push	de
		call	fill
		pop		de
		pop		hl
		
		ret

