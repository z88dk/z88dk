;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: int_inv_sgn.asm,v 1.4 2016-06-22 19:50:49 dom Exp $
;

                SECTION         code_fp
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

		
