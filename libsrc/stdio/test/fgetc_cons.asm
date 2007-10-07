;
;	Put character to console
;
;	fputc_cons(char c)
;
;
;	$Id: fgetc_cons.asm,v 1.1 2007-10-07 17:49:34 dom Exp $
;


		XLIB	fgetc_cons

		INCLUDE	"#test_cmds.def"

.fgetc_cons
	ld	a,CMD_READKEY
	rst	8
	ret

