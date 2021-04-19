
MODULE  esx_rmdir
SECTION code_esxdos
EXTERN  asm_esxdos_f_rmdir
PUBLIC  rmdir
PUBLIC  _rmdir

;int rmdir(const char *name) __naked
rmdir:
_rmdir:
	pop	bc
	pop	hl
	push	hl
	push	bc
	push	ix
	call	asm_esxdos_f_rmdir
	pop	ix
	ret
