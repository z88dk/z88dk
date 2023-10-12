;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: atan.asm,v 1.4 2016-06-22 19:50:48 dom Exp $
;

        SECTION smc_fp
        INCLUDE "cpcmath.inc"

        PUBLIC  atan
        PUBLIC  atanc

        EXTERN  get_para

atan:
        call    get_para
atanc:
        FPCALL  (CPCFP_FLO_ATAN)
        ret
