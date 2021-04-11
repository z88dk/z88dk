;
;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;	Set the cursor position
;
;	int __CALLEE__ setcursorpos_callee(x,y);
;
;
;	$Id: setcursorpos_callee.asm,v 1.5 2016-06-19 20:58:00 dom Exp $
;

SECTION   code_clib
PUBLIC	setcursorpos_callee
PUBLIC	_setcursorpos_callee
PUBLIC	asm_setcursorpos


setcursorpos_callee:
_setcursorpos_callee:
	pop  bc
	pop  hl
	pop  de
	push  bc

; enter : l = x
;         e = y

.asm_setcursorpos
;jr asmentry
	ld h,e
	jp	$201E

