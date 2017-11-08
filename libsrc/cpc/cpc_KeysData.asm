;
;       Amstrad CPC library
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       $Id: cpc_KeysData.asm $
;

        SECTION   bss_clib
;        PUBLIC    cpc_KeysData
        PUBLIC    keymap

;.cpc_KeysData
.keymap defs 10


        SECTION   data_clib
        PUBLIC    tabla_teclas

;.teclado defb 0		;Este byte indicará qué teclas han sido pulsadas 
			;después de un ciclo de exploración
;x.linea defb 0
;x.bte defb 0
.tecla_0 defw $0204
;teclado_usable	; teclas del cursor, cada tecla está definida por su bit y su línea.
.tabla_teclas
.tecla_0_x defw $4002	; bit 0, línea 2
.tecla_1_x defw $4101	; bit 1, línea 1
.tecla_2_x defw $4001		; bit 0, línea 1
.tecla_3_x defw $4004		; bit 0, línea 4
.tecla_00_x defw $ffff	; bit 0, línea 2
.tecla_01_x defw $ffff	; bit 1, línea 1
.tecla_02_x defw $ffff		; bit 0, línea 1
.tecla_03_x defw $ffff		; bit 0, línea 4
.tecla_04_x defw $ffff		; bit 0, línea 4
.tecla_05_x defw $ffff		; bit 0, línea 4
.tecla_06_x defw $ffff		; bit 0, línea 4
.tecla_07_x defw $ffff		; bit 0, línea 4

; For increasing keys available just increase this word table
defb 0
;DEFC linea_a_buscar = linea_a_buscar0

