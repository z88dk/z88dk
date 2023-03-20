;
;	MSX extension for "GFX - a small graphics library" by Jannone
;

;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       MSX buffered display extension
;	compatibility layer for "GFX",
;	 a small graphics library by Rafael de Oliveira Jannone
;
;	Stefano Bodrato - 27/02/2009
;
;
;	$Id: surface_draw.asm,v 1.8 2017-01-02 22:57:58 aralbrec Exp $
;

		SECTION	  code_video_vdp
                PUBLIC    surface_draw
                PUBLIC    _surface_draw
                
                EXTERN     swapgfxbk
                ;EXTERN    swapgfxbk1
				
		EXTERN __graphics_end
                
		EXTERN	base_graphics

                EXTERN     Line
                EXTERN     surface_plotpixel

; #define surface_line(s,x1,y1,x2,y2) surface_draw(s,x1,y1,x2,y2)
; void surface_draw(surface_t *s, int x1, int y1, int x2, int y2);

.surface_draw
._surface_draw
		push	ix	;save callers
		ld	ix,0
		add	ix,sp

		ld	l,(ix+12)	; surface struct
		ld	h,(ix+13)
		ld	de,6		; shift to screen buffer ptr
		add	hl,de
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		ld	(base_graphics),de

		ld	l,(ix+8)	;y0
		ld	h,(ix+10)	;x0
		ld	e,(ix+4)	;y1
		ld	d,(ix+6)	;x1
		call    swapgfxbk
		push	hl
		push    de
		call	surface_plotpixel
		pop     de
		pop	hl
                ld      ix,surface_plotpixel
                call    Line
                ;jp      swapgfxbk1
				
		jp	__graphics_end
		;pop	ix	;restore callers
        ;        ret
