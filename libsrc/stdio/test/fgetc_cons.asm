;
;	Put character to console
;
;	fputc_cons(char c)
;
;
;	$Id: fgetc_cons.asm,v 1.5 2016-05-12 21:42:05 dom Exp $
;

		SECTION code_clib
		PUBLIC	fgetc_cons
		PUBLIC	_fgetc_cons

		INCLUDE	"test_cmds.def"

.fgetc_cons
._fgetc_cons
	ld	a,CMD_READKEY
	rst	8
	ret

