;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: minusfa.asm,v 1.4 2016-06-22 19:50:49 dom Exp $
;

        SECTION smc_fp
        INCLUDE "cpcmath.inc"

        PUBLIC  minusfa
        PUBLIC  minusfac

        EXTERN  fa

minusfa:
        ld      hl, fa+1
minusfac:
        FPCALL  (CPCFP_FLO_INV_SGN)
        ret
