;
;	f_ansi_cls
;
;	Clear the screen
;
;	djm 6/6/2000
;
;
;	$Id: f_ansi_cls.asm,v 1.6 2016-07-02 10:24:35 dom Exp $
;

		SECTION code_clib
		PUBLIC	ansi_cls

		INCLUDE	"stdio.def"

.ansi_cls
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
