;
;	ZX 81 specific routines
;	by Stefano Bodrato, Oct 2007
;
;	Copy a string to a BASIC variable
;
;	int __CALLEE__ zx_setstr_callee(char variable, char *value);
;
;
;	$Id: zx_setcursorpos_callee.asm,v 1.7 2015-08-07 06:23:58 stefano Exp $
;

PUBLIC	zx_setcursorpos_callee
PUBLIC	ASMDISP_ZX_SETCURSORPOS_CALLEE

EXTERN     zx_dfile_addr
EXTERN     zx_coord_adj

IF FORzx80
	DEFC   COLUMN=$4024    ; S_POSN_x
ELSE
	DEFC   COLUMN=$4039    ; S_POSN_x
ENDIF


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


DEFC ASMDISP_ZX_SETCURSORPOS_CALLEE = # asmentry - zx_setcursorpos_callee
