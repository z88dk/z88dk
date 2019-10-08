; font_spect.ms
;	Text font
;	Michael Hope, 1998
;	michaelh@earthling.net
;	Distrubuted under the Artistic License - see www.opensource.org
;
	;; BANKED:	checked, imperfect
	SECTION	rodata_driver

	PUBLIC	_font_spect

_font_spect:
	defb	1+4		; 128 character encoding
	defb	128-32		; Tiles required

	defb	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0		; All map to space
	defb	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	defb	0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15	; 0x20
	defb	16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
	defb	32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47 ; 0x40
	defb	48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63
	defb	64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79 ; 0x60
	defb	80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95

	defb	0
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000000 
; Character: !
        defb    0b00000000 
        defb    0b00010000 
        defb    0b00010000 
        defb    0b00010000 
        defb    0b00010000 
        defb    0b00000000 
        defb    0b00010000 
        defb    0b00000000 
; Character: "
        defb    0b00000000 
        defb    0b00100100 
        defb    0b00100100 
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000000 
; Character: #
        defb    0b00000000 
        defb    0b00100100 
        defb    0b01111110 
        defb    0b00100100 
        defb    0b00100100 
        defb    0b01111110 
        defb    0b00100100 
        defb    0b00000000 
; Character: $
        defb    0b00000000 
        defb    0b00001000 
        defb    0b00111110 
        defb    0b00101000 
        defb    0b00111110 
        defb    0b00001010 
        defb    0b00111110 
        defb    0b00001000 
; Character: %
        defb    0b00000000 
        defb    0b01100010 
        defb    0b01100100 
        defb    0b00001000 
        defb    0b00010000 
        defb    0b00100110 
        defb    0b01000110 
        defb    0b00000000 
; Character: &
        defb    0b00000000 
        defb    0b00010000 
        defb    0b00101000 
        defb    0b00010000 
        defb    0b00101010 
        defb    0b01000100 
        defb    0b00111010 
        defb    0b00000000 
; Character: '
        defb    0b00000000 
        defb    0b00001000 
        defb    0b00010000 
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000000 
; Character: (
        defb    0b00000000 
        defb    0b00000100 
        defb    0b00001000 
        defb    0b00001000 
        defb    0b00001000 
        defb    0b00001000 
        defb    0b00000100 
        defb    0b00000000 
; Character: )
        defb    0b00000000 
        defb    0b00100000 
        defb    0b00010000 
        defb    0b00010000 
        defb    0b00010000 
        defb    0b00010000 
        defb    0b00100000 
        defb    0b00000000 
; Character: *
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00010100 
        defb    0b00001000 
        defb    0b00111110 
        defb    0b00001000 
        defb    0b00010100 
        defb    0b00000000 
; Character: +
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00001000 
        defb    0b00001000 
        defb    0b00111110 
        defb    0b00001000 
        defb    0b00001000 
        defb    0b00000000 
; Character: ,
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00001000 
        defb    0b00001000 
        defb    0b00010000 
; Character: -
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00111110 
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000000 
; Character: .
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00011000 
        defb    0b00011000 
        defb    0b00000000 
; Character: /
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000010 
        defb    0b00000100 
        defb    0b00001000 
        defb    0b00010000 
        defb    0b00100000 
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
; Character: :
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00010000 
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00010000 
        defb    0b00000000 
; Character: ;
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00010000 
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00010000 
        defb    0b00010000 
        defb    0b00100000 
; Character: <
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000100 
        defb    0b00001000 
        defb    0b00010000 
        defb    0b00001000 
        defb    0b00000100 
        defb    0b00000000 
; Character: =
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00111110 
        defb    0b00000000 
        defb    0b00111110 
        defb    0b00000000 
        defb    0b00000000 
; Character: >
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00010000 
        defb    0b00001000 
        defb    0b00000100 
        defb    0b00001000 
        defb    0b00010000 
        defb    0b00000000 
; Character: ?
        defb    0b00000000 
        defb    0b00111100 
        defb    0b01000010 
        defb    0b00000100 
        defb    0b00001000 
        defb    0b00000000 
        defb    0b00001000 
        defb    0b00000000 
; Character: @
        defb    0b00000000 
        defb    0b00111100 
        defb    0b01001010 
        defb    0b01010110 
        defb    0b01011110 
        defb    0b01000000 
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
; Character: [
        defb    0b00000000 
        defb    0b00001110 
        defb    0b00001000 
        defb    0b00001000 
        defb    0b00001000 
        defb    0b00001000 
        defb    0b00001110 
        defb    0b00000000 
; Character: \
        defb    0b00000000 
        defb    0b00000000 
        defb    0b01000000 
        defb    0b00100000 
        defb    0b00010000 
        defb    0b00001000 
        defb    0b00000100 
        defb    0b00000000 
; Character: ]
        defb    0b00000000 
        defb    0b01110000 
        defb    0b00010000 
        defb    0b00010000 
        defb    0b00010000 
        defb    0b00010000 
        defb    0b01110000 
        defb    0b00000000 
; Character: ^
        defb    0b00000000 
        defb    0b00010000 
        defb    0b00111000 
        defb    0b01010100 
        defb    0b00010000 
        defb    0b00010000 
        defb    0b00010000 
        defb    0b00000000 
; Character: _
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000000 
        defb    0b11111111 
; Character: Pound
        defb    0b00000000 
        defb    0b00011100 
        defb    0b00100010 
        defb    0b01111000 
        defb    0b00100000 
        defb    0b00100000 
        defb    0b01111110 
        defb    0b00000000 
; Character: a
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00111000 
        defb    0b00000100 
        defb    0b00111100 
        defb    0b01000100 
        defb    0b00111100 
        defb    0b00000000 
; Character: b
        defb    0b00000000 
        defb    0b00100000 
        defb    0b00100000 
        defb    0b00111100 
        defb    0b00100010 
        defb    0b00100010 
        defb    0b00111100 
        defb    0b00000000 
; Character: c
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00011100 
        defb    0b00100000 
        defb    0b00100000 
        defb    0b00100000 
        defb    0b00011100 
        defb    0b00000000 
; Character: d
        defb    0b00000000 
        defb    0b00000100 
        defb    0b00000100 
        defb    0b00111100 
        defb    0b01000100 
        defb    0b01000100 
        defb    0b00111100 
        defb    0b00000000 
; Character: e
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00111000 
        defb    0b01000100 
        defb    0b01111000 
        defb    0b01000000 
        defb    0b00111100 
        defb    0b00000000 
; Character: f
        defb    0b00000000 
        defb    0b00001100 
        defb    0b00010000 
        defb    0b00011000 
        defb    0b00010000 
        defb    0b00010000 
        defb    0b00010000 
        defb    0b00000000 
; Character: g
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00111100 
        defb    0b01000100 
        defb    0b01000100 
        defb    0b00111100 
        defb    0b00000100 
        defb    0b00111000 
; Character: h
        defb    0b00000000 
        defb    0b01000000 
        defb    0b01000000 
        defb    0b01111000 
        defb    0b01000100 
        defb    0b01000100 
        defb    0b01000100 
        defb    0b00000000 
; Character: i
        defb    0b00000000 
        defb    0b00010000 
        defb    0b00000000 
        defb    0b00110000 
        defb    0b00010000 
        defb    0b00010000 
        defb    0b00111000 
        defb    0b00000000 
; Character: j
        defb    0b00000000 
        defb    0b00000100 
        defb    0b00000000 
        defb    0b00000100 
        defb    0b00000100 
        defb    0b00000100 
        defb    0b00100100 
        defb    0b00011000 
; Character: k
        defb    0b00000000 
        defb    0b00100000 
        defb    0b00101000 
        defb    0b00110000 
        defb    0b00110000 
        defb    0b00101000 
        defb    0b00100100 
        defb    0b00000000 
; Character: l
        defb    0b00000000 
        defb    0b00010000 
        defb    0b00010000 
        defb    0b00010000 
        defb    0b00010000 
        defb    0b00010000 
        defb    0b00001100 
        defb    0b00000000 
; Character: m
        defb    0b00000000 
        defb    0b00000000 
        defb    0b01101000 
        defb    0b01010100 
        defb    0b01010100 
        defb    0b01010100 
        defb    0b01010100 
        defb    0b00000000 
; Character: n
        defb    0b00000000 
        defb    0b00000000 
        defb    0b01111000 
        defb    0b01000100 
        defb    0b01000100 
        defb    0b01000100 
        defb    0b01000100 
        defb    0b00000000 
; Character: o
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00111000 
        defb    0b01000100 
        defb    0b01000100 
        defb    0b01000100 
        defb    0b00111000 
        defb    0b00000000 
; Character: p
        defb    0b00000000 
        defb    0b00000000 
        defb    0b01111000 
        defb    0b01000100 
        defb    0b01000100 
        defb    0b01111000 
        defb    0b01000000 
        defb    0b01000000 
; Character: q
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00111100 
        defb    0b01000100 
        defb    0b01000100 
        defb    0b00111100 
        defb    0b00000100 
        defb    0b00000110 
; Character: r
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00011100 
        defb    0b00100000 
        defb    0b00100000 
        defb    0b00100000 
        defb    0b00100000 
        defb    0b00000000 
; Character: s
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00111000 
        defb    0b01000000 
        defb    0b00111000 
        defb    0b00000100 
        defb    0b01111000 
        defb    0b00000000 
; Character: t
        defb    0b00000000 
        defb    0b00010000 
        defb    0b00111000 
        defb    0b00010000 
        defb    0b00010000 
        defb    0b00010000 
        defb    0b00001100 
        defb    0b00000000 
; Character: u
        defb    0b00000000 
        defb    0b00000000 
        defb    0b01000100 
        defb    0b01000100 
        defb    0b01000100 
        defb    0b01000100 
        defb    0b00111000 
        defb    0b00000000 
; Character: v
        defb    0b00000000 
        defb    0b00000000 
        defb    0b01000100 
        defb    0b01000100 
        defb    0b00101000 
        defb    0b00101000 
        defb    0b00010000 
        defb    0b00000000 
; Character: w
        defb    0b00000000 
        defb    0b00000000 
        defb    0b01000100 
        defb    0b01010100 
        defb    0b01010100 
        defb    0b01010100 
        defb    0b00101000 
        defb    0b00000000 
; Character: x
        defb    0b00000000 
        defb    0b00000000 
        defb    0b01000100 
        defb    0b00101000 
        defb    0b00010000 
        defb    0b00101000 
        defb    0b01000100 
        defb    0b00000000 
; Character: y
        defb    0b00000000 
        defb    0b00000000 
        defb    0b01000100 
        defb    0b01000100 
        defb    0b01000100 
        defb    0b00111100 
        defb    0b00000100 
        defb    0b00111000 
; Character: z
        defb    0b00000000 
        defb    0b00000000 
        defb    0b01111100 
        defb    0b00001000 
        defb    0b00010000 
        defb    0b00100000 
        defb    0b01111100 
        defb    0b00000000 
; Character: {
        defb    0b00000000 
        defb    0b00001110 
        defb    0b00001000 
        defb    0b00110000 
        defb    0b00001000 
        defb    0b00001000 
        defb    0b00001110 
        defb    0b00000000 
; Character: |
        defb    0b00000000 
        defb    0b00001000 
        defb    0b00001000 
        defb    0b00001000 
        defb    0b00001000 
        defb    0b00001000 
        defb    0b00001000 
        defb    0b00000000 
; Character: }
        defb    0b00000000 
        defb    0b01110000 
        defb    0b00010000 
        defb    0b00001100 
        defb    0b00010000 
        defb    0b00010000 
        defb    0b01110000 
        defb    0b00000000 
; Character: ~
        defb    0b00000000 
        defb    0b00010100 
        defb    0b00101000 
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000000 
        defb    0b00000000 
; Character: Copyright
        defb    0b00111100 
        defb    0b01000010 
        defb    0b10011001 
        defb    0b10100001 
        defb    0b10100001 
        defb    0b10011001 
        defb    0b01000010 
        defb    0b00111100 
