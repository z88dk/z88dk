;
;       Amstrad CPC library
;
;       void __LIB__ __CALLEE__ cpc_SetInkGphStr(char *color, char *valor);
;
;       $Id: cpc_SetInkGphStrM1_callee.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_SetInkGphStrM1_callee
        PUBLIC    _cpc_SetInkGphStrM1_callee
        PUBLIC    ASMDISP_CPC_SET_INKGPHSTRM1_CALLEE
		
        EXTERN colores_cambM1


.cpc_SetInkGphStrM1_callee
._cpc_SetInkGphStrM1_callee

   pop hl
   pop bc	;valor
   ex (sp),hl	; valor
   ld	a,c
   ld	c,l
   

.asmentry
	
ld hl,colores_cambM1
ld b,0
add hl,bc
ld (hl),a
	
ret


DEFC ASMDISP_CPC_SET_INKGPHSTRM1_CALLEE = asmentry - cpc_SetInkGphStrM1_callee
