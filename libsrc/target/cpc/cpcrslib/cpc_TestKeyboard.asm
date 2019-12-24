;
;       Amstrad CPC library
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       $Id: cpc_TestKeyboard.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_TestKeyboard
        PUBLIC    _cpc_TestKeyboard
        
.cpc_TestKeyboard
._cpc_TestKeyboard
; Definiciones del hardware del CPC
; Puertos de Acceso
;GATE_ARRAY	equ	#7F
;PPI_A		equ #F4
;PPI_B		equ #F5
;PPI_C		equ #F6
;PPI_CONTROL	equ #F7


;Tomado de las rutinas básicas que aparecen 
;en los documentos de  Kevin Thacker 
	;ld a, line		;use the value from the table above

	di


	;add $40

;Write 14 to PPI Port A, (This is the index of the I/O Port A register of the PSG)
	ld bc, $F40E		;14 en puerto A (&F4)
	out (c), c

;   2. Select PSG operation: write register index, by setting bit 7="1" and bit 6="1" of PPI port C.
;      (At this stage the PSG will have selected the register specified by the data at PPI Port A)
	ld bc, $F6C0	;bits 6 y 7 a 1 en el puerto C (&F6)
	out (c), c

;   3. Select PSG operation: inactive, by setting bit 7="0" and bit 6="0" of PPI Port C.
;      (This stage is required by the CPC+. If it is missing the scanning operation will fail)
; cpc+ compatible. bits 6 y 7 al puerto C (&F6)

	out (c),0		;  undocumented z80 instruction

;   4. Set Port A of the PPI to input (use PPI Control register),
;      (At this stage it is possible to read from PSG register 14)
	ld bc, $F792			;puerto control (&F7) a input
	out (c), c

	dec b
	;ld b, $F6
;   5. Write matrix line into bit 3-0 of PPI Port C.
;      (At this stage the matrix line data will be presented to PSG register 14).
	out (c), a		;A indica la línea de la matriz a leer en puerto C (&F6)


;   6. Select PSG operation: read register data, by setting bit 7="0 and bit 6="1" of PPI Port C.
;      (At this stage the matrix line data will be presented to PPI port A)
	;ld bc, $F640
	;out (c),c

;   7. Read matrix data from PPI port A.
	ld b, $F4
	in a, (c)

;	8. No aplica
;   9. Set Port A of the PPI to output (use PPI Control register),
;      (At this stage it is possible to write data to the PSG. This algorithm assumes that port A 
;       is in this state when it starts)
	ld bc, $F782
	out (c), c

;  10. Select PSG operation: inactive, by setting bit 7="0" and bit 6="0" of PPI Port C.
;      (This stage is required by the CPC+. If it is missing the scanning operation will fail) 
	dec b
	out (c),0		;  undocumented z80 instruction
	cpl					; En lugar de 0 si se ha pulsado una tecla, pone 1
	ei
ret
