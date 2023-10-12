;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: dleq.asm,v 1.6 2016-06-22 19:50:49 dom Exp $
;

        SECTION smc_fp
        INCLUDE "cpcmath.inc"

        PUBLIC  dleq
        PUBLIC  dleqc

        EXTERN  fsetup
        EXTERN  stkequcmp
        EXTERN  cmpfin

dleq:
        call    fsetup
dleqc:
        FPCALL  (CPCFP_FLO_CMP)
        cp      0                       ;(hl) <= (de)
        jp      z, cmpfin
        cp      255
        jp      z, cmpfin
        xor     a
        jp      stkequcmp

