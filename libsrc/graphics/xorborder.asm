
	SECTION code_graphics
	
	PUBLIC	xorborder
	PUBLIC   _xorborder
	
	EXTERN    xorborder_callee
	EXTERN    ASMDISP_XORBORDER_CALLEE
		
;
;	$Id: xorborder.asm $
;

; ***********************************************************************
;
; XORs a dotted box.  Useful for GUIs.
; Generic version
;
; Stefano Bodrato - March 2002
;
;
; IN:	HL	= (x,y)
;	BC	= (width,heigth)
;

.xorborder
._xorborder
		push	ix
		
		ld	ix,2
		add	ix,sp
		ld	c,(ix+2)
		ld	b,(ix+4)
		ld	l,(ix+6)
		ld	h,(ix+8)
		
		pop ix

   jp xorborder_callee + ASMDISP_XORBORDER_CALLEE
