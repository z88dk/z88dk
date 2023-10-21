;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: dlt.asm,v 1.4 2016-06-22 19:50:49 dom Exp $
;

        SECTION smc_fp
        INCLUDE "cpcmath.inc"

        PUBLIC  dlt
        PUBLIC  dltc

        EXTERN  fsetup
        EXTERN  stkequcmp
        EXTERN  cmpfin

dlt:
        call    fsetup
dltc:
        FPCALL  (CPCFP_FLO_CMP)
        cp      $FF                     ;(hl) < (de)
        jp      z, cmpfin
        xor     a
        jp      stkequcmp

