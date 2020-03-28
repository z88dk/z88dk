;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: cmpfin.asm,v 1.4 2016-06-22 19:50:48 dom Exp $
;

                SECTION         smc_fp
		INCLUDE		"target/cpc/def/cpcfp.def"

		PUBLIC		cmpfin

		EXTERN		stkequcmp


.cmpfin		ld	a,1
		jp	stkequcmp
