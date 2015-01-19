;
;	Put character to console
;
;	fputc_cons(char c)
;
;
;	$Id: fgetc_cons.asm,v 1.3 2015-01-19 01:33:21 pauloscustodio Exp $
;


		PUBLIC	fgetc_cons

		INCLUDE	"test_cmds.def"

.fgetc_cons
	ld	a,CMD_READKEY
	rst	8
	ret

