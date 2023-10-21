;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: floor.asm,v 1.4 2016-06-22 19:50:49 dom Exp $
;

        SECTION smc_fp
        INCLUDE "cpcmath.inc"

        PUBLIC  floor
        PUBLIC  floorc
        PUBLIC  floorc2

        EXTERN  get_para

floor:
        call    get_para
floorc:
        FPCALL  (CPCFP_FLO_BINFIX2)
        ld      a, b
floorc2:
        FPCALL  (CPCFP_BIN_2_FLO)
        ret
