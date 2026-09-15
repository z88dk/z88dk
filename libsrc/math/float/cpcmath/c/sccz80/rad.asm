;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: rad.asm,v 1.4 2016-06-22 19:50:49 dom Exp $
;

    SECTION smc_fp
    INCLUDE "cpcmath.inc"

    PUBLIC  rad
    PUBLIC  radc


rad:
    xor     a
radc:
    FPCALL  (CPCFP_FLO_DEG_RAD)
    ret

; floatpack init: run the CPC float-state patch at startup via code_crt_init
    SECTION code_crt_init
    EXTERN  init_floatpack
    call    init_floatpack

