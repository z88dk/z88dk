
MODULE   esx_fdtell           
SECTION   code_esxdos

PUBLIC    fdtell
PUBLIC    _fdtell

EXTERN	asm_esxdos_f_fgetpos

;long fdtell(int fd)

.fdtell
._fdtell
	pop	bc	;ret
	pop	hl	;fd
	push	hl
	push	bc
	push	ix	;callers
	call	asm_esxdos_f_fgetpos
	pop	ix
	ret	nc
        ld      hl,65535
        ld      d,h
        ld      e,l
        ret
