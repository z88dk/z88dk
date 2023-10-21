;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: dge.asm,v 1.4 2016-06-22 19:50:49 dom Exp $
;

        SECTION smc_fp
        INCLUDE "cpcmath.inc"

        PUBLIC  dge
        PUBLIC  dgec

        EXTERN  fsetup
        EXTERN  stkequcmp
        EXTERN  cmpfin

dge:
        call    fsetup
dgec:
        FPCALL  (CPCFP_FLO_CMP)
        cp      0                       ;(hl) <= (de)
        jp      z, cmpfin
        cp      1
        jp      z, cmpfin
        xor     a
        jp      stkequcmp

