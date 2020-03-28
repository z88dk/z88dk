;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       Used by cpc_PrintGphStrStd and cpc_PrintGphStrStdXY
;
;       $Id: cpc_PrintGphStrStd0.asm $
;

        SECTION   code_clib
		
        PUBLIC    cpc_PrintGphStrStd0
		
		PUBLIC    direcc_destino0s_m1
		PUBLIC    color_uso
		
		EXTERN    cpc_Chars8
        EXTERN    first_char8



.color0
xor a
call metecolor
jp sigue

.color1
ld a,@00001000
call metecolor
jp sigue
.color2
ld a,@10000000
call metecolor
jp sigue
.color3
ld a,@10001000
call metecolor
jp sigue
.metecolor
ld (cc0-1),a
ld (cc4-1),a
srl a
ld (cc1-1),a
ld (cc5-1),a
srl a
ld (cc2-1),a
ld (cc6-1),a
srl a
ld (cc3-1),a
ld (cc7-1),a
ret



.cpc_PrintGphStrStd0  

;DE destino
;HL origen
;ex de,hl


;; marcará el color con que se imprime
.color_uso
;ld a,1
or a ; cp 0
jp z,color0
cp 1
jp z,color1
cp 2
jp z,color2
cp 3
jp z,color3
.sigue


;trabajo previo: Para tener una lista de trabajos de impresión. No se interrumpe
;la impresión en curso.
ld a,(imprimiendo)
cp 1
jp z,add_elemento

ld (direcc_destino),hl
ex de,hl
call bucle_texto0

;antes de terminar, se mira si hay algo en cola.
.bucle_cola_impresion
ld a,(elementos_cola)
or a
jp z,terminar_impresion
call leer_elemento
jp bucle_cola_impresion


.terminar_impresion
xor a
ld (imprimiendo),a
ret

.entrar_cola_impresion
;si se está imprimiendo se mete el valor en la cola

ret
.add_elemento
di
	ld ix,(pos_cola)
	ld (ix+0),l
	ld (ix+1),h
	ld (ix+2),e
	ld (ix+3),d
	inc ix
	inc ix
	inc ix
	inc ix
	ld (pos_cola),ix
	
	ld hl,elementos_cola
	inc (hl)
	;Se añaden los valores hl y de
ei
	ret
.leer_elemento
di
	ld ix,(pos_cola)
	ld l,(ix+0)
	ld h,(ix+1)
	ld e,(ix+2)
	ld d,(ix+3)
	dec ix
	dec ix
	dec ix
	dec ix
	ld (pos_cola),ix
	
	ld hl,elementos_cola
	dec (hl)
ei
	ret

	
	
.bucle_texto0
ld a,1
ld (imprimiendo),a

ld a,(first_char8)
ld b,a		;resto 48 para saber el número del caracter (En ASCII 0=48)

ld a,(hl)
or a ;cp 0
ret z
sub b
ld bc,cpc_Chars8	;apunto a la primera letra
push hl


ld l,a		;en A tengo la letra que sería
ld h,0
add hl,hl
add hl,hl
add hl,hl	;x8 porque cada letra son 8 bytes
add hl,bc	;ahora HL apunta a los datos de la letra correspondiente

call escribe_letra
ld hl,(direcc_destino)
ld de,letra_decodificada
;ld A,8	;alto  
call cpc_PutSp0
ld hl,(direcc_destino)
inc hl
inc hl
ld (direcc_destino),hl

pop hl
inc hl
jp bucle_texto0





.cpc_PutSp0
		ld iyh,8		; undocumented instruction
		ld b,7
		ld c,b
	.loop_alto_2

	.loop_ancho_2		
		ex de,hl
		ldi
		ldi
		
	   dec iyh		; undocumented instruction
	   ret z	
	   ex de,hl   	   
.salto_linea
		LD C,$fe			;&07f6 			;salto linea menos ancho
		ADD HL,BC
		jp nc,loop_alto_2 ;sig_linea_2zz		;si no desborda va a la siguiente linea
		ld bc,$c050
		add HL,BC
		ld b,7			;sólo se daría una de cada 8 veces en un sprite
		jp loop_alto_2	
		
		
		
.escribe_letra		;; lee el byte y lo interpreta
ld iy,letra_decodificada
ld b,8
.bucle_alto
push bc

;leo el byte... ahora se miran sus bits y se rellena el caracter a imprimir
xor a
ld b,(hl)
bit 7,b
jp z,cc0
or @10001000
.cc0
bit 6,b
jp z,cc1
or @01000100
.cc1
bit 5,b
jp z,cc2
or @00100010
.cc2
bit 4,b
jp z,cc3
or @00010001
.cc3

;primer byte
ld (iy+0),a
inc iy


xor a
bit 3,b
jp z,cc4
or @10001000
.cc4
bit 2,b
jp z,cc5
or @01000100
.cc5
bit 1,b
jp z,cc6
or @00100010
.cc6
bit 0,b
jp z,cc7
or @00010001
.cc7

;segundo byte
ld (iy+0),a
inc iy


inc hl
pop bc
djnz bucle_alto
ret


	SECTION	bss_clib


.elementos_cola
 defw 0
 
.pos_cola
 defw cola_impresion
 
;pos_escritura_cola defw cola_impresion
.cola_impresion
 defs 12

.imprimiendo
 defb 0
 
.direcc_destino0s_m1
.direcc_destino
 defw 0

.letra_decodificada
 defs 16	;uso este espacio para guardar la letra que se decodifica


