;
;Based on the SG C Tools 1.7
;(C) 1993 Steve Goldsmith
;
;$Id: outvdc.asm,v 1.3 2016-06-16 21:13:07 dom Exp $
;

;set vdc register

        SECTION code_clib
        PUBLIC    outvdc
        PUBLIC    _outvdc
        EXTERN     outvdc_callee
        EXTERN    ASMDISP_OUTVDC_CALLEE 

outvdc:
_outvdc:
        pop     bc              ;return address
        pop     de              ;data
        pop     hl              ;vdc register to write
        push    hl
        push    de
        push    bc
        jp outvdc_callee + ASMDISP_OUTVDC_CALLEE
