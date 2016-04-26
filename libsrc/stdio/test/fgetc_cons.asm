;
;	Put character to console
;
;	fputc_cons(char c)
;
;
;	$Id: fgetc_cons.asm,v 1.4 2016-04-26 20:16:40 dom Exp $
;

		SECTION code_clib
		PUBLIC	fgetc_cons

		INCLUDE	"test_cmds.def"

.fgetc_cons
	ld	a,CMD_READKEY
	rst	8
	ret

