;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       void  cpc_PutSp(int *sprite, char *alto, char *ancho, int *posicion);
;
;       $Id: cpc_PutSp_callee.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_PutSp_callee
        PUBLIC    _cpc_PutSp_callee
		
		EXTERN    cpc_PutSp0
		
		EXTERN    ancho0
		EXTERN    suma_siguiente_linea0

        EXTERN    PutSp0_xormode

		
.cpc_PutSp_callee
._cpc_PutSp_callee

; dibujar en pantalla el sprite

		; Entradas	bc-> Alto Ancho
		;			de-> origen
		;			hl-> destino
		; Se alteran hl, bc, de, af			
	
	xor a
	ld	(PutSp0_xormode),a
	
	pop	hl	; ret addr
	pop	de
	
	pop bc	; ancho
	ld	a,c
    ld (ancho0+1),a		;actualizo rutina de captura
	dec a
	cpl
	ld (suma_siguiente_linea0+1),a    ;comparten los 2 los mismos valores.		
	
	pop bc	; alto
	ld	a,c
	
	ex (sp),hl
	ex	de,hl
	
	jp cpc_PutSp0

