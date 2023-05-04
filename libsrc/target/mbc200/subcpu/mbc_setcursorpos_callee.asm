;
;	mbc-200 specific routines
;	by Stefano Bodrato, 2023
;
;	int __CALLEE__ mbc_setstr_callee(char variable, char *value);
;
;
;	$Id: mbc_setcursorpos_callee.asm $
;

SECTION code_clib
PUBLIC	mbc_setcursorpos_callee
PUBLIC	_mbc_setcursorpos_callee
PUBLIC	asm_mbc_setcursorpos

EXTERN	mbc_sendchar

		

mbc_setcursorpos_callee:
_mbc_setcursorpos_callee:
	pop  bc
	pop  de
	pop  hl
	push  bc

; enter : l = x
;         e = y

.asm_mbc_setcursorpos

	ld d,l

	ld l,27
	call mbc_sendchar
	ld l,'='
	call mbc_sendchar

	; X
	ld a,32
	add e
	ld l,a
	call mbc_sendchar

	; Y
	ld a,32
	add d
	ld l,a
	jp mbc_sendchar

