;
;	Put character to console
;
;	fputc_cons(char c)
;
;
;	$Id: fputc_cons.asm,v 1.4 2016-04-26 20:16:40 dom Exp $
;

                SECTION code_clib
		PUBLIC	fputc_cons

		INCLUDE	"test_cmds.def"

.fputc_cons
	ld	hl,2
	add	hl,sp
	ld	l,(hl)
	ld	h,0
	ld	a,CMD_PRINTCHAR
	rst	8
	ret

