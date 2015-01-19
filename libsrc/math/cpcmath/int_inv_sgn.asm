;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: int_inv_sgn.asm,v 1.3 2015-01-19 01:32:56 pauloscustodio Exp $
;

		INCLUDE		"cpcfp.def"

		PUBLIC		int_inv_sgn


.int_inv_sgn
		xor     a
		sub     l
		ld      l,a
		sbc     a,h
		sub     l
		cp      h
		ld      h,a
		scf
		ret     nz
		cp      1
		ret

		
