;
;	ZX 81 specific routines
;	by Stefano Bodrato, Oct 2007
;
;	Copy a string to a BASIC variable
;
;	int __CALLEE__ zx_setstr_callee(char variable, char *value);
;
;
;	$Id: zx_setcursorpos_callee.asm,v 1.3 2012-01-09 16:02:36 stefano Exp $
;

XLIB	zx_setcursorpos_callee
XDEF	ASMDISP_ZX_SETCURSORPOS_CALLEE

LIB     zx_dfile_addr
LIB     zx_coord_adj

DEFC    COLUMN=$4039    ; S_POSN_x


zx_setcursorpos_callee:
	pop  bc
	pop  de
	pop  hl
	push  bc

; enter : l = x
;         e = y

.asmentry
;jr asmentry
	ld d,l
	ld (COLUMN),de
	call zx_coord_adj
	jp zx_dfile_addr


DEFC ASMDISP_ZX_SETCURSORPOS_CALLEE = asmentry - zx_setcursorpos_callee
