
#include <fcntl.h>

int mkdir(char *name) __naked
{
#asm
	EXTERN	asm_esxdos_f_mkdir
	pop	bc
	pop	hl
	push	hl
	push	bc
	push	ix
	call	asm_esxdos_f_mkdir
	pop	ix
	ret
#endasm
}
