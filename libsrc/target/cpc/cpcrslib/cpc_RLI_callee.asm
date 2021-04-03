;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       void  cpc_RLI(unsigned int pos, unsigned char w, unsigned char h);
;
;       $Id: cpc_RLI_callee.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_RLI_callee
        PUBLIC    _cpc_RLI_callee
        PUBLIC    asm_cpc_RLI	


.cpc_RLI_callee
._cpc_RLI_callee

	pop hl
	pop de	; h
	pop bc	; w
	ex	(sp),hl	; pos
	

.asm_cpc_RLI
	ld	a,e
	ld (_ancho+1),a
	ld	a,c
	ld (_alto+1),a

dec hl	
._alto
ld a,8					;; parametro
.ciclo0
push af
push hl
;;
inc hl
ld a,(hl)
;;
ld d,h
ld e,l
dec hl
ld b, 0
._ancho
ld c,50	; parametro
lddr

inc hl

ld (hl),a

pop hl

pop af
dec a

ret z

;salto de línea, ojo salto caracter.
ld bc,$800
add hl,bc


jp nc,ciclo0 ;sig_linea_2zz		;si no desborda va a la siguiente linea
ld bc,$c050
add HL,BC
jp ciclo0

	
