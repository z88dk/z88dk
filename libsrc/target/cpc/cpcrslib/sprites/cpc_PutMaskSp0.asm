;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;
;       $Id: cpc_PutMaskSp0.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_PutMaskSp0
		
		PUBLIC    ancho_m0
		PUBLIC    suma_siguiente_linea_m0

		
.cpc_PutMaskSp0
		ld ixh,a		;ALTO, SE PUEDE TRABAJAR CON HX DIRECTAMENTE
		ld b,7
	.loop_alto_2m
.ancho_m0
	   ld c,4
	   ex de,hl
	.loop_ancho_2m		
		
		LD A,(DE)	;leo el byte del fondo	
		AND (HL)	;lo enmascaro		
		INC HL
		OR (HL)		;lo enmascaro 
		LD (DE),A	;actualizo el fondo
		INC DE
		INC HL
		

		dec c
		jp nz,loop_ancho_2m
	   dec ixh
	   ret z
	   ex de,hl
	   	   
.salto_lineam
.suma_siguiente_linea_m0
		LD C,$ff			;&07f6 			;salto linea menos ancho
		ADD HL,BC
		jp nc,loop_alto_2m ;sig_linea_2zz		;si no desborda va a la siguiente linea
		ld bc,$c050
		
		add HL,BC
		ld b,7			;sólo se daría una de cada 8 veces en un sprite
		jp loop_alto_2m	

