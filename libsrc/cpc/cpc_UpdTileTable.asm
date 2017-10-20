;
;       Amstrad CPC library
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       $Id: cpc_UpdTileTable.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_UpdTileTable
		
		EXTERN	tiles_tocados
		
		
; Internal use code
.cpc_UpdTileTable


;; Comprueba si el tile está dentro del cuadrado visible
;; x>tiles_ocultos_ancho0 && x<tiles_ocultos_ancho1
;; y>tiles_ocultos_alto0 && y<tiles_ocultos_alto1

;	ld a,tiles_ocultos_ancho0-1
;	cp e
;	jp p,contkaka	;;dentro de area visible	e<a
;	ld a,tiles_ocultos_ancho1
;	cp e
;	jp m,contkaka	;;dentro de area visible   e>=a
;	ld a,tiles_ocultos_alto0-1
;	cp d
;	jp p,contkaka	;;dentro de area visible	e>a
;	ld a,tiles_ocultos_alto1
;	cp d
;	jp m,contkaka	;;dentro de area visible   e<=a	
	
	; Si está en area visible, se actualiza la tabla
	

	LD HL,tiles_tocados
	;incorporo el tile en su sitio, guardo x e y
.bucle_recorrido_tiles_tocados
	LD A,(HL)
	CP $FF	
	JP Z,incorporar_tile	;Solo se incorpora al llegar a un hueco
	CP E
	JP Z, comprobar_segundo_byte	
	INC HL
	INC HL
	JP bucle_recorrido_tiles_tocados

.comprobar_segundo_byte
	INC HL
	LD A,(HL)
	CP D
	RET Z	;los dos bytes son iguales, es el mismo tile. No se añade
	INC HL
	JP bucle_recorrido_tiles_tocados

.incorporar_tile
	LD (HL),E	
	INC HL
	LD (HL),D
	INC HL
	LD (HL),$FF	;End of data
.contkaka	
	RET
