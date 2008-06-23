;
;Based on the SG C Tools 1.7
;(C) 1993 Steve Goldsmith
;
;$Id: outvdc.asm,v 1.1 2008-06-23 17:34:34 stefano Exp $
;

;set vdc register

        XLIB    outvdc
        LIB     outvdc_callee
        XREF    ASMDISP_OUTVDC_CALLEE 

outvdc:
        pop     bc              ;return address
        pop     de              ;data
        pop     hl              ;vdc register to write
        push    hl
        push    de
        push    bc
        jp outvdc_callee + ASMDISP_OUTVDC_CALLEE
