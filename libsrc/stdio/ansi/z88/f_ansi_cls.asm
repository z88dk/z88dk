;
;	f_ansi_cls
;
;	Clear the screen
;
;	djm 6/6/2000
;
;
;	$Id: f_ansi_cls.asm,v 1.5 2016-04-04 18:31:23 dom Exp $
;

		SECTION code_clib
		PUBLIC	ansi_CLS

		INCLUDE	"stdio.def"

.ansi_CLS
	ld	a,$0c
	call_oz(os_out)
	ret
IF Blah
	ld	hl,clstxt
	call_oz(gn_sop)
	ret

.clstxt
	defb	1,'3','@',32,32,1,'2','C',254,0
ENDIF
