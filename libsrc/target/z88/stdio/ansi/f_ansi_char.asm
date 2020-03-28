;
;	Print a character at __console_y, __console_xUMN
;	Enter with char in a
;
;	djm 6/6/2000
;
;	This ain't pretty..we do far too many calls to oz for my liking..
;
;
;	$Id: f_ansi_char.asm,v 1.7 2016-07-02 10:24:35 dom Exp $
;

		SECTION	code_clib
		PUBLIC ansi_CHAR

		INCLUDE	"stdio.def"

		EXTERN __console_y
		EXTERN __console_x



.ansi_CHAR
	push	af
	ld	hl,start
	call_oz(gn_sop)
	ld	a,(__console_x)
	add	a,32
	call_oz(os_out)
	ld	a,(__console_y)
	add	a,32
	call_oz(os_out)
	pop	af
	call_oz(os_out)
	ret
.start
	defb	1,'3','@',0


