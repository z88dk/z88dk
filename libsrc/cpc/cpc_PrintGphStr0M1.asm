;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       Used by cpc_PrintGphStrM1 and cpc_PrintGphStrM12X
;
;       $Id: cpc_PrintGphStr0M1.asm $
;

        SECTION   code_clib
		
        PUBLIC    cpc_PrintGphStr0M1
		
		PUBLIC    direcc_destino0_m1
		PUBLIC    colores_cambM1
		
		EXTERN    cpc_Chars
        EXTERN    first_char
		


.cpc_PrintGphStr0M1

;DE destino
;HL origen
;ex de,hl
ld (doble),a

;trabajo previo: Para tener una lista de trabajos de impresión. No se interrumpe
;la impresión en curso.
ld a,(imprimiendo)
cp 1
jp z,add_elemento

ld (direcc_destino0_m1),hl
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

.elementos_cola defw 0
.pos_cola defw cola_impresion
;pos_escritura_cola defw cola_impresion
.cola_impresion defs 12

.bucle_texto0
ld a,1
ld (imprimiendo),a

ld a,(first_char)
ld b,a		;resto 48 para saber el número del caracter (En ASCII 0=48)

ld a,(hl)
or a ;cp 0
ret z
sub b
ld bc,cpc_Chars	;apunto a la primera letra
push hl


ld l,a		;en A tengo la letra que sería
ld h,0
add hl,hl
add hl,hl
add hl,hl	;x8 porque cada letra son 8 bytes
add hl,bc	;ahora HL apunta a los datos de la letra correspondiente



call escribe_letra

ld a,(doble)
cp 1
; ANTES DE IMPRIMIR SE CHEQUEA SI ES DE ALTURA EL DOBLE Y SE ACTÚA EN CONSECUENCIA	
call z, doblar_letra



ld hl,(direcc_destino0_m1)

ld a,(doble)
cp 1
;alto  
jr z,cont_doble
ld de,letra_decodificada
ld ixh,8
;defb $fD
;LD H,8		;ALTO, SE PUEDE TRABAJAR CON HX DIRECTAMENTE
jr cont_tot


.cont_doble
ld de,letra_decodificada_tmp
ld ixh,16
;defb $fD
;LD H,16		;ALTO, SE PUEDE TRABAJAR CON HX DIRECTAMENTE

.cont_tot
call cpc_PutSp0

ld hl,(direcc_destino0_m1)
inc hl

ld (direcc_destino0_m1),hl
pop hl
inc hl
jp bucle_texto0



.doblar_letra 
	ld hl,letra_decodificada
	ld de,letra_decodificada_tmp
	ld b,8
	.buc_doblar_letra
	ld a,(hl)
	inc hl
	ld (de),a
	inc de
	ld (de),a
	inc de
	djnz buc_doblar_letra
	ret
	
	
.cpc_PutSp0
	;	defb $fD
   	;	LD H,8		;ALTO, SE PUEDE TRABAJAR CON HX DIRECTAMENTE
		ld b,7
		ld c,b
	.loop_alto_2

	.loop_ancho_2		
		ex de,hl
		ldi
		;ldi
		
	   ;defb $fD
	   ;dec H
	   dec ixh
	   ret z	
	   ex de,hl   	   
.salto_linea
		LD C,$ff			;&07f6 			;salto linea menos ancho
		ADD HL,BC
		jp nc,loop_alto_2 ;sig_linea_2zz		;si no desborda va a la siguiente linea
		ld bc,$c050
		add HL,BC
		ld b,7			;sólo se daría una de cada 8 veces en un sprite
		jp loop_alto_2	
		
		
		
.escribe_letra
	ld iy,letra_decodificada
	ld b,8
	ld ix,byte_tmp	
	.bucle_alto
		push bc
		push hl

		ld a,(hl)
		ld hl,dato
		ld (hl),a
		;me deja en ix los valores convertidos
		;HL tiene la dirección origen de los datos de la letra
		;LD DE,letra	;el destino es la posición de decodificación de la letra
		;Se analiza el byte por parejas de bits para saber el color de cada pixel.
		ld (ix+0),0	;reset el byte 
		LD B,4	;son 4 pixels por byte. Los recorro en un bucle y miro qué color tiene cada byte.
		.bucle_colores
			;roto el byte en (HL)
			push hl
			call op_colores_m1	;voy a ver qué color es el byte. tengo un máximo de 4 colores posibles en modo 0.
			pop hl
			srl (HL)	
			srl (HL)	;voy rotando el byte para mirar los bits por pares.
			djnz bucle_colores
		ld a,(ix+0)
		ld (iy+0),a
		inc iy
		pop hl
		inc hl
		pop bc
		djnz bucle_alto
		ret


;.rutina
;HL tiene la dirección origen de los datos de la letra

;Se analiza el byte por parejas de bits para saber el color de cada pixel.
;ld ix,byte_tmp	
;ld (ix+0),0

;LD B,4	;son 4 pixels por byte. Los recorro en un bucle y miro qué color tiene cada byte.
;.bucle_colores
;roto el byte en (HL)
;push hl
;call op_colores_m1	;voy a ver qué color es el byte. tengo un máximo de 4 colores posibles en modo 0.
;pop hl
;sla (HL)	
;sla (HL)	;voy rotando el byte para mirar los bits por pares.

;djnz bucle_colores

;ret
.op_colores_m1   ;rutina en modo 1
					;mira el color del bit a pintar
LD A,3		;hay 4 colores posibles. Me quedo con los 2 primeros bits
; 
AND (HL)
; EN A tengo el número de bytes a sumar!! 
LD HL,colores_cambM1
ld e,a
ld d,0
add hl,de

ld c,(hl)
;En C está el byte del color
;ld a,4
;sub b
ld a,b
dec a
or a ;cp 0
jp z,_sin_rotar
.rotando
srl c
dec a
jp nz, rotando
._sin_rotar

ld a,c
or (ix+0)
ld (ix+0),a
;inc ix
ret



SECTION	data_clib

.dato defb @00011011  ;aquí dejo temporalmente el byte a tratar

.byte_tmp defs 2
.colores_cambM1 
defb @00000000,@10001000,@10000000,@00001000

;defb @00000000,  @01010100, @00010000, @00000101  ;@00000001, @00000101, @00010101, @00000000


SECTION	bss_clib

.doble defb 0
.imprimiendo defb 0
.direcc_destino0_m1 defw 0

.letra_decodificada defs 8	;uso este espacio para guardar la letra que se decodifica
.letra_decodificada_tmp defs 16

