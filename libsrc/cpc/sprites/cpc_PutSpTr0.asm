;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;
;       $Id: cpc_PutSpTr0.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_PutSpTr0
		
		PUBLIC    anchot
		PUBLIC    suma_siguiente_lineat

		
.cpc_PutSpTr0
   		ld ixh,a		;ALTO, SE PUEDE TRABAJAR CON HX DIRECTAMENTE	
	.loop_alto_2t
.anchot
	   ld b,0
		;push hl
	.loop_ancho_2t		
		ld A,(DE)
		
	and $aa
	jp z,sig_pixn_der_2
	ld c,a ;B es el único registro libre
	ld a,(hl) ;pixel actual donde pinto
	and $55
	or c
	ld (hl),a ;y lo pone en pantalla
.sig_pixn_der_2
	ld a,(de) ;pixel del sprite
	and $55
	jp z,pon_buffer_der_2
	ld c,a ;B es el único registro libre
	ld a,(hl) ;pixel actual donde pinto
	and $aa
	or c

	
	
		ld (hl),a
	.pon_buffer_der_2
		inc de
		inc hl
		dec b
		jp nz,loop_ancho_2t
		;pop hl
	   dec ixh
	   ret z
.salto_lineat
.suma_siguiente_lineat
		LD BC,$07ff			;&07f6 			;salto linea menos ancho
		ADD HL,BC
		jp nc,loop_alto_2t ;sig_linea_2zz		;si no desborda va a la siguiente linea
		ld bc,$c050
		
		add HL,BC
		;ld b,7			;sólo se daría una de cada 8 veces en un sprite
		jp loop_alto_2t		   
	     		
		ld A,H
		add $08
		ld H,A
		sub $C0
		jp nc,loop_alto_2t ;sig_linea_2
		ld bc,$c050
		add HL,BC	
	   jp loop_alto_2t
