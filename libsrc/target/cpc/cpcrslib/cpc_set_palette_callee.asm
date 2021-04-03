;
;       Amstrad CPC library
;       set color palette, flashing is useless so we forget the second color
;
;       void __LIB__ __CALLEE__ cpc_set_palette_callee(int pen, int color);
;
;       $Id: cpc_set_palette_callee.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_set_palette_callee
        PUBLIC    _cpc_set_palette_callee
        PUBLIC    cpc_SetInk_callee
        PUBLIC    _cpc_SetInk_callee
        PUBLIC    asm_cpc_set_palette
        EXTERN firmware

        INCLUDE "target/cpc/def/cpcfirm.def"              

.cpc_set_palette_callee
._cpc_set_palette_callee
.cpc_SetInk_callee
._cpc_SetInk_callee


   pop hl
   pop bc
   ex (sp),hl
   
   ; enter : l = pen
   ;         c = color

.asm_cpc_set_palette
;       ACTION Sets the colours of a PEN - if the two values supplied are different then the colours will alternate (flash)
;       ENTRY A contains the PEN number, B contains the first colour, and C holds the second colour
	ld	a,l
	ld	b,c
	call firmware
	defw scr_set_ink 
	ret

