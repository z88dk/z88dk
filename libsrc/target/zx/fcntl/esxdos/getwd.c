
#include <fcntl.h>

char *getwd(char *buf) __naked
{
#asm
	EXTERN	asm_esxdos_f_getcwd
	pop	bc
	pop	hl	;buf
	push	hl
	push	bc
	push	hl	;save buffer for return value
	push	ix	;save ix
	ld	a,'*'	;current drive
	call	asm_esxdos_f_getcwd
	pop	hl	;return value
	pop	ix
	ret
#endasm
}
