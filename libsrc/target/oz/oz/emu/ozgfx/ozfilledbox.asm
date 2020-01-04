;
;	OZ-7xx DK emulation layer for Z88DK
;	by Stefano Bodrato - Oct. 2003
;
;	void ozfilledbox(int x, int y, int width, int height);
;
; ------
; $Id: ozfilledbox.asm,v 1.3 2016-06-28 14:48:17 dom Exp $
;

	SECTION code_clib
	PUBLIC	ozfilledbox
	PUBLIC	_ozfilledbox

        EXTERN     swapgfxbk
        EXTERN     __oz_gfxend

        EXTERN     drawbox
        EXTERN     ozplotpixel
        
        EXTERN	ozpointcolor



.ozfilledbox
._ozfilledbox
		push	ix	;save callers
		ld	ix,2
		add	ix,sp
		call	ozpointcolor

		ld	c,(ix+4)	; height
		ld	b,(ix+6)	; width
		ld	l,(ix+8)	; y
		ld	h,(ix+10)	; x
                ld      ix,ozplotpixel
                call    swapgfxbk


		ld	a,c
		ld	c,h	; BC - >  horizontal parameters
		
		ld	h,a
		
.bloop2

		push	bc
.bloop1
		push	hl
		ld	a,b
		add	c
		ld	h,a
		ld	de, plot_RET
		push	de
		jp	(ix)
.plot_RET
		pop	hl
		djnz	bloop1

		pop	bc
		inc	l
		dec	h
		jr	nz,bloop2
		
                jp      __oz_gfxend
