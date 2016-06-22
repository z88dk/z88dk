;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: fsetup.asm,v 1.4 2016-06-22 19:50:49 dom Exp $
;

                SECTION         code_fp
		INCLUDE		"cpcfp.def"

		PUBLIC		fsetup

		EXTERN		fa

.fsetup
		ld      hl,fa+1			; de=fa+1
		ex      de,hl
		ld      hl,5
		add     hl,sp			; hl=sp+5
		ret


