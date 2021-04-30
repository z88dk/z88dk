;
;       Amstrad CPC library
;       (CALLER linkage for function pointers)
;
;       creates a copy of a string in CPC format
;
;       char __LIB__ *cpc_rsx_strcpy(char *dst, char *src);
;
;       $Id: cpc_rsx_strcpy.asm,v 1.3 2016-06-10 21:12:36 dom Exp $
;

        SECTION   code_clib
        PUBLIC    cpc_rsx_strcpy
        PUBLIC    _cpc_rsx_strcpy
        EXTERN    asm_cpc_rsx_strcpy

.cpc_rsx_strcpy
._cpc_rsx_strcpy
        pop     bc
        pop     hl
        pop     de
        push    de
        push    hl
        push    bc
        jp asm_cpc_rsx_strcpy