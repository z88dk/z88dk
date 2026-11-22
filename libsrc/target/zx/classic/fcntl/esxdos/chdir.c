
#include <fcntl.h>

int chdir(char *name) __naked
{
#asm
	EXTERN	asm_esxdos_f_chdir
	pop	bc
	pop	hl
	push	hl
	push	bc
	push	ix
	ld	a,'*'
	call	asm_esxdos_f_chdir
	pop	ix
	ret
#endasm
}
