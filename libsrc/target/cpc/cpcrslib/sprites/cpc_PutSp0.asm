;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;
;       $Id: cpc_PutSp0.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_PutSp0
		
		PUBLIC    ancho0
		PUBLIC    PutSp0_xormode
		PUBLIC    suma_siguiente_linea0

		
.cpc_PutSp0
		ld ixh,a
		;defb $fD
   		;LD H,a		;ALTO, SE PUEDE TRABAJAR CON HX DIRECTAMENTE
		ld b,7
	.ancho0
	.loop_alto_2
	   ld c,4		; << PARAMETRO ANCHO
	.loop_ancho_2
		ld A,(DE)

	.PutSp0_xormode
		;XOR (HL)
		NOP		; << SMC
		
		ld (hl),a
		inc de
		inc hl
		dec c
		jp nz,loop_ancho_2
	   dec ixh
;	   defb $fD
;	   dec H
	   ret z

.salto_linea
.suma_siguiente_linea0
		LD C,$ff			;<< PARAMETRO salto linea menos ancho
		ADD HL,BC
		jp nc,loop_alto_2 ;sig_linea_2zz		;si no desborda va a la siguiente linea
		ld bc,$c050
		
		add HL,BC
		ld b,7			;sólo se daría una de cada 8 veces en un sprite
		jp loop_alto_2	

