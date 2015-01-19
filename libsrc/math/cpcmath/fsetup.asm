;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: fsetup.asm,v 1.3 2015-01-19 01:32:56 pauloscustodio Exp $
;

		INCLUDE		"cpcfp.def"

		PUBLIC		fsetup

		EXTERN		fa

.fsetup
		ld      hl,fa+1			; de=fa+1
		ex      de,hl
		ld      hl,5
		add     hl,sp			; hl=sp+5
		ret


