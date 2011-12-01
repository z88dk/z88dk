;
;	ZX 81 specific routines
;	by Stefano Bodrato, Oct 2007
;
;	Copy a string to a BASIC variable
;
;	int __CALLEE__ zx_setstr_callee(char variable, char *value);
;
;
;	$Id: zx_setcursorpos_callee.asm,v 1.1 2011-12-01 17:46:45 stefano Exp $
;

XLIB	zx_setcursorpos_callee
XDEF	ASMDISP_ZX_SETCURSORPOS_CALLEE

LIB     zx_dfile_addr
LIB     zx_coord_adj

DEFC    COLUMN=$4039    ; S_POSN_x


zx_setcursorpos_callee:

	pop   bc
	pop   hl
	pop   de
	push  bc

; enter : l = y
;         e = x

.asmentry
	ld d,l
	ld (COLUMN),de
	call zx_coord_adj
	jp zx_dfile_addr


DEFC ASMDISP_ZX_SETCURSORPOS_CALLEE = asmentry - zx_setcursorpos_callee
