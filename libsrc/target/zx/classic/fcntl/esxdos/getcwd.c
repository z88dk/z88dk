
#include <fcntl.h>

char *getcwd(char *buf, size_t buflen) __naked
{
#asm
	EXTERN	asm_esxdos_f_getcwd
	pop	bc
	pop	de	;buflen, ignored
	pop	hl	;buf
	push	hl
	push	de
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
