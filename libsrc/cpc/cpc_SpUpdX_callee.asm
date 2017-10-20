;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       void  __LIB__  cpc_SpUpdX(int sprite, char x)  __smallc __z88dk_callee;
;
;       $Id: cpc_SpUpdX_callee.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_SpUpdX_callee
        PUBLIC    _cpc_SpUpdX_callee
        PUBLIC    ASMDISP_CPC_SPUPDX_CALLEE

		
.cpc_SpUpdX_callee
._cpc_SpUpdX_callee


   pop bc
   pop de
   pop ix
   push bc

.asmentry

	ld a,e		;value
	;A=x value
	
	;ix=sprite
		

    ;push de		;10
    ;pop ix		;14
  
    ;LD IXH,d	;9
    ;LD IXL,e	;9
    
    
    
	ld h,0
    bit 7,a	;check if negative number
    jp z, negative1
    dec h
    .negative1
  ;ix tiene el valor del sprite
  ;incrementar x
  ld l,a
  ;ld h,0
  ;ld b,(ix+8)
  ;add b
  add a,(ix+8)
  ld (ix+8),a ;X updated
  ld e,(ix+4)
  ld d,(ix+5)
  add hl,de
  ld (ix+4),l
  ld (ix+5),h ;superbufer coord updated
  ret

DEFC ASMDISP_CPC_SPUPDX_CALLEE = # asmentry - cpc_SpUpdX_callee
