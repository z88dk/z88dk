;
;       Amstrad CPC library
;
;       void __LIB__ __CALLEE__ cpc_SetInkGphStr(char *color, char *valor);
;
;       $Id: cpc_SetInkGphStr_callee.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_SetInkGphStr_callee
        PUBLIC    _cpc_SetInkGphStr_callee
        PUBLIC    asm_cpc_SetInkGphStr
		
        EXTERN colores_camb


.cpc_SetInkGphStr_callee
._cpc_SetInkGphStr_callee

   pop hl
   pop bc	;valor
   ex (sp),hl	; valor
   ld	a,c
   ld	c,l
   

.asm_cpc_SetInkGphStr
	
ld hl,colores_camb
ld b,0
add hl,bc
ld (hl),a
	
ret

