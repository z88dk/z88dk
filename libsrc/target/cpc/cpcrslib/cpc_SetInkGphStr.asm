;
;       Amstrad CPC library
;       (CALLER linkage for function pointers)
;
;       void __LIB__ cpc_SetInkGphStr(char *color, char *valor);
;
;       $Id: cpc_SetInkGphStr.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_SetInkGphStr
        PUBLIC    _cpc_SetInkGphStr
        EXTERN     asm_cpc_SetInkGphStr

.cpc_SetInkGphStr
._cpc_SetInkGphStr
		ld ix,2
		add ix,sp
		

		ld a,(ix+2) ;valor
		ld c,(ix+0)	;color

        jp asm_cpc_SetInkGphStr