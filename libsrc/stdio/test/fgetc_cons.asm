;
;	Put character to console
;
;	fputc_cons(char c)
;
;
;	$Id: fgetc_cons.asm,v 1.2 2009-06-22 21:44:17 dom Exp $
;


		XLIB	fgetc_cons

		INCLUDE	"test_cmds.def"

.fgetc_cons
	ld	a,CMD_READKEY
	rst	8
	ret

