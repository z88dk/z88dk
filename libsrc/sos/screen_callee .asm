;
;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;	Set the cursor position
;
;	int __CALLEE__ screen_callee(x,y);
;
;
;	$Id: screen_callee\040.asm,v 1.5 2016-06-19 20:58:00 dom Exp $
;

        SECTION   code_clib
PUBLIC	screen_callee
PUBLIC	_screen_callee
PUBLIC	ASMDISP_screen_CALLEE


screen_callee:
_screen_callee:
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
