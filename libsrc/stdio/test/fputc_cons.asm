;
;	Put character to console
;
;	fputc_cons(char c)
;
;
;	$Id: fputc_cons.asm,v 1.5 2016-05-12 21:42:05 dom Exp $
;

                SECTION code_clib
		PUBLIC	fputc_cons
		PUBLIC	_fputc_cons

		INCLUDE	"test_cmds.def"

.fputc_cons
._fputc_cons
	ld	hl,2
	add	hl,sp
	ld	l,(hl)
	ld	h,0
	ld	a,CMD_PRINTCHAR
	rst	8
	ret

