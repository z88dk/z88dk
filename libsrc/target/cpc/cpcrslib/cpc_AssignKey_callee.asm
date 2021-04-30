;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       void  __LIB__  cpc_AssignKey(unsigned char key, int value)  __smallc __z88dk_callee;
;
;       $Id: cpc_AssignKey_callee.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_AssignKey_callee
        PUBLIC    _cpc_AssignKey_callee
        PUBLIC    asm_cpc_AssignKey
		
		EXTERN    tabla_teclas

.cpc_AssignKey_callee
._cpc_AssignKey_callee


   pop bc
   pop hl
   pop de
   push bc
   
.asm_cpc_AssignKey

    ;HL = linea, byte
	;DE = value

    ld a,l	;linea, byte
	ld b,h
	
	; DE tiene el valor de la tecla a escribir en la tabla
	; En A se tiene "key", el valor de la tecla seleccionada a comprobar [0..11]
	; A*2
;______________________________________________________________________________________________
;	;En A viene la tecla a redefinir (0..11)
	;srl	e 	;A*2	;
	sla e
	;ld e,a
	;ld d,0
	ld hl,tabla_teclas

; gracias a Mochilote por detectar un error aquí:	
	add hl,de ;Nos colocamos en la tecla a redefinir y la borramos
	ld (hl),$ff
	inc hl
	ld (hl),$ff
	dec hl
	push hl
	;call ejecutar_deteccion_teclado ;A tiene el valor del teclado
	;ld a,d
; A tiene el byte (<>0)
; B tiene la linea	
	;guardo linea y byte
	pop hl
	;ld a,(linea)
	ld (hl),a ;byte
	inc hl
	;ld a,b	  ;linea
	;ld a,(bte)
	ld (hl),b
	ret
	
