;
;	Put character to console
;
;	fputc_cons(char c)
;
;
;	$Id: fputc_cons.asm,v 1.3 2015-01-19 01:33:21 pauloscustodio Exp $
;


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

