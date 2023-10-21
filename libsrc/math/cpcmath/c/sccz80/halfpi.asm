;
;	CPC Maths Routines
;
;	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
;
;	$Id: pi.asm,v 1.4 2016-06-22 19:50:49 dom Exp $
;

        SECTION code_fp
        INCLUDE "cpcmath.inc"

        PUBLIC  halfpi

        EXTERN  fa

halfpi:
        ld      de, fa+1
        ld      hl, halfpi_value
        ld      bc, 5
        ldir
        ret

        SECTION rodata_fp

halfpi_value:
        defb    0xa2, 0xda, 0x0f, 0x49, 0x81
