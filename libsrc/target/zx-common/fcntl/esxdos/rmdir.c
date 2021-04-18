
#include <fcntl.h>

int rmdir(const char *name) __naked
{
#asm
	EXTERN	asm_esxdos_f_rmdir
	pop	bc
	pop	hl
	push	hl
	push	bc
	push	ix
	call	asm_esxdos_f_rmdir
	pop	ix
	ret
#endasm
}
