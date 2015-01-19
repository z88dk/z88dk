;
;       Amstrad CPC library
;       (CALLER linkage for function pointers)
;
;       creates a copy of a string in CPC format
;
;       char __LIB__ *cpc_rsx_strcpy(char *dst, char *src);
;
;       $Id: cpc_rsx_strcpy.asm,v 1.2 2015-01-19 01:32:42 pauloscustodio Exp $
;

        PUBLIC    cpc_rsx_strcpy
        EXTERN     cpc_rsx_strcpy_callee
        EXTERN    ASMDISP_CPC_RSX_STRCPY_CALLEE

.cpc_rsx_strcpy
        pop     bc
        pop     hl
        pop     de
        push    de
        push    hl
        push    bc
        jp cpc_rsx_strcpy_callee + ASMDISP_CPC_RSX_STRCPY_CALLEE
