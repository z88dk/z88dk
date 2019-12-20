;
; Header for the standard z88dk fonts to add the required magic needed
; for gbdk + some lores graphics characters
;

	defb	2+4	;256 char encoding, compressed
	defb	128	;Number of tiles

; Character: ? (00)
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@00000000

; Character: ? (01)
        defb    0b00011000      ;    oo
        defb    0b00100100      ;   o  o
        defb    0b01000010      ;  o    o
        defb    0b10000001      ; o      o
        defb    0b11100111      ; ooo  ooo
        defb    0b00100100      ;   o  o
        defb    0b00100100      ;   o  o
        defb    0b00111100      ;   oooo

; Character: ? (02)
        defb    0b00111100      ;   oooo
        defb    0b00100100      ;   o  o
        defb    0b00100100      ;   o  o
        defb    0b11100111      ; ooo  ooo
        defb    0b10000001      ; o      o
        defb    0b01000010      ;  o    o
        defb    0b00100100      ;   o  o
        defb    0b00011000      ;    oo

; Character: ? (03)
        defb    0b00011000      ;    oo
        defb    0b00010100      ;    o o
        defb    0b11110010      ; oooo  o
        defb    0b10000001      ; o      o
        defb    0b10000001      ; o      o
        defb    0b11110010      ; oooo  o
        defb    0b00010100      ;    o o
        defb    0b00011000      ;    oo

; Character: ? (04)
        defb    0b00011000      ;    oo
        defb    0b00101000      ;   o o
        defb    0b01001111      ;  o  oooo
        defb    0b10000001      ; o      o
        defb    0b10000001      ; o      o
        defb    0b01001111      ;  o  oooo
        defb    0b00101000      ;   o o
        defb    0b00011000      ;    oo

; Character: ? (05)
	defb	@11110000
	defb	@11110000
	defb	@11110000
	defb	@11110000
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@00000000

; Character: ? (06)
	defb	@00001111
	defb	@00001111
	defb	@00001111
	defb	@00001111
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@00000000

; Character: ? (07)
	defb	@11111111
	defb	@11111111
	defb	@11111111
	defb	@11111111
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@00000000
; Character: ? (08)
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@11110000
	defb	@11110000
	defb	@11110000
	defb	@11110000
; Character: ? (09)
	defb	@11110000
	defb	@11110000
	defb	@11110000
	defb	@11110000
	defb	@11110000
	defb	@11110000
	defb	@11110000
	defb	@11110000
; Character: ? (0a)
	defb	@00001111
	defb	@00001111
	defb	@00001111
	defb	@00001111
	defb	@11110000
	defb	@11110000
	defb	@11110000
	defb	@11110000
; Character: ? (0b)
	defb	@11111111
	defb	@11111111
	defb	@11111111
	defb	@11111111
	defb	@11110000
	defb	@11110000
	defb	@11110000
	defb	@11110000
; Character: ? (0c)
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@00001111
	defb	@00001111
	defb	@00001111
	defb	@00001111

; Character: ? (0D)
        defb    0b01110000      ;  ooo
        defb    0b11001000      ; oo  o
        defb    0b11011110      ; oo oooo
        defb    0b11011011      ; oo oo oo
        defb    0b11011011      ; oo oo oo
        defb    0b01111110      ;  oooooo
        defb    0b00011011      ;    oo oo
        defb    0b00011011      ;    oo oo

; Character: ? (0E)
        defb    0b00000000      ;
        defb    0b00000000      ;
        defb    0b00000000      ;
        defb    0b11111111      ; oooooooo
        defb    0b11111111      ; oooooooo
        defb    0b11111111      ; oooooooo
        defb    0b00000000      ;
        defb    0b00000000      ;

; Character: ? (0F)
        defb    0b00011100      ;    ooo
        defb    0b00011100      ;    ooo
        defb    0b00011100      ;    ooo
        defb    0b00011100      ;    ooo
        defb    0b00011100      ;    ooo
        defb    0b00011100      ;    ooo
        defb    0b00011100      ;    ooo
        defb    0b00011100      ;    ooo

; Character: ? (10)
	defb	@11110000
	defb	@11110000
	defb	@11110000
	defb	@11110000
	defb	@00001111
	defb	@00001111
	defb	@00001111
	defb	@00001111
; Character: ? (11)
	defb	@00001111
	defb	@00001111
	defb	@00001111
	defb	@00001111
	defb	@00001111
	defb	@00001111
	defb	@00001111
	defb	@00001111
; Character: ? (12)
	defb	@11111111
	defb	@11111111
	defb	@11111111
	defb	@11111111
	defb	@00001111
	defb	@00001111
	defb	@00001111
	defb	@00001111
; Character: ? (13)
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@11111111
	defb	@11111111
	defb	@11111111
	defb	@11111111
; Character: ? (14)
	defb	@11110000
	defb	@11110000
	defb	@11110000
	defb	@11110000
	defb	@11111111
	defb	@11111111
	defb	@11111111
	defb	@11111111
; Character: ? (15)
	defb	@00001111
	defb	@00001111
	defb	@00001111
	defb	@00001111
	defb	@11111111
	defb	@11111111
	defb	@11111111
	defb	@11111111
; Character: ? (16)
	defb	@11111111
	defb	@11111111
	defb	@11111111
	defb	@11111111
	defb	@11111111
	defb	@11111111
	defb	@11111111
	defb	@11111111
; Character: ? (17)
	defb	@10101010
	defb	@01010101
	defb	@10101010
	defb	@01010101
	defb	@10101010
	defb	@01010101
	defb	@10101010
	defb	@01010101
; Character: ? (18)
	defb	@10101010
	defb	@01010101
	defb	@10101010
	defb	@01010101
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@00000000
; Character: ? (19)
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@10101010
	defb	@01010101
	defb	@10101010
	defb	@01010101
; Character: ? (1A)
	defb	@00001010
	defb	@00000101
	defb	@00001010
	defb	@00000101
	defb	@00001010
	defb	@00000101
	defb	@00001010
	defb	@00000101
; Character: ? (1B)
	defb	@10100000
	defb	@01010000
	defb	@10100000
	defb	@01010000
	defb	@10100000
	defb	@01010000
	defb	@10100000
	defb	@01010000

; Character: ? (1C)
        defb    0b00000000      ;
        defb    0b00000000      ;
        defb    0b00000000      ;
        defb    0b00011111      ;    ooooo
        defb    0b00011111      ;    ooooo
        defb    0b00011111      ;    ooooo
        defb    0b00011100      ;    ooo
        defb    0b00011100      ;    ooo

; Character: ? (1D)
        defb    0b00000000      ;
        defb    0b00000000      ;
        defb    0b00000000      ;
        defb    0b11111100      ; oooooo
        defb    0b11111100      ; oooooo
        defb    0b11111100      ; oooooo
        defb    0b00011100      ;    ooo
        defb    0b00011100      ;    ooo


; Character: ? (1E)
        defb    0b00011100      ;    ooo
        defb    0b00011100      ;    ooo
        defb    0b00011100      ;    ooo
        defb    0b00011111      ;    ooooo
        defb    0b00011111      ;    ooooo
        defb    0b00011111      ;    ooooo
        defb    0b00000000      ;
        defb    0b00000000      ;

; Character: ? (1F)
        defb    0b00011100      ;    ooo
        defb    0b00011100      ;    ooo
        defb    0b00011100      ;    ooo
        defb    0b11111100      ; oooooo
        defb    0b11111100      ; oooooo
        defb    0b11111100      ; oooooo
        defb    0b00000000      ;
        defb    0b00000000      ;
