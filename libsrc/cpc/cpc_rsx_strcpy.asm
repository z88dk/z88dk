;
;       Amstrad CPC library
;       (CALLER linkage for function pointers)
;
;       creates a copy of a string in CPC format
;
;       char __LIB__ *cpc_rsx_strcpy(char *dst, char *src);
;
;       $Id: cpc_rsx_strcpy.asm,v 1.1 2008-05-26 06:38:08 stefano Exp $
;

        XLIB    cpc_rsx_strcpy
        LIB     cpc_rsx_strcpy_callee
        XREF    ASMDISP_CPC_RSX_STRCPY_CALLEE

.cpc_rsx_strcpy
        pop     bc
        pop     hl
        pop     de
        push    de
        push    hl
        push    bc
        jp cpc_rsx_strcpy_callee + ASMDISP_CPC_RSX_STRCPY_CALLEE
