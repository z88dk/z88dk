;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       PX8 variant by Stefano Bodrato
;
;
;	$Id: draw.asm - Stefano, 2017 $
;


		SECTION         code_clib
		
		PUBLIC    draw
		PUBLIC	  _draw
		
		PUBLIC	  do_draw
		PUBLIC    draw_mode
		
        EXTERN    __gfx_coords
		
        EXTERN    px8_conout


.draw
._draw
		ld	a,2	; set pixel
		ld	(draw_mode+1),a
.do_draw
		ld	c,27		; ESCape
		call px8_conout
		
		ld	c,0xc6		; DOT LINE WRITE
		call px8_conout

		push	ix
		ld      ix,2
		add     ix,sp

		ld      c,(ix+9)	;x0 H
		call px8_conout
		ld      c,(ix+8)	;x0 L
		call px8_conout
		
		ld      c,(ix+7)	;y0 H
		call px8_conout
		ld      c,(ix+6)	;y0 L
		call px8_conout
		
		ld      c,(ix+5)	;x1 H
		call px8_conout
		ld      c,(ix+4)	;x1 L
		call px8_conout

		ld      c,(ix+3)	;y1 H
		call px8_conout
		ld      c,(ix+2)	;y1 L
		call px8_conout

		ld	c,255			; dot pattern mask 1
		call px8_conout		; dot pattern mask 2
		ld	c,255
		call px8_conout

.draw_mode
		ld	c,2		; SET (1=reset, 3=complement)
		call px8_conout

		ld      h,(ix+5)	;x1 H
		ld      l,(ix+4)	;x1 L
		ld      (__gfx_coords),hl     ; store X
		ld      h,(ix+3)	;y1 H
		ld      l,(ix+2)	;y1 L
		ld      (__gfx_coords+2),hl   ; store Y: COORDS must be 2 bytes wider

		pop ix
		ret

