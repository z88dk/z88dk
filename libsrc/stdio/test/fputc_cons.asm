;
;	Put character to console
;
;	fputc_cons(char c)
;
;
;	$Id: fputc_cons.asm,v 1.6 2016-05-15 20:15:46 dom Exp $
;

                SECTION code_clib
		PUBLIC	fputc_cons_native
		PUBLIC	_fputc_cons

		INCLUDE	"test_cmds.def"

.fputc_cons_native
	ld	hl,2
	add	hl,sp
	ld	l,(hl)
	ld	h,0
	ld	a,CMD_PRINTCHAR
	rst	8
	ret

