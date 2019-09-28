; font_min.s
	
;	Text font
;	Michael Hope, 1998
;	michaelh@earthling.net
;	Distrubuted under the Artistic License - see www.opensource.org
;
	;; BANKED:	checked, imperfect
	SECTION	rodata_driver

	PUBLIC	_font_min

_font_min:
	defb	1+4		; 128 character encoding
	defb	37		; Tiles required

	defb	00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00		; All map to space
	defb	00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00		; All map to space
	defb	00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00		; All map to space
	defb	01,02,03,04,05,06,07,08,09,10,00,00,00,00,00,00
	defb	00,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
	defb	26,27,28,29,30,21,32,33,34,35,36,00,00,00,00,00
	defb	00,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
	defb	26,27,28,29,30,21,32,33,34,35,36,00,00,00,00,00

	defb	0
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000000 
; Character: 0
        defb    0b00000000 
        defb    0b00111100 
        defb    0b01000110 
        defb    0b01001010 
        defb    0b01010010 
        defb    0b01100010 
        defb    0b00111100 
        defb    0b00000000 
; Character: 1
        defb    0b00000000 
        defb    0b00011000 
        defb    0b00101000 
        defb    0b00001000 
        defb    0b00001000 
        defb    0b00001000 
        defb    0b00111110 
        defb    0b00000000 
; Character: 2
        defb    0b00000000 
        defb    0b00111100 
        defb    0b01000010 
        defb    0b00000010 
        defb    0b00111100 
        defb    0b01000000 
        defb    0b01111110 
        defb    0b00000000 
; Character: 3
        defb    0b00000000 
        defb    0b00111100 
        defb    0b01000010 
        defb    0b00001100 
        defb    0b00000010 
        defb    0b01000010 
        defb    0b00111100 
        defb    0b00000000 
; Character: 4
        defb    0b00000000 
        defb    0b00001000 
        defb    0b00011000 
        defb    0b00101000 
        defb    0b01001000 
        defb    0b01111110 
        defb    0b00001000 
        defb    0b00000000 
; Character: 5
        defb    0b00000000 
        defb    0b01111110 
        defb    0b01000000 
        defb    0b01111100 
        defb    0b00000010 
        defb    0b01000010 
        defb    0b00111100 
        defb    0b00000000 
; Character: 6
        defb    0b00000000 
        defb    0b00111100 
        defb    0b01000000 
        defb    0b01111100 
        defb    0b01000010 
        defb    0b01000010 
        defb    0b00111100 
        defb    0b00000000 
; Character: 7
        defb    0b00000000 
        defb    0b01111110 
        defb    0b00000010 
        defb    0b00000100 
        defb    0b00001000 
        defb    0b00010000 
        defb    0b00010000 
        defb    0b00000000 
; Character: 8
        defb    0b00000000 
        defb    0b00111100 
        defb    0b01000010 
        defb    0b00111100 
        defb    0b01000010 
        defb    0b01000010 
        defb    0b00111100 
        defb    0b00000000 
; Character: 9
        defb    0b00000000 
        defb    0b00111100 
        defb    0b01000010 
        defb    0b01000010 
        defb    0b00111110 
        defb    0b00000010 
        defb    0b00111100 
        defb    0b00000000 
; Character: A
        defb    0b00000000 
        defb    0b00111100 
        defb    0b01000010 
        defb    0b01000010 
        defb    0b01111110 
        defb    0b01000010 
        defb    0b01000010 
        defb    0b00000000 
; Character: B
        defb    0b00000000 
        defb    0b01111100 
        defb    0b01000010 
        defb    0b01111100 
        defb    0b01000010 
        defb    0b01000010 
        defb    0b01111100 
        defb    0b00000000 
; Character: C
        defb    0b00000000 
        defb    0b00111100 
        defb    0b01000010 
        defb    0b01000000 
        defb    0b01000000 
        defb    0b01000010 
        defb    0b00111100 
        defb    0b00000000 
; Character: D
        defb    0b00000000 
        defb    0b01111000 
        defb    0b01000100 
        defb    0b01000010 
        defb    0b01000010 
        defb    0b01000100 
        defb    0b01111000 
        defb    0b00000000 
; Character: E
        defb    0b00000000 
        defb    0b01111110 
        defb    0b01000000 
        defb    0b01111100 
        defb    0b01000000 
        defb    0b01000000 
        defb    0b01111110 
        defb    0b00000000 
; Character: F
        defb    0b00000000 
        defb    0b01111110 
        defb    0b01000000 
        defb    0b01111100 
        defb    0b01000000 
        defb    0b01000000 
        defb    0b01000000 
        defb    0b00000000 
; Character: G
        defb    0b00000000 
        defb    0b00111100 
        defb    0b01000010 
        defb    0b01000000 
        defb    0b01001110 
        defb    0b01000010 
        defb    0b00111100 
        defb    0b00000000 
; Character: H
        defb    0b00000000 
        defb    0b01000010 
        defb    0b01000010 
        defb    0b01111110 
        defb    0b01000010 
        defb    0b01000010 
        defb    0b01000010 
        defb    0b00000000 
; Character: I
        defb    0b00000000 
        defb    0b00111110 
        defb    0b00001000 
        defb    0b00001000 
        defb    0b00001000 
        defb    0b00001000 
        defb    0b00111110 
        defb    0b00000000 
; Character: J
        defb    0b00000000 
        defb    0b00000010 
        defb    0b00000010 
        defb    0b00000010 
        defb    0b01000010 
        defb    0b01000010 
        defb    0b00111100 
        defb    0b00000000 
; Character: K
        defb    0b00000000 
        defb    0b01000100 
        defb    0b01001000 
        defb    0b01110000 
        defb    0b01001000 
        defb    0b01000100 
        defb    0b01000010 
        defb    0b00000000 
; Character: L
        defb    0b00000000 
        defb    0b01000000 
        defb    0b01000000 
        defb    0b01000000 
        defb    0b01000000 
        defb    0b01000000 
        defb    0b01111110 
        defb    0b00000000 
; Character: M
        defb    0b00000000 
        defb    0b01000010 
        defb    0b01100110 
        defb    0b01011010 
        defb    0b01000010 
        defb    0b01000010 
        defb    0b01000010 
        defb    0b00000000 
; Character: N
        defb    0b00000000 
        defb    0b01000010 
        defb    0b01100010 
        defb    0b01010010 
        defb    0b01001010 
        defb    0b01000110 
        defb    0b01000010 
        defb    0b00000000 
; Character: O
        defb    0b00000000 
        defb    0b00111100 
        defb    0b01000010 
        defb    0b01000010 
        defb    0b01000010 
        defb    0b01000010 
        defb    0b00111100 
        defb    0b00000000 
; Character: P
        defb    0b00000000 
        defb    0b01111100 
        defb    0b01000010 
        defb    0b01000010 
        defb    0b01111100 
        defb    0b01000000 
        defb    0b01000000 
        defb    0b00000000 
; Character: Q
        defb    0b00000000 
        defb    0b00111100 
        defb    0b01000010 
        defb    0b01000010 
        defb    0b01010010 
        defb    0b01001010 
        defb    0b00111100 
        defb    0b00000000 
; Character: R
        defb    0b00000000 
        defb    0b01111100 
        defb    0b01000010 
        defb    0b01000010 
        defb    0b01111100 
        defb    0b01000100 
        defb    0b01000010 
        defb    0b00000000 
; Character: S
        defb    0b00000000 
        defb    0b00111100 
        defb    0b01000000 
        defb    0b00111100 
        defb    0b00000010 
        defb    0b01000010 
        defb    0b00111100 
        defb    0b00000000 
; Character: T
        defb    0b00000000 
        defb    0b11111110 
        defb    0b00010000 
        defb    0b00010000 
        defb    0b00010000 
        defb    0b00010000 
        defb    0b00010000 
        defb    0b00000000 
; Character: U
        defb    0b00000000 
        defb    0b01000010 
        defb    0b01000010 
        defb    0b01000010 
        defb    0b01000010 
        defb    0b01000010 
        defb    0b00111100 
        defb    0b00000000 
; Character: V
        defb    0b00000000 
        defb    0b01000010 
        defb    0b01000010 
        defb    0b01000010 
        defb    0b01000010 
        defb    0b00100100 
        defb    0b00011000 
        defb    0b00000000 
; Character: W
        defb    0b00000000 
        defb    0b01000010 
        defb    0b01000010 
        defb    0b01000010 
        defb    0b01000010 
        defb    0b01011010 
        defb    0b00100100 
        defb    0b00000000 
; Character: X
        defb    0b00000000 
        defb    0b01000010 
        defb    0b00100100 
        defb    0b00011000 
        defb    0b00011000 
        defb    0b00100100 
        defb    0b01000010 
        defb    0b00000000 
; Character: Y
        defb    0b00000000 
        defb    0b10000010 
        defb    0b01000100 
        defb    0b00101000 
        defb    0b00010000 
        defb    0b00010000 
        defb    0b00010000 
        defb    0b00000000 
; Character: Z
        defb    0b00000000 
        defb    0b01111110 
        defb    0b00000100 
        defb    0b00001000 
        defb    0b00010000 
        defb    0b00100000 
        defb    0b01111110 
        defb    0b00000000 
