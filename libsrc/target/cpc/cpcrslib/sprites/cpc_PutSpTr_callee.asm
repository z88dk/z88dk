;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       void  cpc_PutSpTr(int *sprite, char *alto, char *ancho, int *posicion);
;
;       $Id: cpc_PutSpTr_callee.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_PutSpTr_callee
        PUBLIC    _cpc_PutSpTr_callee
		
		EXTERN    cpc_PutSpTr0
		
		EXTERN    anchot
		EXTERN    suma_siguiente_lineat

		
.cpc_PutSpTr_callee
._cpc_PutSpTr_callee

; dibujar en pantalla el sprite

		; Entradas	bc-> Alto Ancho
		;			de-> origen
		;			hl-> destino
		; Se alteran hl, bc, de, af			
	
	pop	hl	; ret addr
	pop	de
	
	pop bc	; ancho
	ld	a,c
    ld (anchot+1),a		;actualizo rutina de captura
	dec a
	cpl
	ld (suma_siguiente_lineat+1),a    ;comparten los 2 los mismos valores.		
	
	pop bc	; alto
	ld	a,c
	
	ex (sp),hl
	ex	de,hl
	
	jp cpc_PutSpTr0

