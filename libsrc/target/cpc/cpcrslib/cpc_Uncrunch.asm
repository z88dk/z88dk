;
;       Amstrad CPC library
;       (CALLER linkage for function pointers)
;
;       set color palette, flashing is useless so we forget the second color
;
;       void __LIB__ __CALLEE__ cpc_Uncrunch(int src, int dst);
;
;       $Id: cpc_Uncrunch.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_Uncrunch
        PUBLIC    _cpc_Uncrunch
        EXTERN     asm_cpc_Uncrunch

.cpc_Uncrunch
._cpc_Uncrunch
        pop     bc
        pop     hl
        pop     de
        push    de
        push    hl
        push    bc
        jp asm_cpc_Uncrunch
