; font: italic
	;; BANKED:	checked,imperfect

	SECTION rodata_driver

	PUBLIC	_font_italic

_font_italic:
	defb	1+4	; 128 char encoding, compressed
	defb	93	; Number of tiles

; Encoding table

	defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
	defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
	defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
	defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
	defb 0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07
	defb 0x08,0x09,0x0A,0x0B,0x0C,0x0D,0x0E,0x0F
	defb 0x10,0x11,0x12,0x13,0x14,0x15,0x16,0x17
	defb 0x18,0x19,0x1A,0x1B,0x1C,0x1D,0x1E,0x1F
	defb 0x20,0x21,0x22,0x23,0x24,0x25,0x26,0x27
	defb 0x28,0x29,0x2A,0x2B,0x2C,0x2D,0x2E,0x2F
	defb 0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37
	defb 0x38,0x39,0x3A,0x3B,0x3C,0x3D,0x3E,0x00
	defb 0x00,0x3F,0x40,0x41,0x42,0x43,0x44,0x45
	defb 0x46,0x47,0x48,0x49,0x4A,0x4B,0x4C,0x4D
	defb 0x4E,0x4F,0x50,0x51,0x52,0x53,0x54,0x55
	defb 0x56,0x57,0x58,0x59,0x5A,0x5B,0x5C,0x00
; Tile data
; Default character (space)
	defb	0b00000000
	defb	0b00000000
	defb	0b00000000
	defb	0b00000000
	defb	0b00000000
	defb	0b00000000
	defb	0b00000000
	defb	0b00000000

; Character: ! (21)
	defb	0b00000000	;         
	defb	0b00001000	;     o   
	defb	0b00001000	;     o   
	defb	0b00001000	;     o   
	defb	0b00010000	;    o    
	defb	0b00010000	;    o    
	defb	0b00000000	;         
	defb	0b00100000	;   o     

; Character: " (22)
	defb	0b00000000	;         
	defb	0b00100100	;   o  o  
	defb	0b00100100	;   o  o  
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
	defb	0b00000000	;         
	defb	0b00001000	;     o   
	defb	0b00111110	;   ooooo 
	defb	0b00101000	;   o o   
	defb	0b00111110	;   ooooo 
	defb	0b00001010	;     o o 
	defb	0b00111110	;   ooooo 
	defb	0b00001000	;     o   

; Character: % (25)
	defb	0b00000000	;         
	defb	0b01100010	;  oo   o 
	defb	0b01100100	;  oo  o  
	defb	0b00001000	;     o   
	defb	0b00010000	;    o    
	defb	0b00100110	;   o  oo 
	defb	0b01000110	;  o   oo 
	defb	0b00000000	;         

; Character: & (26)
	defb	0b00000000	;         
	defb	0b00010000	;    o    
	defb	0b00101000	;   o o   
	defb	0b00010000	;    o    
	defb	0b00101010	;   o o o 
	defb	0b01000100	;  o   o  
	defb	0b00111010	;   ooo o 
	defb	0b00000000	;         

; Character: ' (27)
	defb	0b00000000	;         
	defb	0b00001000	;     o   
	defb	0b00010000	;    o    
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: ( (28)
	defb	0b00000000	;         
	defb	0b00000100	;      o  
	defb	0b00001000	;     o   
	defb	0b00001000	;     o   
	defb	0b00001000	;     o   
	defb	0b00001000	;     o   
	defb	0b00000100	;      o  
	defb	0b00000000	;         

; Character: ) (29)
	defb	0b00000000	;         
	defb	0b00100000	;   o     
	defb	0b00010000	;    o    
	defb	0b00010000	;    o    
	defb	0b00010000	;    o    
	defb	0b00010000	;    o    
	defb	0b00100000	;   o     
	defb	0b00000000	;         

; Character: * (2A)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00100100	;   o  o  
	defb	0b00011000	;    oo   
	defb	0b01111110	;  oooooo 
	defb	0b00011000	;    oo   
	defb	0b00100100	;   o  o  
	defb	0b00000000	;         

; Character: + (2B)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00001000	;     o   
	defb	0b00001000	;     o   
	defb	0b00111110	;   ooooo 
	defb	0b00001000	;     o   
	defb	0b00001000	;     o   
	defb	0b00000000	;         

; Character: , (2C)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00001000	;     o   
	defb	0b00001000	;     o   
	defb	0b00010000	;    o    

; Character: - (2D)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00111110	;   ooooo 
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
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000010	;       o 
	defb	0b00000100	;      o  
	defb	0b00001000	;     o   
	defb	0b00010000	;    o    
	defb	0b00100000	;   o     
	defb	0b00000000	;         

; Character: 0 (30)
	defb	0b00000000	;         
	defb	0b00011100	;    ooo  
	defb	0b00100110	;   o  oo 
	defb	0b01001010	;  o  o o 
	defb	0b01010100	;  o o o  
	defb	0b10100100	; o o  o  
	defb	0b11001000	; oo  o   
	defb	0b01110000	;  ooo    

; Character: 1 (31)
	defb	0b00000000	;         
	defb	0b00011000	;    oo   
	defb	0b00101000	;   o o   
	defb	0b00001000	;     o   
	defb	0b00010000	;    o    
	defb	0b00100000	;   o     
	defb	0b00100000	;   o     
	defb	0b11111000	; ooooo   

; Character: 2 (32)
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b01000010	;  o    o 
	defb	0b00000100	;      o  
	defb	0b00011000	;    oo   
	defb	0b01100000	;  oo     
	defb	0b10000000	; o       
	defb	0b11111100	; oooooo  

; Character: 3 (33)
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b01000010	;  o    o 
	defb	0b00000010	;       o 
	defb	0b00001100	;     oo  
	defb	0b00000010	;       o 
	defb	0b10000100	; o    o  
	defb	0b01111000	;  oooo   

; Character: 4 (34)
	defb	0b00000000	;         
	defb	0b00001100	;     oo  
	defb	0b00110100	;   oo o  
	defb	0b01000100	;  o   o  
	defb	0b10001000	; o   o   
	defb	0b11111110	; ooooooo 
	defb	0b00010000	;    o    
	defb	0b00010000	;    o    

; Character: 5 (35)
	defb	0b00000000	;         
	defb	0b00111110	;   ooooo 
	defb	0b00100000	;   o     
	defb	0b01000000	;  o      
	defb	0b01111000	;  oooo   
	defb	0b00000100	;      o  
	defb	0b10000100	; o    o  
	defb	0b01111000	;  oooo   

; Character: 6 (36)
	defb	0b00000000	;         
	defb	0b00011100	;    ooo  
	defb	0b00100010	;   o   o 
	defb	0b01000000	;  o      
	defb	0b01111000	;  oooo   
	defb	0b10000100	; o    o  
	defb	0b10000100	; o    o  
	defb	0b01111000	;  oooo   

; Character: 7 (37)
	defb	0b00000000	;         
	defb	0b00111110	;   ooooo 
	defb	0b00000010	;       o 
	defb	0b00000100	;      o  
	defb	0b00001000	;     o   
	defb	0b00010000	;    o    
	defb	0b00100000	;   o     
	defb	0b00100000	;   o     

; Character: 8 (38)
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b01000010	;  o    o 
	defb	0b00111100	;   oooo  
	defb	0b01000010	;  o    o 
	defb	0b10000100	; o    o  
	defb	0b10000100	; o    o  
	defb	0b01111000	;  oooo   

; Character: 9 (39)
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b01000010	;  o    o 
	defb	0b01000010	;  o    o 
	defb	0b00111100	;   oooo  
	defb	0b00000100	;      o  
	defb	0b00001000	;     o   
	defb	0b11110000	; oooo    

; Character: : (3A)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00001000	;     o   
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00010000	;    o    
	defb	0b00000000	;         

; Character: ; (3B)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00010000	;    o    
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00010000	;    o    
	defb	0b00010000	;    o    
	defb	0b00100000	;   o     

; Character: < (3C)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000100	;      o  
	defb	0b00001000	;     o   
	defb	0b00010000	;    o    
	defb	0b00001000	;     o   
	defb	0b00000100	;      o  
	defb	0b00000000	;         

; Character: = (3D)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00111110	;   ooooo 
	defb	0b00000000	;         
	defb	0b01111100	;  ooooo  
	defb	0b00000000	;         
	defb	0b00000000	;         

; Character: > (3E)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00010000	;    o    
	defb	0b00001000	;     o   
	defb	0b00000100	;      o  
	defb	0b00001000	;     o   
	defb	0b00010000	;    o    
	defb	0b00000000	;         

; Character: ? (3F)
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b01000010	;  o    o 
	defb	0b00000010	;       o 
	defb	0b00001100	;     oo  
	defb	0b00010000	;    o    
	defb	0b00000000	;         
	defb	0b00110000	;   oo    

; Character: @ (40)
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b01001010	;  o  o o 
	defb	0b01010110	;  o o oo 
	defb	0b01011110	;  o oooo 
	defb	0b01000000	;  o      
	defb	0b00111100	;   oooo  
	defb	0b00000000	;         

; Character: A (41)
	defb	0b00000000	;         
	defb	0b00011100	;    ooo  
	defb	0b00100010	;   o   o 
	defb	0b00100010	;   o   o 
	defb	0b01111100	;  ooooo  
	defb	0b01000100	;  o   o  
	defb	0b10001000	; o   o   
	defb	0b10001000	; o   o   

; Character: B (42)
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b00100010	;   o   o 
	defb	0b00111100	;   oooo  
	defb	0b01000010	;  o    o 
	defb	0b01000010	;  o    o 
	defb	0b10000100	; o    o  
	defb	0b11111000	; ooooo   

; Character: C (43)
	defb	0b00000000	;         
	defb	0b00011100	;    ooo  
	defb	0b00100010	;   o   o 
	defb	0b01000000	;  o      
	defb	0b01000000	;  o      
	defb	0b10000000	; o       
	defb	0b10000100	; o    o  
	defb	0b01111000	;  oooo   

; Character: D (44)
	defb	0b00000000	;         
	defb	0b00111000	;   ooo   
	defb	0b00100100	;   o  o  
	defb	0b00100010	;   o   o 
	defb	0b01000010	;  o    o 
	defb	0b01000100	;  o   o  
	defb	0b10001000	; o   o   
	defb	0b11110000	; oooo    

; Character: E (45)
	defb	0b00000000	;         
	defb	0b00111110	;   ooooo 
	defb	0b00100000	;   o     
	defb	0b01000000	;  o      
	defb	0b01111000	;  oooo   
	defb	0b01000000	;  o      
	defb	0b10000000	; o       
	defb	0b11111000	; ooooo   

; Character: F (46)
	defb	0b00000000	;         
	defb	0b00111110	;   ooooo 
	defb	0b00100000	;   o     
	defb	0b01000000	;  o      
	defb	0b01111000	;  oooo   
	defb	0b01000000	;  o      
	defb	0b10000000	; o       
	defb	0b10000000	; o       

; Character: G (47)
	defb	0b00000000	;         
	defb	0b00011100	;    ooo  
	defb	0b00100010	;   o   o 
	defb	0b01000000	;  o      
	defb	0b01000000	;  o      
	defb	0b10001110	; o   ooo 
	defb	0b10000100	; o    o  
	defb	0b01111000	;  oooo   

; Character: H (48)
	defb	0b00000000	;         
	defb	0b00100010	;   o   o 
	defb	0b00100010	;   o   o 
	defb	0b01000100	;  o   o  
	defb	0b01111100	;  ooooo  
	defb	0b01000100	;  o   o  
	defb	0b10001000	; o   o   
	defb	0b10001000	; o   o   

; Character: I (49)
	defb	0b00000000	;         
	defb	0b00111110	;   ooooo 
	defb	0b00001000	;     o   
	defb	0b00001000	;     o   
	defb	0b00010000	;    o    
	defb	0b00100000	;   o     
	defb	0b00100000	;   o     
	defb	0b11111000	; ooooo   

; Character: J (4A)
	defb	0b00000000	;         
	defb	0b00000010	;       o 
	defb	0b00000010	;       o 
	defb	0b00000100	;      o  
	defb	0b00000100	;      o  
	defb	0b10001000	; o   o   
	defb	0b10001000	; o   o   
	defb	0b01110000	;  ooo    

; Character: K (4B)
	defb	0b00000000	;         
	defb	0b00100010	;   o   o 
	defb	0b00100100	;   o  o  
	defb	0b01001000	;  o  o   
	defb	0b01110000	;  ooo    
	defb	0b01001000	;  o  o   
	defb	0b10001000	; o   o   
	defb	0b10000100	; o    o  

; Character: L (4C)
	defb	0b00000000	;         
	defb	0b00100000	;   o     
	defb	0b00100000	;   o     
	defb	0b01000000	;  o      
	defb	0b01000000	;  o      
	defb	0b01000000	;  o      
	defb	0b10000000	; o       
	defb	0b11111100	; oooooo  

; Character: M (4D)
	defb	0b00000000	;         
	defb	0b00110110	;   oo oo 
	defb	0b00101010	;   o o o 
	defb	0b01010100	;  o o o  
	defb	0b01010100	;  o o o  
	defb	0b01000100	;  o   o  
	defb	0b10001000	; o   o   
	defb	0b10001000	; o   o   

; Character: N (4E)
	defb	0b00000000	;         
	defb	0b00100010	;   o   o 
	defb	0b00110010	;   oo  o 
	defb	0b01010100	;  o o o  
	defb	0b01010100	;  o o o  
	defb	0b01010100	;  o o o  
	defb	0b10011000	; o  oo   
	defb	0b10001000	; o   o   

; Character: O (4F)
	defb	0b00000000	;         
	defb	0b00011100	;    ooo  
	defb	0b00100010	;   o   o 
	defb	0b01000010	;  o    o 
	defb	0b01000100	;  o   o  
	defb	0b10000100	; o    o  
	defb	0b10001000	; o   o   
	defb	0b01110000	;  ooo    

; Character: P (50)
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b00100010	;   o   o 
	defb	0b01000010	;  o    o 
	defb	0b01111100	;  ooooo  
	defb	0b01000000	;  o      
	defb	0b10000000	; o       
	defb	0b10000000	; o       

; Character: Q (51)
	defb	0b00000000	;         
	defb	0b00011100	;    ooo  
	defb	0b00100010	;   o   o 
	defb	0b01000010	;  o    o 
	defb	0b01000100	;  o   o  
	defb	0b10010100	; o  o o  
	defb	0b10001000	; o   o   
	defb	0b01110100	;  ooo o  

; Character: R (52)
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b00100010	;   o   o 
	defb	0b01000010	;  o    o 
	defb	0b01111100	;  ooooo  
	defb	0b01001000	;  o  o   
	defb	0b10000100	; o    o  
	defb	0b10000100	; o    o  

; Character: S (53)
	defb	0b00000000	;         
	defb	0b00011110	;    oooo 
	defb	0b00100000	;   o     
	defb	0b00100000	;   o     
	defb	0b00011000	;    oo   
	defb	0b00000100	;      o  
	defb	0b10000100	; o    o  
	defb	0b01111000	;  oooo   

; Character: T (54)
	defb	0b00000000	;         
	defb	0b11111110	; ooooooo 
	defb	0b00010000	;    o    
	defb	0b00100000	;   o     
	defb	0b00100000	;   o     
	defb	0b00100000	;   o     
	defb	0b01000000	;  o      
	defb	0b01000000	;  o      

; Character: U (55)
	defb	0b00000000	;         
	defb	0b00100010	;   o   o 
	defb	0b00100010	;   o   o 
	defb	0b01000100	;  o   o  
	defb	0b01000100	;  o   o  
	defb	0b10001000	; o   o   
	defb	0b10001000	; o   o   
	defb	0b01110000	;  ooo    

; Character: V (56)
	defb	0b00000000	;         
	defb	0b01000010	;  o    o 
	defb	0b01000010	;  o    o 
	defb	0b01000100	;  o   o  
	defb	0b01000100	;  o   o  
	defb	0b10001000	; o   o   
	defb	0b10010000	; o  o    
	defb	0b11100000	; ooo     

; Character: W (57)
	defb	0b00000000	;         
	defb	0b00100010	;   o   o 
	defb	0b00100010	;   o   o 
	defb	0b01000100	;  o   o  
	defb	0b01010100	;  o o o  
	defb	0b10101000	; o o o   
	defb	0b10101000	; o o o   
	defb	0b01010000	;  o o    

; Character: X (58)
	defb	0b00000000	;         
	defb	0b01000010	;  o    o 
	defb	0b00100100	;   o  o  
	defb	0b00101000	;   o o   
	defb	0b00010000	;    o    
	defb	0b00101000	;   o o   
	defb	0b01001000	;  o  o   
	defb	0b10000100	; o    o  

; Character: Y (59)
	defb	0b00000000	;         
	defb	0b01000010	;  o    o 
	defb	0b00100100	;   o  o  
	defb	0b00101000	;   o o   
	defb	0b00010000	;    o    
	defb	0b00010000	;    o    
	defb	0b00100000	;   o     
	defb	0b00100000	;   o     

; Character: Z (5A)
	defb	0b00000000	;         
	defb	0b01111110	;  oooooo 
	defb	0b00000100	;      o  
	defb	0b00001000	;     o   
	defb	0b00010000	;    o    
	defb	0b00100000	;   o     
	defb	0b01000000	;  o      
	defb	0b11111100	; oooooo  

; Character: [ (5B)
	defb	0b00000000	;         
	defb	0b00001110	;     ooo 
	defb	0b00001000	;     o   
	defb	0b00001000	;     o   
	defb	0b00001000	;     o   
	defb	0b00001000	;     o   
	defb	0b00001110	;     ooo 
	defb	0b00000000	;         

; Character: \ (5C)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b01000000	;  o      
	defb	0b00100000	;   o     
	defb	0b00010000	;    o    
	defb	0b00001000	;     o   
	defb	0b00000100	;      o  
	defb	0b00000000	;         

; Character: ] (5D)
	defb	0b00000000	;         
	defb	0b01110000	;  ooo    
	defb	0b00010000	;    o    
	defb	0b00010000	;    o    
	defb	0b00010000	;    o    
	defb	0b00010000	;    o    
	defb	0b01110000	;  ooo    
	defb	0b00000000	;         

; Character: ^ (5E)
	defb	0b00000000	;         
	defb	0b00010000	;    o    
	defb	0b00111000	;   ooo   
	defb	0b01010100	;  o o o  
	defb	0b00010000	;    o    
	defb	0b00010000	;    o    
	defb	0b00010000	;    o    
	defb	0b00000000	;         

; Character: a (61)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00011100	;    ooo  
	defb	0b00000010	;       o 
	defb	0b00111110	;   ooooo 
	defb	0b01000100	;  o   o  
	defb	0b00111100	;   oooo  

; Character: b (62)
	defb	0b00000000	;         
	defb	0b00010000	;    o    
	defb	0b00010000	;    o    
	defb	0b00100000	;   o     
	defb	0b00111100	;   oooo  
	defb	0b00100010	;   o   o 
	defb	0b01000100	;  o   o  
	defb	0b01111000	;  oooo   

; Character: c (63)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00011110	;    oooo 
	defb	0b00100000	;   o     
	defb	0b01000000	;  o      
	defb	0b01000000	;  o      
	defb	0b00111100	;   oooo  

; Character: d (64)
	defb	0b00000000	;         
	defb	0b00000010	;       o 
	defb	0b00000010	;       o 
	defb	0b00000100	;      o  
	defb	0b00111100	;   oooo  
	defb	0b01000100	;  o   o  
	defb	0b01001000	;  o  o   
	defb	0b00111000	;   ooo   

; Character: e (65)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00011100	;    ooo  
	defb	0b00100010	;   o   o 
	defb	0b01111100	;  ooooo  
	defb	0b01000000	;  o      
	defb	0b00111000	;   ooo   

; Character: f (66)
	defb	0b00000000	;         
	defb	0b00001110	;     ooo 
	defb	0b00010000	;    o    
	defb	0b00010000	;    o    
	defb	0b00111000	;   ooo   
	defb	0b00100000	;   o     
	defb	0b01000000	;  o      
	defb	0b01000000	;  o      

; Character: g (67)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00011110	;    oooo 
	defb	0b00100010	;   o   o 
	defb	0b01000100	;  o   o  
	defb	0b00111100	;   oooo  
	defb	0b00000100	;      o  
	defb	0b01111000	;  oooo   

; Character: h (68)
	defb	0b00000000	;         
	defb	0b00010000	;    o    
	defb	0b00010000	;    o    
	defb	0b00100000	;   o     
	defb	0b00111100	;   oooo  
	defb	0b00100010	;   o   o 
	defb	0b01000100	;  o   o  
	defb	0b01000100	;  o   o  

; Character: i (69)
	defb	0b00000000	;         
	defb	0b00001000	;     o   
	defb	0b00000000	;         
	defb	0b00011000	;    oo   
	defb	0b00001000	;     o   
	defb	0b00010000	;    o    
	defb	0b00100000	;   o     
	defb	0b01110000	;  ooo    

; Character: j (6A)
	defb	0b00000000	;         
	defb	0b00000100	;      o  
	defb	0b00000000	;         
	defb	0b00000100	;      o  
	defb	0b00000100	;      o  
	defb	0b01001000	;  o  o   
	defb	0b01001000	;  o  o   
	defb	0b00110000	;   oo    

; Character: k (6B)
	defb	0b00000000	;         
	defb	0b00010000	;    o    
	defb	0b00010000	;    o    
	defb	0b00100000	;   o     
	defb	0b00100100	;   o  o  
	defb	0b00111000	;   ooo   
	defb	0b01000100	;  o   o  
	defb	0b01000100	;  o   o  

; Character: l (6C)
	defb	0b00000000	;         
	defb	0b00001000	;     o   
	defb	0b00001000	;     o   
	defb	0b00010000	;    o    
	defb	0b00010000	;    o    
	defb	0b00100000	;   o     
	defb	0b00100000	;   o     
	defb	0b00011000	;    oo   

; Character: m (6D)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00110100	;   oo o  
	defb	0b00101010	;   o o o 
	defb	0b00101010	;   o o o 
	defb	0b01010100	;  o o o  
	defb	0b01010100	;  o o o  

; Character: n (6E)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00111100	;   oooo  
	defb	0b00100010	;   o   o 
	defb	0b00100010	;   o   o 
	defb	0b01000100	;  o   o  
	defb	0b01000100	;  o   o  

; Character: o (6F)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00011100	;    ooo  
	defb	0b00100010	;   o   o 
	defb	0b00100010	;   o   o 
	defb	0b01000100	;  o   o  
	defb	0b01000100	;  o   o  
	defb	0b00111000	;   ooo   

; Character: p (70)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00011100	;    ooo  
	defb	0b00010010	;    o  o 
	defb	0b00100010	;   o   o 
	defb	0b00111100	;   oooo  
	defb	0b01000000	;  o      
	defb	0b01000000	;  o      

; Character: q (71)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00011110	;    oooo 
	defb	0b00100010	;   o   o 
	defb	0b00100100	;   o  o  
	defb	0b00011100	;    ooo  
	defb	0b00001000	;     o   
	defb	0b00001100	;     oo  

; Character: r (72)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00001110	;     ooo 
	defb	0b00010000	;    o    
	defb	0b00010000	;    o    
	defb	0b00100000	;   o     
	defb	0b00100000	;   o     

; Character: s (73)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00011110	;    oooo 
	defb	0b00100000	;   o     
	defb	0b00011000	;    oo   
	defb	0b00000100	;      o  
	defb	0b01111000	;  oooo   

; Character: t (74)
	defb	0b00000000	;         
	defb	0b00001000	;     o   
	defb	0b00001000	;     o   
	defb	0b00011100	;    ooo  
	defb	0b00001000	;     o   
	defb	0b00010000	;    o    
	defb	0b00010000	;    o    
	defb	0b00100000	;   o     

; Character: u (75)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00100010	;   o   o 
	defb	0b00100010	;   o   o 
	defb	0b01000100	;  o   o  
	defb	0b01000100	;  o   o  
	defb	0b00111000	;   ooo   

; Character: v (76)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00100010	;   o   o 
	defb	0b00100010	;   o   o 
	defb	0b01000100	;  o   o  
	defb	0b01001000	;  o  o   
	defb	0b00110000	;   oo    

; Character: w (77)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00100010	;   o   o 
	defb	0b00101010	;   o o o 
	defb	0b01010100	;  o o o  
	defb	0b01010100	;  o o o  
	defb	0b00101000	;   o o   

; Character: x (78)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00100100	;   o  o  
	defb	0b00101000	;   o o   
	defb	0b00011000	;    oo   
	defb	0b00100100	;   o  o  
	defb	0b01000100	;  o   o  

; Character: y (79)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00100010	;   o   o 
	defb	0b00100010	;   o   o 
	defb	0b00011100	;    ooo  
	defb	0b00000100	;      o  
	defb	0b01111000	;  oooo   

; Character: z (7A)
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00111110	;   ooooo 
	defb	0b00000100	;      o  
	defb	0b00011000	;    oo   
	defb	0b00100000	;   o     
	defb	0b01111100	;  ooooo  

; Character: { (7B)
	defb	0b00000000	;         
	defb	0b00001110	;     ooo 
	defb	0b00001000	;     o   
	defb	0b00110000	;   oo    
	defb	0b00001000	;     o   
	defb	0b00001000	;     o   
	defb	0b00001110	;     ooo 
	defb	0b00000000	;         

; Character: | (7C)
	defb	0b00000000	;         
	defb	0b00001000	;     o   
	defb	0b00001000	;     o   
	defb	0b00001000	;     o   
	defb	0b00001000	;     o   
	defb	0b00001000	;     o   
	defb	0b00001000	;     o   
	defb	0b00000000	;         

; Character: } (7D)
	defb	0b00000000	;         
	defb	0b01110000	;  ooo    
	defb	0b00010000	;    o    
	defb	0b00001100	;     oo  
	defb	0b00010000	;    o    
	defb	0b00010000	;    o    
	defb	0b01110000	;  ooo    
	defb	0b00000000	;         

; Character: ~ (7E)
	defb	0b00000000	;         
	defb	0b00010100	;    o o  
	defb	0b00101000	;   o o   
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         
	defb	0b00000000	;         

