;
;       Amstrad CPC library
;       (CALLER linkage for function pointers)
;
;       void __LIB__ cpc_SetInkGphStrM1(char *color, char *valor);
;
;       $Id: cpc_SetInkGphStrM1.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_SetInkGphStrM1
        PUBLIC    _cpc_SetInkGphStrM1
        EXTERN     asm_cpc_SetInkGphStrM1

.cpc_SetInkGphStrM1
._cpc_SetInkGphStrM1
		ld ix,2
		add ix,sp
		

		ld a,(ix+2) ;valor
		ld c,(ix+0)	;color

        jp asm_cpc_SetInkGphStrM1
