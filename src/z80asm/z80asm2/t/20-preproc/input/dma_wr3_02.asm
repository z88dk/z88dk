start:
dma.wr3 0x00		; OK
dma.wr3				; missing argument
dma.wr3 0x88, ext	; ext not constant
dma.wr3 0x88, start	; start not constant
dma.wr3 0x88, $		; ASMPC not constant
REPTI I, 1, 2, 3, 0x67
	dma.wr3 I		; illegal base register
ENDR
REPTI I, 0x08, 0x10, 0x88
	dma.wr3 I 		; missing group member
ENDR
dma.wr3 0x18, 0x44	; missing group member
dma.wr3 0x98, 0x17	; missing group member
dma.wr3 0x00, 99	; too many arguments
