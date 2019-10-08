; font: font
	;; BANKED: checked

	SECTION rodata_driver
	GLOBAL	font_load

	PUBLIC	_font_ibm_fixed


_font_ibm_fixed:
	defb	0+4	; 256 char encoding, compressed
	defb	255	; Number of tiles

; Encoding table

	; Hack
	defb 0x00
	defb 0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08
	defb 0x09,0x0A,0x0B,0x0C,0x0D,0x0E,0x0F,0x10
	defb 0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x18
	defb 0x19,0x1A,0x1B,0x1C,0x1D,0x1E,0x1F,0x20
	defb 0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28
	defb 0x29,0x2A,0x2B,0x2C,0x2D,0x2E,0x2F,0x30
	defb 0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38
	defb 0x39,0x3A,0x3B,0x3C,0x3D,0x3E,0x3F,0x40
	defb 0x41,0x42,0x43,0x44,0x45,0x46,0x47,0x48
	defb 0x49,0x4A,0x4B,0x4C,0x4D,0x4E,0x4F,0x50
	defb 0x51,0x52,0x53,0x54,0x55,0x56,0x57,0x58
	defb 0x59,0x5A,0x5B,0x5C,0x5D,0x5E,0x5F,0x60
	defb 0x61,0x62,0x63,0x64,0x65,0x66,0x67,0x68
	defb 0x69,0x6A,0x6B,0x6C,0x6D,0x6E,0x6F,0x70
	defb 0x71,0x72,0x73,0x74,0x75,0x76,0x77,0x78
	defb 0x79,0x7A,0x7B,0x7C,0x7D,0x7E,0x7F,0x80
	defb 0x81,0x82,0x83,0x84,0x85,0x86,0x87,0x88
	defb 0x89,0x8A,0x8B,0x8C,0x8D,0x8E,0x8F,0x90
	defb 0x91,0x92,0x93,0x94,0x95,0x96,0x97,0x98
	defb 0x99,0x9A,0x9B,0x9C,0x9D,0x9E,0x9F,0xA0
	defb 0xA1,0xA2,0xA3,0xA4,0xA5,0xA6,0xA7,0xA8
	defb 0xA9,0xAA,0xAB,0xAC,0xAD,0xAE,0xAF,0xB0
	defb 0xB1,0xB2,0xB3,0xB4,0xB5,0xB6,0xB7,0xB8
	defb 0xB9,0xBA,0xBB,0xBC,0xBD,0xBE,0xBF,0xC0
	defb 0xC1,0xC2,0xC3,0xC4,0xC5,0xC6,0xC7,0xC8
	defb 0xC9,0xCA,0xCB,0xCC,0xCD,0xCE,0xCF,0xD0
	defb 0xD1,0xD2,0xD3,0xD4,0xD5,0xD6,0xD7,0xD8
	defb 0xD9,0xDA,0xDB,0xDC,0xDD,0xDE,0xDF,0xE0
	defb 0xE1,0xE2,0xE3,0xE4,0xE5,0xE6,0xE7,0xE8
	defb 0xE9,0xEA,0xEB,0xEC,0xED,0xEE,0xEF,0xF0
	defb 0xF1,0xF2,0xF3,0xF4,0xF5,0xF6,0xF7,0xF8
	defb 0xF9,0xFA,0xFB,0xFC,0xFD,0xFE,0xFF
	; Tile data
	;; Hook for the graphics routines
_font_ibm_fixed_tiles:
; Default character (space)
	defb	0b00000000
	defb	0b00000000
	defb	0b00000000
	defb	0b00000000
	defb	0b00000000
	defb	0b00000000
	defb	0b00000000
	defb	0b00000000

; Character: ? (01)
	defb	0b00011000	;    oo   
	defb	0b00100100	;   o  o  
	defb	0b01000010	;  o    o 
	defb	0b10000001	; o      o
	defb	0b11100111	; ooo  ooo
	defb	0b00100100	;   o  o  
	defb	0b00100100	;   o  o  
	defb	0b00111100	;   oooo  

; Character: ? (02)
	defb	0b00111100	;   oooo  
	defb	0b00100100	;   o  o  
	defb	0b00100100	;   o  o  
	defb	0b11100111	; ooo  ooo
	defb	0b10000001	; o      o
	defb	0b01000010	;  o    o 
	defb	0b00100100	;   o  o  
	defb	0b00011000	;    oo   

; Character: ? (03)
	defb	0b00011000	;    oo   
	defb	0b00010100	;    o o  
	defb	0b11110010	; oooo  o 
	defb	0b10000001	; o      o
	defb	0b10000001	; o      o
	defb	0b11110010	; oooo  o 
	defb	0b00010100	;    o o  
	defb	0b00011000	;    oo   

; Character: ? (04)
	defb	0b00011000	;    oo   
	defb	0b00101000	;   o o   
	defb	0b01001111	;  o  oooo
	defb	0b10000001	; o      o
	defb	0b10000001	; o      o
	defb	0b01001111	;  o  oooo
	defb	0b00101000	;   o o   
	defb	0b00011000	;    oo   

; Character: ? (05)
	defb	0b11111111	; oooooooo
	defb	0b10000001	; o      o
	defb	0b10000001	; o      o
	defb	0b10000001	; o      o
	defb	0b10000001	; o      o
	defb	0b10000001	; o      o
	defb	0b10000001	; o      o
	defb	0b11111111	; oooooooo

; Character: ? (06)
	defb	0b11111000	; ooooo   
	defb	0b10001000	; o   o   
	defb	0b10001111	; o   oooo
	defb	0b10001001	; o   o  o
	defb	0b11111001	; ooooo  o
	defb	0b01000001	;  o     o
	defb	0b01000001	;  o     o
	defb	0b01111111	;  ooooooo

; Character: ? (07)
	defb	0b11111111	; oooooooo
	defb	0b10001001	; o   o  o
	defb	0b10001001	; o   o  o
	defb	0b10001001	; o   o  o
	defb	0b11111001	; ooooo  o
	defb	0b10000001	; o      o
	defb	0b10000001	; o      o
	defb	0b11111111	; oooooooo

; Character: ? (08)
	defb	0b00000001	;        o
	defb	0b00000011	;       oo
	defb	0b00000110	;      oo 
	defb	0b10001100	; o   oo  
	defb	0b11011000	; oo oo   
	defb	0b01110000	;  ooo    
	defb	0b00100000	;   o     
	defb	0b00000000	;         

; Character: ? (09)
	defb	0b01111110	;  oooooo 
	defb	0b11000011	; oo    oo
	defb	0b11010011	; oo o  oo
	defb	0b11010011	; oo o  oo
	defb	0b11011011	; oo oo oo
	defb	0b11000011	; oo    oo
	defb	0b11000011	; oo    oo
	defb	0b01111110	;  oooooo 

; Character: ? (0A)
	defb	0b00011000	;    oo   
	defb	0b00111100	;   oooo  
	defb	0b00101100	;   o oo  
	defb	0b00101100	;   o oo  
	defb	0b01111110	;  oooooo 
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00000000	;         

; Character: ? (0B)
	defb	0b00010000	;    o    
	defb	0b00011100	;    ooo  
	defb	0b00010010	;    o  o 
	defb	0b00010000	;    o    
	defb	0b00010000	;    o    
	defb	0b01110000	;  ooo    
	defb	0b11110000	; oooo    
	defb	0b01100000	;  oo     

; Character: ? (0C)
	defb	0b11110000	; oooo    
	defb	0b11000000	; oo      
	defb	0b11111110	; ooooooo 
	defb	0b11011000	; oo oo   
	defb	0b11011110	; oo oooo 
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00000000	;         

; Character: ? (0D)
	defb	0b01110000	;  ooo    
	defb	0b11001000	; oo  o   
	defb	0b11011110	; oo oooo 
	defb	0b11011011	; oo oo oo
	defb	0b11011011	; oo oo oo
	defb	0b01111110	;  oooooo 
	defb	0b00011011	;    oo oo
	defb	0b00011011	;    oo oo

; Character: ? (0E)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b11111111	; oooooooo
	defb	0b11111111	; oooooooo
	defb	0b11111111	; oooooooo
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (0F)
	defb	0b00011100	;    ooo  
	defb	0b00011100	;    ooo  
	defb	0b00011100	;    ooo  
	defb	0b00011100	;    ooo  
	defb	0b00011100	;    ooo  
	defb	0b00011100	;    ooo  
	defb	0b00011100	;    ooo  
	defb	0b00011100	;    ooo  

; Character: ? (10)
	defb	0b01111100	;  ooooo  
	defb	0b11000110	; oo   oo 
	defb	0b11000110	; oo   oo 
	defb	0b00000000	;         
	defb	0b11000110	; oo   oo 
	defb	0b11000110	; oo   oo 
	defb	0b01111100	;  ooooo  
	defb	0b00000000	;         

; Character: ? (11)
	defb	0b00000110	;      oo 
	defb	0b00000110	;      oo 
	defb	0b00000110	;      oo 
	defb	0b00000000	;         
	defb	0b00000110	;      oo 
	defb	0b00000110	;      oo 
	defb	0b00000110	;      oo 
	defb	0b00000000	;         

; Character: ? (12)
	defb	0b01111100	;  ooooo  
	defb	0b00000110	;      oo 
	defb	0b00000110	;      oo 
	defb	0b01111100	;  ooooo  
	defb	0b11000000	; oo      
	defb	0b11000000	; oo      
	defb	0b01111100	;  ooooo  
	defb	0b00000000	;         

; Character: ? (13)
	defb	0b01111100	;  ooooo  
	defb	0b00000110	;      oo 
	defb	0b00000110	;      oo 
	defb	0b01111100	;  ooooo  
	defb	0b00000110	;      oo 
	defb	0b00000110	;      oo 
	defb	0b01111100	;  ooooo  
	defb	0b00000000	;         

; Character: ? (14)
	defb	0b11000110	; oo   oo 
	defb	0b11000110	; oo   oo 
	defb	0b11000110	; oo   oo 
	defb	0b01111100	;  ooooo  
	defb	0b00000110	;      oo 
	defb	0b00000110	;      oo 
	defb	0b00000110	;      oo 
	defb	0b00000000	;         

; Character: ? (15)
	defb	0b01111100	;  ooooo  
	defb	0b11000000	; oo      
	defb	0b11000000	; oo      
	defb	0b01111100	;  ooooo  
	defb	0b00000110	;      oo 
	defb	0b00000110	;      oo 
	defb	0b01111100	;  ooooo  
	defb	0b00000000	;         

; Character: ? (16)
	defb	0b01111100	;  ooooo  
	defb	0b11000000	; oo      
	defb	0b11000000	; oo      
	defb	0b01111100	;  ooooo  
	defb	0b11000110	; oo   oo 
	defb	0b11000110	; oo   oo 
	defb	0b01111100	;  ooooo  
	defb	0b00000000	;         

; Character: ? (17)
	defb	0b01111100	;  ooooo  
	defb	0b00000110	;      oo 
	defb	0b00000110	;      oo 
	defb	0b00000000	;         
	defb	0b00000110	;      oo 
	defb	0b00000110	;      oo 
	defb	0b00000110	;      oo 
	defb	0b00000000	;         

; Character: ? (18)
	defb	0b01111100	;  ooooo  
	defb	0b11000110	; oo   oo 
	defb	0b11000110	; oo   oo 
	defb	0b01111100	;  ooooo  
	defb	0b11000110	; oo   oo 
	defb	0b11000110	; oo   oo 
	defb	0b01111100	;  ooooo  
	defb	0b00000000	;         

; Character: ? (19)
	defb	0b01111100	;  ooooo  
	defb	0b11000110	; oo   oo 
	defb	0b11000110	; oo   oo 
	defb	0b01111100	;  ooooo  
	defb	0b00000110	;      oo 
	defb	0b00000110	;      oo 
	defb	0b01111100	;  ooooo  
	defb	0b00000000	;         

; Character: ? (1A)
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b01000110	;  o   oo 
	defb	0b00000110	;      oo 
	defb	0b01111110	;  oooooo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111100	;   oooo  
	defb	0b00000000	;         

; Character: ? (1B)
	defb	0b01111000	;  oooo   
	defb	0b01100110	;  oo  oo 
	defb	0b01111101	;  ooooo o
	defb	0b01100100	;  oo  o  
	defb	0b01111110	;  oooooo 
	defb	0b00000011	;       oo
	defb	0b00001011	;     o oo
	defb	0b00000110	;      oo 

; Character: ? (1C)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00011111	;    ooooo
	defb	0b00011111	;    ooooo
	defb	0b00011111	;    ooooo
	defb	0b00011100	;    ooo  
	defb	0b00011100	;    ooo  

; Character: ? (1D)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b11111100	; oooooo  
	defb	0b11111100	; oooooo  
	defb	0b11111100	; oooooo  
	defb	0b00011100	;    ooo  
	defb	0b00011100	;    ooo  

; Character: ? (1E)
	defb	0b00011100	;    ooo  
	defb	0b00011100	;    ooo  
	defb	0b00011100	;    ooo  
	defb	0b00011111	;    ooooo
	defb	0b00011111	;    ooooo
	defb	0b00011111	;    ooooo
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (1F)
	defb	0b00011100	;    ooo  
	defb	0b00011100	;    ooo  
	defb	0b00011100	;    ooo  
	defb	0b11111100	; oooooo  
	defb	0b11111100	; oooooo  
	defb	0b11111100	; oooooo  
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character:   (20)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ! (21)
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00000000	;         
	defb	0b00011000	;    oo   
	defb	0b00000000	;         

; Character: " (22)
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01000100	;  o   o  
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: # (23)
	defb	0b00000000	;         
	defb	0b00100100	;   o  o  
	defb	0b01111110	;  oooooo 
	defb	0b00100100	;   o  o  
	defb	0b00100100	;   o  o  
	defb	0b01111110	;  oooooo 
	defb	0b00100100	;   o  o  
	defb	0b00000000	;         

; Character: $ (24)
	defb	0b00010100	;    o o  
	defb	0b00111110	;   ooooo 
	defb	0b01010101	;  o o o o
	defb	0b00111100	;   oooo  
	defb	0b00011110	;    oooo 
	defb	0b01010101	;  o o o o
	defb	0b00111110	;   ooooo 
	defb	0b00010100	;    o o  

; Character: % (25)
	defb	0b01100010	;  oo   o 
	defb	0b01100110	;  oo  oo 
	defb	0b00001100	;     oo  
	defb	0b00011000	;    oo   
	defb	0b00110000	;   oo    
	defb	0b01100110	;  oo  oo 
	defb	0b01000110	;  o   oo 
	defb	0b00000000	;         

; Character: & (26)
	defb	0b01111000	;  oooo   
	defb	0b11001100	; oo  oo  
	defb	0b01100001	;  oo    o
	defb	0b11001110	; oo  ooo 
	defb	0b11001100	; oo  oo  
	defb	0b11001100	; oo  oo  
	defb	0b01111000	;  oooo   
	defb	0b00000000	;         

; Character: ' (27)
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00010000	;    o    
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ( (28)
	defb	0b00000100	;      o  
	defb	0b00001000	;     o   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00001000	;     o   
	defb	0b00000100	;      o  

; Character: ) (29)
	defb	0b00100000	;   o     
	defb	0b00010000	;    o    
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00010000	;    o    
	defb	0b00100000	;   o     

; Character: * (2A)
	defb	0b00000000	;         
	defb	0b01010100	;  o o o  
	defb	0b00111000	;   ooo   
	defb	0b11111110	; ooooooo 
	defb	0b00111000	;   ooo   
	defb	0b01010100	;  o o o  
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: + (2B)
	defb	0b00000000	;         
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b01111110	;  oooooo 
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: , (2C)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00110000	;   oo    
	defb	0b00110000	;   oo    
	defb	0b00100000	;   o     

; Character: - (2D)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: . (2E)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00000000	;         

; Character: / (2F)
	defb	0b00000011	;       oo
	defb	0b00000110	;      oo 
	defb	0b00001100	;     oo  
	defb	0b00011000	;    oo   
	defb	0b00110000	;   oo    
	defb	0b01100000	;  oo     
	defb	0b11000000	; oo      
	defb	0b00000000	;         

; Character: 0 (30)
	defb	0b00111100	;   oooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01101110	;  oo ooo 
	defb	0b01110110	;  ooo oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111100	;   oooo  
	defb	0b00000000	;         

; Character: 1 (31)
	defb	0b00011000	;    oo   
	defb	0b00111000	;   ooo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00000000	;         

; Character: 2 (32)
	defb	0b00111100	;   oooo  
	defb	0b01100110	;  oo  oo 
	defb	0b00001110	;     ooo 
	defb	0b00011100	;    ooo  
	defb	0b00111000	;   ooo   
	defb	0b01110000	;  ooo    
	defb	0b01111110	;  oooooo 
	defb	0b00000000	;         

; Character: 3 (33)
	defb	0b01111110	;  oooooo 
	defb	0b00001100	;     oo  
	defb	0b00011000	;    oo   
	defb	0b00111100	;   oooo  
	defb	0b00000110	;      oo 
	defb	0b01000110	;  o   oo 
	defb	0b00111100	;   oooo  
	defb	0b00000000	;         

; Character: 4 (34)
	defb	0b00001100	;     oo  
	defb	0b00011100	;    ooo  
	defb	0b00101100	;   o oo  
	defb	0b01001100	;  o  oo  
	defb	0b01111110	;  oooooo 
	defb	0b00001100	;     oo  
	defb	0b00001100	;     oo  
	defb	0b00000000	;         

; Character: 5 (35)
	defb	0b01111110	;  oooooo 
	defb	0b01100000	;  oo     
	defb	0b01111100	;  ooooo  
	defb	0b00000110	;      oo 
	defb	0b00000110	;      oo 
	defb	0b01000110	;  o   oo 
	defb	0b00111100	;   oooo  
	defb	0b00000000	;         

; Character: 6 (36)
	defb	0b00011100	;    ooo  
	defb	0b00100000	;   o     
	defb	0b01100000	;  oo     
	defb	0b01111100	;  ooooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111100	;   oooo  
	defb	0b00000000	;         

; Character: 7 (37)
	defb	0b01111110	;  oooooo 
	defb	0b00000110	;      oo 
	defb	0b00001110	;     ooo 
	defb	0b00011100	;    ooo  
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00000000	;         

; Character: 8 (38)
	defb	0b00111100	;   oooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111100	;   oooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111100	;   oooo  
	defb	0b00000000	;         

; Character: 9 (39)
	defb	0b00111100	;   oooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111110	;   ooooo 
	defb	0b00000110	;      oo 
	defb	0b00001100	;     oo  
	defb	0b00111000	;   ooo   
	defb	0b00000000	;         

; Character: : (3A)
	defb	0b00000000	;         
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00000000	;         

; Character: ; (3B)
	defb	0b00000000	;         
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00000000	;         
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00010000	;    o    
	defb	0b00000000	;         

; Character: < (3C)
	defb	0b00000110	;      oo 
	defb	0b00001100	;     oo  
	defb	0b00011000	;    oo   
	defb	0b00110000	;   oo    
	defb	0b00011000	;    oo   
	defb	0b00001100	;     oo  
	defb	0b00000110	;      oo 
	defb	0b00000000	;         

; Character: = (3D)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: > (3E)
	defb	0b01100000	;  oo     
	defb	0b00110000	;   oo    
	defb	0b00011000	;    oo   
	defb	0b00001100	;     oo  
	defb	0b00011000	;    oo   
	defb	0b00110000	;   oo    
	defb	0b01100000	;  oo     
	defb	0b00000000	;         

; Character: ? (3F)
	defb	0b00111100	;   oooo  
	defb	0b01000110	;  o   oo 
	defb	0b00000110	;      oo 
	defb	0b00001100	;     oo  
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00000000	;         
	defb	0b00011000	;    oo   

; Character: @ (40)
	defb	0b00111100	;   oooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01101110	;  oo ooo 
	defb	0b01101010	;  oo o o 
	defb	0b01101110	;  oo ooo 
	defb	0b01100000	;  oo     
	defb	0b00111100	;   oooo  
	defb	0b00000000	;         

; Character: A (41)
	defb	0b00111100	;   oooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01111110	;  oooooo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00000000	;         

; Character: B (42)
	defb	0b01111100	;  ooooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01111100	;  ooooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01111100	;  ooooo  
	defb	0b00000000	;         

; Character: C (43)
	defb	0b00111100	;   oooo  
	defb	0b01100010	;  oo   o 
	defb	0b01100000	;  oo     
	defb	0b01100000	;  oo     
	defb	0b01100000	;  oo     
	defb	0b01100010	;  oo   o 
	defb	0b00111100	;   oooo  
	defb	0b00000000	;         

; Character: D (44)
	defb	0b01111100	;  ooooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01111100	;  ooooo  
	defb	0b00000000	;         

; Character: E (45)
	defb	0b01111110	;  oooooo 
	defb	0b01100000	;  oo     
	defb	0b01100000	;  oo     
	defb	0b01111100	;  ooooo  
	defb	0b01100000	;  oo     
	defb	0b01100000	;  oo     
	defb	0b01111110	;  oooooo 
	defb	0b00000000	;         

; Character: F (46)
	defb	0b01111110	;  oooooo 
	defb	0b01100000	;  oo     
	defb	0b01100000	;  oo     
	defb	0b01111100	;  ooooo  
	defb	0b01100000	;  oo     
	defb	0b01100000	;  oo     
	defb	0b01100000	;  oo     
	defb	0b00000000	;         

; Character: G (47)
	defb	0b00111100	;   oooo  
	defb	0b01100010	;  oo   o 
	defb	0b01100000	;  oo     
	defb	0b01101110	;  oo ooo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111110	;   ooooo 
	defb	0b00000000	;         

; Character: H (48)
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01111110	;  oooooo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00000000	;         

; Character: I (49)
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00000000	;         

; Character: J (4A)
	defb	0b00000110	;      oo 
	defb	0b00000110	;      oo 
	defb	0b00000110	;      oo 
	defb	0b00000110	;      oo 
	defb	0b00000110	;      oo 
	defb	0b01000110	;  o   oo 
	defb	0b00111100	;   oooo  
	defb	0b00000000	;         

; Character: K (4B)
	defb	0b01100110	;  oo  oo 
	defb	0b01101100	;  oo oo  
	defb	0b01111000	;  oooo   
	defb	0b01110000	;  ooo    
	defb	0b01111000	;  oooo   
	defb	0b01101100	;  oo oo  
	defb	0b01100110	;  oo  oo 
	defb	0b00000000	;         

; Character: L (4C)
	defb	0b01100000	;  oo     
	defb	0b01100000	;  oo     
	defb	0b01100000	;  oo     
	defb	0b01100000	;  oo     
	defb	0b01100000	;  oo     
	defb	0b01100000	;  oo     
	defb	0b01111100	;  ooooo  
	defb	0b00000000	;         

; Character: M (4D)
	defb	0b11111100	; oooooo  
	defb	0b11010110	; oo o oo 
	defb	0b11010110	; oo o oo 
	defb	0b11010110	; oo o oo 
	defb	0b11010110	; oo o oo 
	defb	0b11000110	; oo   oo 
	defb	0b11000110	; oo   oo 
	defb	0b00000000	;         

; Character: N (4E)
	defb	0b01100010	;  oo   o 
	defb	0b01110010	;  ooo  o 
	defb	0b01111010	;  oooo o 
	defb	0b01011110	;  o oooo 
	defb	0b01001110	;  o  ooo 
	defb	0b01000110	;  o   oo 
	defb	0b01000010	;  o    o 
	defb	0b00000000	;         

; Character: O (4F)
	defb	0b00111100	;   oooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111100	;   oooo  
	defb	0b00000000	;         

; Character: P (50)
	defb	0b01111100	;  ooooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01111100	;  ooooo  
	defb	0b01100000	;  oo     
	defb	0b01100000	;  oo     
	defb	0b01100000	;  oo     
	defb	0b00000000	;         

; Character: Q (51)
	defb	0b00111100	;   oooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111100	;   oooo  
	defb	0b00000110	;      oo 

; Character: R (52)
	defb	0b01111100	;  ooooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01111100	;  ooooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00000000	;         

; Character: S (53)
	defb	0b00111100	;   oooo  
	defb	0b01100010	;  oo   o 
	defb	0b01110000	;  ooo    
	defb	0b00111100	;   oooo  
	defb	0b00001110	;     ooo 
	defb	0b01000110	;  o   oo 
	defb	0b00111100	;   oooo  
	defb	0b00000000	;         

; Character: T (54)
	defb	0b01111110	;  oooooo 
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00000000	;         

; Character: U (55)
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111100	;   oooo  
	defb	0b00000000	;         

; Character: V (56)
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100100	;  oo  o  
	defb	0b01111000	;  oooo   
	defb	0b00000000	;         

; Character: W (57)
	defb	0b11000110	; oo   oo 
	defb	0b11000110	; oo   oo 
	defb	0b11000110	; oo   oo 
	defb	0b11010110	; oo o oo 
	defb	0b11010110	; oo o oo 
	defb	0b11010110	; oo o oo 
	defb	0b11111100	; oooooo  
	defb	0b00000000	;         

; Character: X (58)
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111100	;   oooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00000000	;         

; Character: Y (59)
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111100	;   oooo  
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00000000	;         

; Character: Z (5A)
	defb	0b01111110	;  oooooo 
	defb	0b00001110	;     ooo 
	defb	0b00011100	;    ooo  
	defb	0b00111000	;   ooo   
	defb	0b01110000	;  ooo    
	defb	0b01100000	;  oo     
	defb	0b01111110	;  oooooo 
	defb	0b00000000	;         

; Character: [ (5B)
	defb	0b00011110	;    oooo 
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011110	;    oooo 
	defb	0b00000000	;         

; Character: \ (5C)
	defb	0b01000000	;  o      
	defb	0b01100000	;  oo     
	defb	0b00110000	;   oo    
	defb	0b00011000	;    oo   
	defb	0b00001100	;     oo  
	defb	0b00000110	;      oo 
	defb	0b00000010	;       o 
	defb	0b00000000	;         

; Character: ] (5D)
	defb	0b01111000	;  oooo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b01111000	;  oooo   
	defb	0b00000000	;         

; Character: ^ (5E)
	defb	0b00010000	;    o    
	defb	0b00111000	;   ooo   
	defb	0b01101100	;  oo oo  
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: _ (5F)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b01111110	;  oooooo 
	defb	0b00000000	;         

; Character: ` (60)
	defb	0b00000000	;         
	defb	0b11000000	; oo      
	defb	0b11000000	; oo      
	defb	0b01100000	;  oo     
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: a (61)
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b01000110	;  o   oo 
	defb	0b00111110	;   ooooo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111110	;   ooooo 
	defb	0b00000000	;         

; Character: b (62)
	defb	0b01100000	;  oo     
	defb	0b01111100	;  ooooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01111100	;  ooooo  
	defb	0b00000000	;         

; Character: c (63)
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b01100010	;  oo   o 
	defb	0b01100000	;  oo     
	defb	0b01100000	;  oo     
	defb	0b01100010	;  oo   o 
	defb	0b00111100	;   oooo  
	defb	0b00000000	;         

; Character: d (64)
	defb	0b00000110	;      oo 
	defb	0b00111110	;   ooooo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111110	;   ooooo 
	defb	0b00000000	;         

; Character: e (65)
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01111110	;  oooooo 
	defb	0b01100000	;  oo     
	defb	0b01100010	;  oo   o 
	defb	0b00111100	;   oooo  
	defb	0b00000000	;         

; Character: f (66)
	defb	0b00011110	;    oooo 
	defb	0b00110000	;   oo    
	defb	0b01111100	;  ooooo  
	defb	0b00110000	;   oo    
	defb	0b00110000	;   oo    
	defb	0b00110000	;   oo    
	defb	0b00110000	;   oo    
	defb	0b00000000	;         

; Character: g (67)
	defb	0b00000000	;         
	defb	0b00111110	;   ooooo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111110	;   ooooo 
	defb	0b01000110	;  o   oo 
	defb	0b00111100	;   oooo  

; Character: h (68)
	defb	0b01100000	;  oo     
	defb	0b01111100	;  ooooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00000000	;         

; Character: i (69)
	defb	0b00011000	;    oo   
	defb	0b00000000	;         
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00000000	;         

; Character: j (6A)
	defb	0b00000000	;         
	defb	0b00001000	;     o   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b01011000	;  o oo   
	defb	0b00110000	;   oo    

; Character: k (6B)
	defb	0b01100000	;  oo     
	defb	0b01100100	;  oo  o  
	defb	0b01101000	;  oo o   
	defb	0b01110000	;  ooo    
	defb	0b01111000	;  oooo   
	defb	0b01101100	;  oo oo  
	defb	0b01100110	;  oo  oo 
	defb	0b00000000	;         

; Character: l (6C)
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00001100	;     oo  
	defb	0b00000000	;         

; Character: m (6D)
	defb	0b00000000	;         
	defb	0b11111100	; oooooo  
	defb	0b11010110	; oo o oo 
	defb	0b11010110	; oo o oo 
	defb	0b11010110	; oo o oo 
	defb	0b11010110	; oo o oo 
	defb	0b11000110	; oo   oo 
	defb	0b00000000	;         

; Character: n (6E)
	defb	0b00000000	;         
	defb	0b01111100	;  ooooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00000000	;         

; Character: o (6F)
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111100	;   oooo  
	defb	0b00000000	;         

; Character: p (70)
	defb	0b00000000	;         
	defb	0b01111100	;  ooooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01111100	;  ooooo  
	defb	0b01100000	;  oo     
	defb	0b01100000	;  oo     

; Character: q (71)
	defb	0b00000000	;         
	defb	0b00111110	;   ooooo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111110	;   ooooo 
	defb	0b00000110	;      oo 

; Character: r (72)
	defb	0b00000000	;         
	defb	0b01101100	;  oo oo  
	defb	0b01110000	;  ooo    
	defb	0b01100000	;  oo     
	defb	0b01100000	;  oo     
	defb	0b01100000	;  oo     
	defb	0b01100000	;  oo     
	defb	0b00000000	;         

; Character: s (73)
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b01110010	;  ooo  o 
	defb	0b00111000	;   ooo   
	defb	0b00011100	;    ooo  
	defb	0b01001110	;  o  ooo 
	defb	0b00111100	;   oooo  
	defb	0b00000000	;         

; Character: t (74)
	defb	0b00011000	;    oo   
	defb	0b00111100	;   oooo  
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00001100	;     oo  
	defb	0b00000000	;         

; Character: u (75)
	defb	0b00000000	;         
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111110	;   ooooo 
	defb	0b00000000	;         

; Character: v (76)
	defb	0b00000000	;         
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100100	;  oo  o  
	defb	0b01111000	;  oooo   
	defb	0b00000000	;         

; Character: w (77)
	defb	0b00000000	;         
	defb	0b11000110	; oo   oo 
	defb	0b11000110	; oo   oo 
	defb	0b11010110	; oo o oo 
	defb	0b11010110	; oo o oo 
	defb	0b11010110	; oo o oo 
	defb	0b11111100	; oooooo  
	defb	0b00000000	;         

; Character: x (78)
	defb	0b00000000	;         
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111100	;   oooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00000000	;         

; Character: y (79)
	defb	0b00000000	;         
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00100110	;   o  oo 
	defb	0b00011110	;    oooo 
	defb	0b01000110	;  o   oo 
	defb	0b00111100	;   oooo  

; Character: z (7A)
	defb	0b00000000	;         
	defb	0b01111110	;  oooooo 
	defb	0b00001110	;     ooo 
	defb	0b00011100	;    ooo  
	defb	0b00111000	;   ooo   
	defb	0b01110000	;  ooo    
	defb	0b01111110	;  oooooo 
	defb	0b00000000	;         

; Character: { (7B)
	defb	0b00001110	;     ooo 
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00110000	;   oo    
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00001110	;     ooo 
	defb	0b00000000	;         

; Character: | (7C)
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   

; Character: } (7D)
	defb	0b01110000	;  ooo    
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00001100	;     oo  
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b01110000	;  ooo    
	defb	0b00000000	;         

; Character: ~ (7E)
	defb	0b00000000	;         
	defb	0b01100000	;  oo     
	defb	0b11110010	; oooo  o 
	defb	0b10011110	; o  oooo 
	defb	0b00001100	;     oo  
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (7F)
	defb	0b00010000	;    o    
	defb	0b00010000	;    o    
	defb	0b00101000	;   o o   
	defb	0b00101000	;   o o   
	defb	0b01000100	;  o   o  
	defb	0b01000100	;  o   o  
	defb	0b10000010	; o     o 
	defb	0b11111110	; ooooooo 

; Character: ? (80)
	defb	0b00111100	;   oooo  
	defb	0b01100010	;  oo   o 
	defb	0b01100000	;  oo     
	defb	0b01100000	;  oo     
	defb	0b01100000	;  oo     
	defb	0b01100010	;  oo   o 
	defb	0b00011100	;    ooo  
	defb	0b00110000	;   oo    

; Character: ? (81)
	defb	0b00100100	;   o  o  
	defb	0b00000000	;         
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111110	;   ooooo 
	defb	0b00000000	;         

; Character: ? (82)
	defb	0b00001100	;     oo  
	defb	0b00011000	;    oo   
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b01111110	;  oooooo 
	defb	0b01100000	;  oo     
	defb	0b00111100	;   oooo  
	defb	0b00000000	;         

; Character: ? (83)
	defb	0b00011000	;    oo   
	defb	0b01100110	;  oo  oo 
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b00000110	;      oo 
	defb	0b01111110	;  oooooo 
	defb	0b00111110	;   ooooo 
	defb	0b00000000	;         

; Character: ? (84)
	defb	0b00100100	;   o  o  
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b01000110	;  o   oo 
	defb	0b00111110	;   ooooo 
	defb	0b01000110	;  o   oo 
	defb	0b00111110	;   ooooo 
	defb	0b00000000	;         

; Character: ? (85)
	defb	0b00110000	;   oo    
	defb	0b00011000	;    oo   
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b00000110	;      oo 
	defb	0b01111110	;  oooooo 
	defb	0b00111110	;   ooooo 
	defb	0b00000000	;         

; Character: ? (86)
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b00000110	;      oo 
	defb	0b01111110	;  oooooo 
	defb	0b00111110	;   ooooo 
	defb	0b00000000	;         

; Character: ? (87)
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b01100010	;  oo   o 
	defb	0b01100000	;  oo     
	defb	0b01100010	;  oo   o 
	defb	0b00111100	;   oooo  
	defb	0b00001000	;     o   
	defb	0b00011000	;    oo   

; Character: ? (88)
	defb	0b00011000	;    oo   
	defb	0b00110100	;   oo o  
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b01111110	;  oooooo 
	defb	0b01100000	;  oo     
	defb	0b00111110	;   ooooo 
	defb	0b00000000	;         

; Character: ? (89)
	defb	0b00100100	;   o  o  
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01111110	;  oooooo 
	defb	0b01100000	;  oo     
	defb	0b00111110	;   ooooo 
	defb	0b00000000	;         

; Character: ? (8A)
	defb	0b00110000	;   oo    
	defb	0b00011000	;    oo   
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b01111110	;  oooooo 
	defb	0b01100000	;  oo     
	defb	0b00111100	;   oooo  
	defb	0b00000000	;         

; Character: ? (8B)
	defb	0b00100100	;   o  o  
	defb	0b00000000	;         
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00000000	;         

; Character: ? (8C)
	defb	0b00011000	;    oo   
	defb	0b00100100	;   o  o  
	defb	0b00000000	;         
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00000000	;         

; Character: ? (8D)
	defb	0b00010000	;    o    
	defb	0b00001000	;     o   
	defb	0b00000000	;         
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00000000	;         

; Character: ? (8E)
	defb	0b00100100	;   o  o  
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01111110	;  oooooo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00000000	;         

; Character: ? (8F)
	defb	0b00011000	;    oo   
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01111110	;  oooooo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00000000	;         

; Character: ? (90)
	defb	0b00001100	;     oo  
	defb	0b00011000	;    oo   
	defb	0b01111110	;  oooooo 
	defb	0b01100000	;  oo     
	defb	0b01111100	;  ooooo  
	defb	0b01100000	;  oo     
	defb	0b01111110	;  oooooo 
	defb	0b00000000	;         

; Character: ? (91)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b01111110	;  oooooo 
	defb	0b00011011	;    oo oo
	defb	0b01111111	;  ooooooo
	defb	0b11011000	; oo oo   
	defb	0b01111110	;  oooooo 
	defb	0b00000000	;         

; Character: ? (92)
	defb	0b00111111	;   oooooo
	defb	0b01111000	;  oooo   
	defb	0b11011000	; oo oo   
	defb	0b11011110	; oo oooo 
	defb	0b11111000	; ooooo   
	defb	0b11011000	; oo oo   
	defb	0b11011111	; oo ooooo
	defb	0b00000000	;         

; Character: ? (93)
	defb	0b00011000	;    oo   
	defb	0b00110100	;   oo o  
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111100	;   oooo  
	defb	0b00000000	;         

; Character: ? (94)
	defb	0b00100100	;   o  o  
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111100	;   oooo  
	defb	0b00000000	;         

; Character: ? (95)
	defb	0b00110000	;   oo    
	defb	0b00011000	;    oo   
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111100	;   oooo  
	defb	0b00000000	;         

; Character: ? (96)
	defb	0b00011000	;    oo   
	defb	0b00100100	;   o  o  
	defb	0b00000000	;         
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111100	;   oooo  
	defb	0b00000000	;         

; Character: ? (97)
	defb	0b00110000	;   oo    
	defb	0b00011000	;    oo   
	defb	0b00000000	;         
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111100	;   oooo  
	defb	0b00000000	;         

; Character: ? (98)
	defb	0b01100110	;  oo  oo 
	defb	0b00000000	;         
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111110	;   ooooo 
	defb	0b01000110	;  o   oo 
	defb	0b00111100	;   oooo  

; Character: ? (99)
	defb	0b01100110	;  oo  oo 
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111100	;   oooo  
	defb	0b00000000	;         

; Character: ? (9A)
	defb	0b01100110	;  oo  oo 
	defb	0b00000000	;         
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111100	;   oooo  
	defb	0b00000000	;         

; Character: ? (9B)
	defb	0b00011000	;    oo   
	defb	0b00111100	;   oooo  
	defb	0b01100010	;  oo   o 
	defb	0b01100000	;  oo     
	defb	0b01100000	;  oo     
	defb	0b01100010	;  oo   o 
	defb	0b00111100	;   oooo  
	defb	0b00011000	;    oo   

; Character: ? (9C)
	defb	0b00011100	;    ooo  
	defb	0b00111010	;   ooo o 
	defb	0b00110000	;   oo    
	defb	0b01111100	;  ooooo  
	defb	0b00110000	;   oo    
	defb	0b00110000	;   oo    
	defb	0b01111110	;  oooooo 
	defb	0b00000000	;         

; Character: ? (9D)
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111100	;   oooo  
	defb	0b00011000	;    oo   
	defb	0b00111100	;   oooo  
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00000000	;         

; Character: ? (9E)
	defb	0b00111100	;   oooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01101100	;  oo oo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b11101100	; ooo oo  
	defb	0b00000000	;         

; Character: ? (9F)
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   

; Character: ? (A0)
	defb	0b00001100	;     oo  
	defb	0b00011000	;    oo   
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b00000110	;      oo 
	defb	0b01111110	;  oooooo 
	defb	0b00111110	;   ooooo 
	defb	0b00000000	;         

; Character: ? (A1)
	defb	0b00001100	;     oo  
	defb	0b00011000	;    oo   
	defb	0b00000000	;         
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00000000	;         

; Character: ? (A2)
	defb	0b00001100	;     oo  
	defb	0b00011000	;    oo   
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111100	;   oooo  
	defb	0b00000000	;         

; Character: ? (A3)
	defb	0b00001100	;     oo  
	defb	0b00011000	;    oo   
	defb	0b00000000	;         
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111110	;   ooooo 
	defb	0b00000000	;         

; Character: ? (A4)
	defb	0b00110100	;   oo o  
	defb	0b01011000	;  o oo   
	defb	0b00000000	;         
	defb	0b01111100	;  ooooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00000000	;         

; Character: ? (A5)
	defb	0b00011010	;    oo o 
	defb	0b00101100	;   o oo  
	defb	0b01100010	;  oo   o 
	defb	0b01110010	;  ooo  o 
	defb	0b01011010	;  o oo o 
	defb	0b01001110	;  o  ooo 
	defb	0b01000110	;  o   oo 
	defb	0b00000000	;         

; Character: ? (A6)
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b01000110	;  o   oo 
	defb	0b00111110	;   ooooo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111110	;   ooooo 
	defb	0b00000000	;         
	defb	0b01111110	;  oooooo 

; Character: ? (A7)
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111100	;   oooo  
	defb	0b00000000	;         
	defb	0b01111110	;  oooooo 

; Character: ? (A8)
	defb	0b00000000	;         
	defb	0b00011000	;    oo   
	defb	0b00000000	;         
	defb	0b00011000	;    oo   
	defb	0b00110000	;   oo    
	defb	0b01100000	;  oo     
	defb	0b01100110	;  oo  oo 
	defb	0b00111100	;   oooo  

; Character: ? (A9)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00111110	;   ooooo 
	defb	0b00110000	;   oo    
	defb	0b00110000	;   oo    
	defb	0b00110000	;   oo    
	defb	0b00000000	;         

; Character: ? (AA)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b01111100	;  ooooo  
	defb	0b00001100	;     oo  
	defb	0b00001100	;     oo  
	defb	0b00001100	;     oo  
	defb	0b00000000	;         

; Character: ? (AB)
	defb	0b01100010	;  oo   o 
	defb	0b11100100	; ooo  o  
	defb	0b01101000	;  oo o   
	defb	0b01110110	;  ooo oo 
	defb	0b00101011	;   o o oo
	defb	0b01000011	;  o    oo
	defb	0b10000110	; o    oo 
	defb	0b00001111	;     oooo

; Character: ? (AC)
	defb	0b01100010	;  oo   o 
	defb	0b11100100	; ooo  o  
	defb	0b01101000	;  oo o   
	defb	0b01110110	;  ooo oo 
	defb	0b00101110	;   o ooo 
	defb	0b01010110	;  o o oo 
	defb	0b10011111	; o  ooooo
	defb	0b00000110	;      oo 

; Character: ? (AD)
	defb	0b00000000	;         
	defb	0b00011000	;    oo   
	defb	0b00000000	;         
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   

; Character: ? (AE)
	defb	0b00011011	;    oo oo
	defb	0b00110110	;   oo oo 
	defb	0b01101100	;  oo oo  
	defb	0b11011000	; oo oo   
	defb	0b01101100	;  oo oo  
	defb	0b00110110	;   oo oo 
	defb	0b00011011	;    oo oo
	defb	0b00000000	;         

; Character: ? (AF)
	defb	0b11011000	; oo oo   
	defb	0b01101100	;  oo oo  
	defb	0b00110110	;   oo oo 
	defb	0b00011011	;    oo oo
	defb	0b00110110	;   oo oo 
	defb	0b01101100	;  oo oo  
	defb	0b11011000	; oo oo   
	defb	0b00000000	;         

; Character: ? (B0)
	defb	0b00110100	;   oo o  
	defb	0b01011000	;  o oo   
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b00000110	;      oo 
	defb	0b01111110	;  oooooo 
	defb	0b00111110	;   ooooo 
	defb	0b00000000	;         

; Character: ? (B1)
	defb	0b00110100	;   oo o  
	defb	0b01011000	;  o oo   
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111100	;   oooo  
	defb	0b00000000	;         

; Character: ? (B2)
	defb	0b00000010	;       o 
	defb	0b00111100	;   oooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01101110	;  oo ooo 
	defb	0b01110110	;  ooo oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111100	;   oooo  
	defb	0b01000000	;  o      

; Character: ? (B3)
	defb	0b00000000	;         
	defb	0b00000010	;       o 
	defb	0b00111100	;   oooo  
	defb	0b01101110	;  oo ooo 
	defb	0b01110110	;  ooo oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111100	;   oooo  
	defb	0b01000000	;  o      

; Character: ? (B4)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b01111110	;  oooooo 
	defb	0b11011011	; oo oo oo
	defb	0b11011110	; oo oooo 
	defb	0b11011000	; oo oo   
	defb	0b01111111	;  ooooooo
	defb	0b00000000	;         

; Character: ? (B5)
	defb	0b00000000	;         
	defb	0b01111110	;  oooooo 
	defb	0b11011000	; oo oo   
	defb	0b11011000	; oo oo   
	defb	0b11111100	; oooooo  
	defb	0b11011000	; oo oo   
	defb	0b11011000	; oo oo   
	defb	0b11011110	; oo oooo 

; Character: ? (B6)
	defb	0b00100000	;   o     
	defb	0b00010000	;    o    
	defb	0b00111100	;   oooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01111110	;  oooooo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 

; Character: ? (B7)
	defb	0b00110100	;   oo o  
	defb	0b01011000	;  o oo   
	defb	0b00111100	;   oooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01111110	;  oooooo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 

; Character: ? (B8)
	defb	0b00110100	;   oo o  
	defb	0b01011000	;  o oo   
	defb	0b00111100	;   oooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111100	;   oooo  

; Character: ? (B9)
	defb	0b01100110	;  oo  oo 
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (BA)
	defb	0b00001100	;     oo  
	defb	0b00011000	;    oo   
	defb	0b00110000	;   oo    
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (BB)
	defb	0b00000000	;         
	defb	0b00010000	;    o    
	defb	0b00111000	;   ooo   
	defb	0b00010000	;    o    
	defb	0b00010000	;    o    
	defb	0b00010000	;    o    
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (BC)
	defb	0b01111010	;  oooo o 
	defb	0b11001010	; oo  o o 
	defb	0b11001010	; oo  o o 
	defb	0b11001010	; oo  o o 
	defb	0b01111010	;  oooo o 
	defb	0b00001010	;     o o 
	defb	0b00001010	;     o o 
	defb	0b00001010	;     o o 

; Character: ? (BD)
	defb	0b00111100	;   oooo  
	defb	0b01000010	;  o    o 
	defb	0b10011001	; o  oo  o
	defb	0b10110101	; o oo o o
	defb	0b10110001	; o oo   o
	defb	0b10011101	; o  ooo o
	defb	0b01000010	;  o    o 
	defb	0b00111100	;   oooo  

; Character: ? (BE)
	defb	0b00111100	;   oooo  
	defb	0b01000010	;  o    o 
	defb	0b10111001	; o ooo  o
	defb	0b10110101	; o oo o o
	defb	0b10111001	; o ooo  o
	defb	0b10110101	; o oo o o
	defb	0b01000010	;  o    o 
	defb	0b00111100	;   oooo  

; Character: ? (BF)
	defb	0b11110001	; oooo   o
	defb	0b01011011	;  o oo oo
	defb	0b01010101	;  o o o o
	defb	0b01010001	;  o o   o
	defb	0b01010001	;  o o   o
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (C0)
	defb	0b01100110	;  oo  oo 
	defb	0b00000000	;         
	defb	0b11100110	; ooo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b11110110	; oooo oo 
	defb	0b00000110	;      oo 
	defb	0b00011100	;    ooo  

; Character: ? (C1)
	defb	0b11110110	; oooo oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b11110110	; oooo oo 
	defb	0b00000110	;      oo 
	defb	0b00011100	;    ooo  

; Character: ? (C2)
	defb	0b00000000	;         
	defb	0b01100110	;  oo  oo 
	defb	0b01110110	;  ooo oo 
	defb	0b00111100	;   oooo  
	defb	0b01101110	;  oo ooo 
	defb	0b01100110	;  oo  oo 
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (C3)
	defb	0b00000000	;         
	defb	0b01111100	;  ooooo  
	defb	0b00001100	;     oo  
	defb	0b00001100	;     oo  
	defb	0b00001100	;     oo  
	defb	0b01111110	;  oooooo 
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (C4)
	defb	0b00000000	;         
	defb	0b00011110	;    oooo 
	defb	0b00000110	;      oo 
	defb	0b00001110	;     ooo 
	defb	0b00011110	;    oooo 
	defb	0b00110110	;   oo oo 
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (C5)
	defb	0b00000000	;         
	defb	0b01111110	;  oooooo 
	defb	0b00001100	;     oo  
	defb	0b00001100	;     oo  
	defb	0b00001100	;     oo  
	defb	0b00001100	;     oo  
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (C6)
	defb	0b00000000	;         
	defb	0b01111100	;  ooooo  
	defb	0b00000110	;      oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (C7)
	defb	0b00000000	;         
	defb	0b00011100	;    ooo  
	defb	0b00001100	;     oo  
	defb	0b00001100	;     oo  
	defb	0b00001100	;     oo  
	defb	0b00001100	;     oo  
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (C8)
	defb	0b00000000	;         
	defb	0b00011110	;    oooo 
	defb	0b00001100	;     oo  
	defb	0b00000110	;      oo 
	defb	0b00000110	;      oo 
	defb	0b00000110	;      oo 
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (C9)
	defb	0b00000000	;         
	defb	0b01111110	;  oooooo 
	defb	0b00110110	;   oo oo 
	defb	0b00110110	;   oo oo 
	defb	0b00110110	;   oo oo 
	defb	0b00110110	;   oo oo 
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (CA)
	defb	0b01100000	;  oo     
	defb	0b01101110	;  oo ooo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01111110	;  oooooo 
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (CB)
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b00001100	;     oo  
	defb	0b00001100	;     oo  
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (CC)
	defb	0b00000000	;         
	defb	0b00111110	;   ooooo 
	defb	0b00000110	;      oo 
	defb	0b00000110	;      oo 
	defb	0b00000110	;      oo 
	defb	0b00111110	;   ooooo 
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (CD)
	defb	0b01100000	;  oo     
	defb	0b01111110	;  oooooo 
	defb	0b00000110	;      oo 
	defb	0b00000110	;      oo 
	defb	0b00000110	;      oo 
	defb	0b00001110	;     ooo 
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (CE)
	defb	0b00000000	;         
	defb	0b01101100	;  oo oo  
	defb	0b00111110	;   ooooo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01101110	;  oo ooo 
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (CF)
	defb	0b00000000	;         
	defb	0b00011100	;    ooo  
	defb	0b00001100	;     oo  
	defb	0b00001100	;     oo  
	defb	0b00001100	;     oo  
	defb	0b00111100	;   oooo  
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (D0)
	defb	0b00000000	;         
	defb	0b00111110	;   ooooo 
	defb	0b00110110	;   oo oo 
	defb	0b00110110	;   oo oo 
	defb	0b00110110	;   oo oo 
	defb	0b00011100	;    ooo  
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (D1)
	defb	0b00000000	;         
	defb	0b00110110	;   oo oo 
	defb	0b00110110	;   oo oo 
	defb	0b00110110	;   oo oo 
	defb	0b00110110	;   oo oo 
	defb	0b01111110	;  oooooo 
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (D2)
	defb	0b00000000	;         
	defb	0b01111110	;  oooooo 
	defb	0b01100110	;  oo  oo 
	defb	0b01110110	;  ooo oo 
	defb	0b00000110	;      oo 
	defb	0b01111110	;  oooooo 
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (D3)
	defb	0b00000000	;         
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111100	;   oooo  
	defb	0b00001110	;     ooo 
	defb	0b01111110	;  oooooo 
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (D4)
	defb	0b00000000	;         
	defb	0b00111110	;   ooooo 
	defb	0b00000110	;      oo 
	defb	0b00110110	;   oo oo 
	defb	0b00110110	;   oo oo 
	defb	0b00110100	;   oo o  
	defb	0b00110000	;   oo    
	defb	0b00000000	;         

; Character: ? (D5)
	defb	0b00000000	;         
	defb	0b01111000	;  oooo   
	defb	0b00001100	;     oo  
	defb	0b00001100	;     oo  
	defb	0b00001100	;     oo  
	defb	0b00001100	;     oo  
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (D6)
	defb	0b00000000	;         
	defb	0b11010110	; oo o oo 
	defb	0b11010110	; oo o oo 
	defb	0b11010110	; oo o oo 
	defb	0b11010110	; oo o oo 
	defb	0b11111110	; ooooooo 
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (D7)
	defb	0b00000000	;         
	defb	0b01111100	;  ooooo  
	defb	0b01101100	;  oo oo  
	defb	0b01101100	;  oo oo  
	defb	0b01101100	;  oo oo  
	defb	0b11101100	; ooo oo  
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (D8)
	defb	0b00000000	;         
	defb	0b00011100	;    ooo  
	defb	0b00001100	;     oo  
	defb	0b00001100	;     oo  
	defb	0b00001100	;     oo  
	defb	0b00001100	;     oo  
	defb	0b00001100	;     oo  
	defb	0b00000000	;         

; Character: ? (D9)
	defb	0b00000000	;         
	defb	0b00111110	;   ooooo 
	defb	0b00000110	;      oo 
	defb	0b00000110	;      oo 
	defb	0b00000110	;      oo 
	defb	0b00000110	;      oo 
	defb	0b00000110	;      oo 
	defb	0b00000000	;         

; Character: ? (DA)
	defb	0b00000000	;         
	defb	0b11111110	; ooooooo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01111110	;  oooooo 
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (DB)
	defb	0b00000000	;         
	defb	0b01111110	;  oooooo 
	defb	0b01100110	;  oo  oo 
	defb	0b01110110	;  ooo oo 
	defb	0b00000110	;      oo 
	defb	0b00000110	;      oo 
	defb	0b00000110	;      oo 
	defb	0b00000000	;         

; Character: ? (DC)
	defb	0b00000000	;         
	defb	0b00110110	;   oo oo 
	defb	0b00110110	;   oo oo 
	defb	0b00011100	;    ooo  
	defb	0b00001100	;     oo  
	defb	0b00001100	;     oo  
	defb	0b00001100	;     oo  
	defb	0b00000000	;         

; Character: ? (DD)
	defb	0b00011100	;    ooo  
	defb	0b00110010	;   oo  o 
	defb	0b00111100	;   oooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111100	;   oooo  
	defb	0b01001100	;  o  oo  
	defb	0b00111000	;   ooo   

; Character: ? (DE)
	defb	0b00000000	;         
	defb	0b00010000	;    o    
	defb	0b00111000	;   ooo   
	defb	0b01101100	;  oo oo  
	defb	0b11000110	; oo   oo 
	defb	0b10000010	; o     o 
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (DF)
	defb	0b01100110	;  oo  oo 
	defb	0b11110111	; oooo ooo
	defb	0b10011001	; o  oo  o
	defb	0b10011001	; o  oo  o
	defb	0b11101111	; ooo oooo
	defb	0b01100110	;  oo  oo 
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (E0)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b01110110	;  ooo oo 
	defb	0b11011100	; oo ooo  
	defb	0b11001000	; oo  o   
	defb	0b11011100	; oo ooo  
	defb	0b01110110	;  ooo oo 
	defb	0b00000000	;         

; Character: ? (E1)
	defb	0b00011100	;    ooo  
	defb	0b00110110	;   oo oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01111100	;  ooooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01111100	;  ooooo  
	defb	0b01100000	;  oo     

; Character: ? (E2)
	defb	0b00000000	;         
	defb	0b11111110	; ooooooo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100010	;  oo   o 
	defb	0b01100000	;  oo     
	defb	0b01100000	;  oo     
	defb	0b01100000	;  oo     
	defb	0b11111000	; ooooo   

; Character: ? (E3)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b11111110	; ooooooo 
	defb	0b01101100	;  oo oo  
	defb	0b01101100	;  oo oo  
	defb	0b01101100	;  oo oo  
	defb	0b01101100	;  oo oo  
	defb	0b01001000	;  o  o   

; Character: ? (E4)
	defb	0b11111110	; ooooooo 
	defb	0b01100110	;  oo  oo 
	defb	0b00110000	;   oo    
	defb	0b00011000	;    oo   
	defb	0b00110000	;   oo    
	defb	0b01100110	;  oo  oo 
	defb	0b11111110	; ooooooo 
	defb	0b00000000	;         

; Character: ? (E5)
	defb	0b00000000	;         
	defb	0b00011110	;    oooo 
	defb	0b00111000	;   ooo   
	defb	0b01101100	;  oo oo  
	defb	0b01101100	;  oo oo  
	defb	0b01101100	;  oo oo  
	defb	0b00111000	;   ooo   
	defb	0b00000000	;         

; Character: ? (E6)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b01101100	;  oo oo  
	defb	0b01101100	;  oo oo  
	defb	0b01101100	;  oo oo  
	defb	0b01101100	;  oo oo  
	defb	0b01111111	;  ooooooo
	defb	0b11000000	; oo      

; Character: ? (E7)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b01111110	;  oooooo 
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00010000	;    o    

; Character: ? (E8)
	defb	0b00111100	;   oooo  
	defb	0b00011000	;    oo   
	defb	0b00111100	;   oooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111100	;   oooo  
	defb	0b00011000	;    oo   
	defb	0b00111100	;   oooo  

; Character: ? (E9)
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01111110	;  oooooo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00111100	;   oooo  
	defb	0b00000000	;         

; Character: ? (EA)
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00100100	;   o  o  
	defb	0b01100110	;  oo  oo 
	defb	0b00000000	;         

; Character: ? (EB)
	defb	0b00011100	;    ooo  
	defb	0b00110110	;   oo oo 
	defb	0b01111000	;  oooo   
	defb	0b11011100	; oo ooo  
	defb	0b11001100	; oo  oo  
	defb	0b11101100	; ooo oo  
	defb	0b01111000	;  oooo   
	defb	0b00000000	;         

; Character: ? (EC)
	defb	0b00001100	;     oo  
	defb	0b00011000	;    oo   
	defb	0b00111000	;   ooo   
	defb	0b01010100	;  o o o  
	defb	0b01010100	;  o o o  
	defb	0b00111000	;   ooo   
	defb	0b00110000	;   oo    
	defb	0b01100000	;  oo     

; Character: ? (ED)
	defb	0b00000000	;         
	defb	0b00010000	;    o    
	defb	0b01111100	;  ooooo  
	defb	0b11010110	; oo o oo 
	defb	0b11010110	; oo o oo 
	defb	0b11010110	; oo o oo 
	defb	0b01111100	;  ooooo  
	defb	0b00010000	;    o    

; Character: ? (EE)
	defb	0b00111110	;   ooooo 
	defb	0b01110000	;  ooo    
	defb	0b01100000	;  oo     
	defb	0b01111110	;  oooooo 
	defb	0b01100000	;  oo     
	defb	0b01110000	;  ooo    
	defb	0b00111110	;   ooooo 
	defb	0b00000000	;         

; Character: ? (EF)
	defb	0b00111100	;   oooo  
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b01100110	;  oo  oo 
	defb	0b00000000	;         

; Character: ? (F0)
	defb	0b00000000	;         
	defb	0b01111110	;  oooooo 
	defb	0b00000000	;         
	defb	0b01111110	;  oooooo 
	defb	0b00000000	;         
	defb	0b01111110	;  oooooo 
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (F1)
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b01111110	;  oooooo 
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00000000	;         
	defb	0b01111110	;  oooooo 
	defb	0b00000000	;         

; Character: ? (F2)
	defb	0b00110000	;   oo    
	defb	0b00011000	;    oo   
	defb	0b00001100	;     oo  
	defb	0b00011000	;    oo   
	defb	0b00110000	;   oo    
	defb	0b00000000	;         
	defb	0b01111110	;  oooooo 
	defb	0b00000000	;         

; Character: ? (F3)
	defb	0b00001100	;     oo  
	defb	0b00011000	;    oo   
	defb	0b00110000	;   oo    
	defb	0b00011000	;    oo   
	defb	0b00001100	;     oo  
	defb	0b00000000	;         
	defb	0b01111110	;  oooooo 
	defb	0b00000000	;         

; Character: ? (F4)
	defb	0b00000000	;         
	defb	0b00001110	;     ooo 
	defb	0b00011011	;    oo oo
	defb	0b00011011	;    oo oo
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   

; Character: ? (F5)
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b11011000	; oo oo   
	defb	0b11011000	; oo oo   
	defb	0b01110000	;  ooo    
	defb	0b00000000	;         

; Character: ? (F6)
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00000000	;         
	defb	0b01111110	;  oooooo 
	defb	0b00000000	;         
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00000000	;         

; Character: ? (F7)
	defb	0b00000000	;         
	defb	0b00110010	;   oo  o 
	defb	0b01001100	;  o  oo  
	defb	0b00000000	;         
	defb	0b00110010	;   oo  o 
	defb	0b01001100	;  o  oo  
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (F8)
	defb	0b00111000	;   ooo   
	defb	0b01101100	;  oo oo  
	defb	0b00111000	;   ooo   
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (F9)
	defb	0b00111000	;   ooo   
	defb	0b01111100	;  ooooo  
	defb	0b00111000	;   ooo   
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (FA)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00011000	;    oo   
	defb	0b00011000	;    oo   
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (FB)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00001111	;     oooo
	defb	0b00011000	;    oo   
	defb	0b11011000	; oo oo   
	defb	0b01110000	;  ooo    
	defb	0b00110000	;   oo    
	defb	0b00000000	;         

; Character: ? (FC)
	defb	0b00111000	;   ooo   
	defb	0b01101100	;  oo oo  
	defb	0b01101100	;  oo oo  
	defb	0b01101100	;  oo oo  
	defb	0b01101100	;  oo oo  
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (FD)
	defb	0b00111000	;   ooo   
	defb	0b01101100	;  oo oo  
	defb	0b00011000	;    oo   
	defb	0b00110000	;   oo    
	defb	0b01111100	;  ooooo  
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (FE)
	defb	0b01111000	;  oooo   
	defb	0b00001100	;     oo  
	defb	0b00111000	;   ooo   
	defb	0b00001100	;     oo  
	defb	0b01111000	;  oooo   
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ? (FF)
	defb	0b00000000	;         
	defb	0b11111110	; ooooooo 
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         

