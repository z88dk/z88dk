;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       void  __LIB__  cpc_SpUpdY(int sprite, char y)  __smallc __z88dk_callee;
;
;       $Id: cpc_SpUpdY_callee.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_SpUpdY_callee
        PUBLIC    _cpc_SpUpdY_callee
        PUBLIC    ASMDISP_CPC_SPUPDY_CALLEE

        EXTERN ancho_pantalla_bytes 
		
.cpc_SpUpdY_callee
._cpc_SpUpdY_callee


   pop bc
   pop de
   pop ix
   push bc

.asmentry

	ld a,e		;value
	;A=x value
	or a ;	cp 0
	ret z	;si inc=0
	
		
	;ld l,(ix+2)
	;ld h,(ix+3)
		
    ;push hl
    ;pop ix
    
;	ld e,(ix+2)
;	ld d,(ix+3)		;sprite
		

  ;  push de		;10
  ;  pop ix		;14
;    LD IXH,d	;9
;    LD IXL,e	;9    

	
	ld bc,ancho_pantalla_bytes
	
    bit 7,a	;check if negative number
    jp nz, negative
  ;ix tiene el valor del sprite
  ;incrementar x
  ld l,a
  ld h,0
  ;ld b,(ix+9)			;19
  ;add b				;4
  add a,(ix+9)			;19
  ld (ix+9),a ;Y updated
  
  ld a,l
  
  ld l,(ix+4)
  ld h,(ix+5)
  
;  ld bc,ancho_pantalla_bytes
  ;ld b,0
.bucle_suma_y
	add hl,bc
	dec a
	jp nz,bucle_suma_y


  ld (ix+4),l
  ld (ix+5),h ;superbufer coord updated
  ret
  
  
  
.negative
  NEG A
  ld e,a
  ;ld d,0			; D is probably always zero
  ld a,(ix+9)
  sub e
  ;sub (ix+9)
  ld (ix+9),a ;Y updated
  
  ld a,e
  
  ld l,(ix+4)
  ld h,(ix+5)
 
  ;ld c,ancho_pantalla_bytes
  ;ld b,0
.bucle_resta_y
	sbc hl,bc
	dec a
	jp nz,bucle_resta_y

  ld (ix+4),l
  ld (ix+5),h ;superbufer coord updated
  ret


DEFC ASMDISP_CPC_SPUPDY_CALLEE = # asmentry - cpc_SpUpdY_callee
