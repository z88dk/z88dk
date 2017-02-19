;
;	PacMan hardware
;
;	Print character to the screen
;
;	Feb 2017 - Stefano Bodrato
;
;
;	$Id:$
;

	SECTION	code_clib
	PUBLIC  fputc_cons_native

	EXTERN     cleargraphics
	EXTERN	char_address
	
;
; Entry:        char to print
;

	DEFC	ROWS=36
	DEFC	COLUMNS=28

fputc_cons_native:
	ld	hl,2
	add	hl,sp
	ld	a,(hl); Now A contains the char to be printed

	cp	12
	jr	nz,nocls
	ld hl,0
	ld (ROW),hl
	jp cleargraphics
.nocls

	cp  13		; CR?
	jr  z,isLF
	cp  10      ; LF?
	jr  nz,NoLF
.isLF
	xor a
	ld (COLUMN),a   ; automatic CR
	ld a,(ROW)
	inc a
	ld (ROW),a
	cp ROWS         ; out of screen?
	ret nz
	dec a
	ld (ROW),a
	; To scroll this mess is memory consuming and tricky 
	;jp  scrolluptxt
	ret

NoLF:
		push af
		ld bc,(ROW)
		call	char_address
		pop af
		
;			- - - - - - -
			ld c,31	; white
;			- - - - - - -
			
			ld b,a
			ld de,map
maploop:
			ld a,(de)
			and a
			jr nz,noend
			ld a,b
			jr mapend
noend:
			inc de
			inc de
			cp b
			jr nz,maploop
			dec de
			ld a,(de)
			jr nolower
mapend:
;			ld c,15	; white
;			- - - - - - -

			cp $60
			jr c,nolower
			ld c,7	; orange
			sub $20
nolower:
;			- - - - - - -
			ld (hl),a		; put current symbol on screen
;			cp 0xc0
;			jr c,nosym
;			ld c,7	; white
;nosym:
			ld de,$400
			add hl,de
			ld a,c			; color
			ld (hl),a
			
	ld	 a,(COLUMN)
	inc	 a
	ld	 (COLUMN),a
	cp	 COLUMNS		; last column ?
	ret	 nz		; no, return
 	jp	 isLF

map:
defb ' ', $40, '!', $5b, '.', $25, '"', 0x26 
defb '/', 0x3A, '-', 0x3B, '+', 0x12, '*', 0x10
defb '>', 0x3C, '<', 0x3e, '_', 0xCE, 127, 0x5c ; Copyright symbol
defb "'", 0xaa, '=', 0xdc, '(', 0xE9, ')', 0xE8
defb '[', 0xD2, ']', 0xD3, ':', 0xAE, ',', 0xF6
defb 0

	
		SECTION bss_crt
ROW:      defb    0       ;Address of row
COLUMN:   defb    0       ;Address of column

