
        SECTION code_graphics
        PUBLIC    w_cplotpixel

                EXTERN     w_plotpixel
                EXTERN     w_respixel
				EXTERN    __gfx_color

;
;       $Id: w_cplotpixl.asm $
;

; ******************************************************************
;
; Plot pixel at (x,y) coordinate in the given color .
;
; Wide resolution (WORD based parameters) version by Stefano Bodrato
;
;
; in:  hl,de    = (x,y) coordinate of pixel
;          c    = color
;
; registers changed after return:
;  ......../ixiy same
;  afbcdehl/.... different
;
.w_cplotpixel
				ld	a,(__gfx_color)
				bit 2,a
				push	hl
				push	de
				push	af
				jr      z,nogreen
				call    w_plotpixel
				jr      gdone
.nogreen
				call    w_respixel
.gdone
				pop af
				pop	de
				pop	hl
				
				out ($5d),a		; red page
				
				bit 1,a
				push	hl
				push	de
				push	af
				jr      z,nored
				call    w_plotpixel
				jr      rdone
.nored
				call    w_respixel
.rdone
				pop af
				pop	de
				pop	hl
				
				out ($5c),a		; red page
				
				rra
				jr      nc,noblue
				call    w_plotpixel
				jr      bdone
.noblue
				call    w_respixel
.bdone
				out ($5d),a		; back to green page
				ret

