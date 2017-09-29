;	
;	!! 2017-09-14 This file is superceeded by "lib/vgl_crt0" which is moving into the official z88dk!
;	
;	CRT0 for V-Tech Genius Leader ROM cartridges
;	
;	The most important thing this file does is adding the header bytes so the cartridge is recognized by the system.
;	
;	2017-01-04 Bernhard "HotKey" Slawik
; - - - - - - -

;.org $8000

	MODULE  vtech_crt0

;-------
; Include zcc_opt.def to find out information about us. It contains compile-time info.
;-------

	INCLUDE "zcc_opt.def"

;-------
; Some general scope declarations
;-------

	EXTERN	_main           ;main() is always external to crt0 code


;-------
; Some constants
;-------

	DEFC	ROM_START = $8000	; Where the ROM is mapped in the system
	DEFC	VRAM_START = $DCA0	; Where video RAM starts


;-------
; ROM starts here!
;-------
start:

; Note: The headers are also valid and non-critical OpCodes. So no problem in "running" them accidentally

.header

IF (startup=0)
	;-------
	; Standard signature for ROM cartridges (as seen on "SCHREIBMASCHINENKURS")
	;-------
	defb 55h
	defb 0aah
	defb 47h	; "G"
	defb 41h	; "A"
	
	; Jump to actual code
	jp past_rom_header	;jp	801fh
ENDIF


IF (startup=1)
	;-------
	; Auto-start signature for ROM cartridges (if found: will start instantly on power-on)
	;-------
	defb 55h
	defb 0aah
	defb 59h	; "Y"
	defb 45h	; "E"
	
	; Jump to actual code
	jp past_rom_header	;jp	801fh
ENDIF


IF (startup=10)
	;-------
	; Header for RAM payload
	;-------
	
	; Keep it small
	
ENDIF


IF (startup=100)
	;-------
	; Header for non-code ROMs / Quiz ROMs (if found: started via code at 0x2240 on 4000 models)
	;-------
	defb 55h
	defb 0aah
	defb 11h	; ld	de, 
	defb 02h	; Version/language?
ENDIF


IF (startup=101)
	;-------
	; Header for SRAM file system
	;-------
	defb 55h
	defb 0aah
	defb 0eeh
	
	; 0x8003: Status
	defb 0
	defb 0
	defb 0
	
	; 0x8006: FAT, uninitialized
	;defb 0xbb
	;defb 0x47
	
	; 0x8006: FAT with initial files
	; 7 empty files:
	defb 0xbb
	defb "FEHLER"
	defb 0xbc
	defb 0x00
	
	defb 0xbb
	defb "FEHLER"
	defb 0xbc
	defb 0x00
	
	defb 0xbb
	defb "FEHLER"
	defb 0xbc
	defb 0x00
	
	defb 0xbb
	defb "FEHLER"
	defb 0xbc
	defb 0x00
	
	defb 0xbb
	defb "FEHLER"
	defb 0xbc
	defb 0x00
	
	defb 0xbb
	defb "FEHLER"
	defb 0xbc
	defb 0x00
	
	defb 0xbb
	defb "FEHLER"
	defb 0xbc
	defb 0x00
	
	; 0x8048
	defb 0x70
	defb 0x70
	
	; 0x8050: main storage area
	defb 0x00
	defb 0x00
	defb 0x00
	defb 0x00
	defb 0x00
ENDIF



IF (startup<10)
; for code ROMs

;-------
; Default V-Tech ROM text at offset 0x8004
;-------

.rom_text
	;defb "VTECH PC-PROGCARD V1.00"
	defb "2017 by Bernhard Slawik"

.rom_version
	defb 01h


;-------
; Some useful functions
;-------


PUBLIC _print_char
_print_char:
	ld a, l
	out	(0bh), a
	call _delay_1fff
	ret

PUBLIC _out_0x0a
_out_0x0a:
	ld	a, l
	out	(0ah),a
	
	call _delay_010f
	ret

PUBLIC _out_0x0b
_out_0x0b:
	; Set cursor character?
	ld	a, l
	out	(0bh),a
	call _delay_1fff
	ret


_delay_1fff:
	; Used for screen functions (after putting stuff to ports 0x0a or 0x0b)
	push	hl
	ld	hl, 1fffh
_delay_1fff_loop:
	dec	l
	jr	nz, _delay_1fff_loop
	dec	h
	jr	nz, _delay_1fff_loop
	pop	hl
	ret

PUBLIC _delay_010f
_delay_010f:
	; Used for screen functions (after putting stuff to ports 0x0a or 0x0b)
	push	hl
	ld	hl, 010fh
_delay_010f_loop:
	dec	l
	jr	nz, _delay_010f_loop
	dec	h
	jr	nz, _delay_010f_loop
	pop	hl
	ret



past_rom_header:
	; Main entry point (ROM start jumps here, past the headers and utils)
	
	
	;call	_main	;Call user program
	
	
	; Fill with zeros up until 0x100
	; 0x100 - 0x1f - (bytes so far) = 225 - $
	;defs 222, 00h
	
	; Offset 0x100 is here


;-------
; 0x100: Call the C main function
;-------

call_main:
	call	_main	;Call user program
	;ret

;-------
; End
;-------

;cleanup:
;	defs 100h	; Padding at the end

ENDIF	; End of "only for standard ROMs"
