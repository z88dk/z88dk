;
;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;	Set the cursor position
;
;	int __CALLEE__ setcursorpos_callee(x,y);
;
;
;	$Id: setcursorpos_callee.asm,v 1.3 2014-09-28 18:26:58 pauloscustodio Exp $
;

XLIB	setcursorpos_callee
XDEF	ASMDISP_SETCURSORPOS_CALLEE


setcursorpos_callee:
	pop  bc
	pop  hl
	pop  de
	push  bc

; enter : l = x
;         e = y

.asmentry
;jr asmentry
	ld h,e
	jp	$201E

DEFC ASMDISP_SETCURSORPOS_CALLEE = # asmentry - setcursorpos_callee
