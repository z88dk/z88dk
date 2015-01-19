;
;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;	Set the cursor position
;
;	int __CALLEE__ screen_callee(x,y);
;
;
;	$Id: screen_callee\040.asm,v 1.4 2015-01-19 01:33:07 pauloscustodio Exp $
;


PUBLIC	screen_callee
PUBLIC	ASMDISP_screen_CALLEE


screen_callee:
	pop  bc
	pop  de
	pop  hl
	push  bc

; enter : l = x
;         e = y

.asmentry
;jr asmentry
	ld h,e
	call	$201B
	ld	h,0
	ld	l,a
	ret

DEFC ASMDISP_screen_CALLEE = # asmentry - screen_callee
