
; multiplication code included by some CPCRSLIB module

   	    ld    h, ancho_pantalla_bytes
        LD    L, 0
        LD    D, L 
        LD    B, 8

MULT:   ADD   HL, HL
        JR    NC, NOADD
        ADD   HL, DE
NOADD:  DJNZ  MULT	

