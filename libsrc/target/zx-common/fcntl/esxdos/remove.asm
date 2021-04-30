
MODULE  esx_remove
SECTION code_esxdos
EXTERN  asm_esxdos_f_unlink
PUBLIC  remove
PUBLIC  _remove

;int remove(char *name) __naked
remove:
_remove:
	pop	bc
	pop	hl
	push	hl
	push	bc
	push	ix
	ld	a,'*'
	call	asm_esxdos_f_unlink
	pop	ix
	ret
