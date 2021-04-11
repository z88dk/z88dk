;
;       Amstrad CPC library
;       (CALLER linkage for function pointers)
;
;       set color palette, flashing is useless so we forget the second color
;
;       void __LIB__ *cpc_set_palette(int pen, int color);
;
;       $Id: cpc_set_palette.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_set_palette
        PUBLIC    _cpc_set_palette
        EXTERN     cpc_set_palette_callee
        EXTERN     cpc_SetInk
        EXTERN     _cpc_SetInk
        EXTERN    asm_cpc_set_palette

.cpc_SetInk
._cpc_SetInk
.cpc_set_palette
._cpc_set_palette
        pop     de
        pop     hl
        pop     bc
        push    bc
        push    hl
        push    de
        jp asm_cpc_set_palette
