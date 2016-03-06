/*
 *	Execute a CLI string
 *
 *	Now I've never ever used a CLI but someone out there
 *	might have done...
 *
 *	djm 22/3/2000
 */

#include <z88.h>
#include <string.h>

int exec_cli(char *str)
{
	return (exec_cli_i(str,strlen(str)));
}

int exec_cli_i(char *str, size_t len)
{
#asm
	INCLUDE	"director.def"
	pop	de
	pop	bc
	pop	hl
	push	hl
	push	bc
	push	de
	call_oz(dc_icl)		;preserves ix
	ld	hl,0
	ret	nc
	dec	hl	;-1 - FAIL
#endasm
}





