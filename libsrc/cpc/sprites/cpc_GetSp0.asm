;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;
;       $Id: cpc_GetSp0.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_GetSp0
		
		PUBLIC    anchox
		PUBLIC    suma_siguiente_lineax
		

.cpc_GetSp0
   		ld ixh,a		;ALTO, SE PUEDE TRABAJAR CON HX DIRECTAMENTE
		ld b,7
	.loop_alto_2x
.anchox
	    ld c,0
		;push hl
		;ldi
	.loop_ancho_2x		
		ld A,(hl)
		ld (de),a
		inc de
		inc hl
		dec c
		jp nz,loop_ancho_2x
		;pop hl
	   dec ixh
	   ret z
  
.salto_lineax
.suma_siguiente_lineax
		LD C,$ff			;&07f6 			;salto linea menos ancho
		ADD HL,BC
		jp nc,loop_alto_2x ;sig_linea_2zz		;si no desborda va a la siguiente linea
		ld bc,$c050
		add HL,BC
		ld b,7			;sólo se daría una de cada 8 veces en un sprite
		jp loop_alto_2x			
