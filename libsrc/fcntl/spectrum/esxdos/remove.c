
#include <fcntl.h>

int remove(char *name) __naked
{
#asm
	EXTERN	asm_esxdos_f_unlink
	pop	bc
	pop	hl
	push	hl
	push	bc
	push	ix
	ld	a,'*'
	call	asm_esxdos_f_unlink
	pop	ix
	ret
#endasm
}
