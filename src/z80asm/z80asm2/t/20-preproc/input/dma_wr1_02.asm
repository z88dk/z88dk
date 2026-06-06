start:
dma.wr1 0x04		; OK
dma.wr1				; missing argument
dma.wr1 0x44, ext	; ext not constant
dma.wr1 0x44, start	; start not constant
dma.wr1 0x44, $		; ASMPC not constant
REPTI I, 1, 2, 3, 5, 6, 7, 0x80, 0x84, 0xFF
	dma.wr1 I		; illegal base register
ENDR
dma.wr1 0x44		; missing group member
REPTI I, 0x03, 0x10, 0x20, 0x30, 0x33, 0x8F
	dma.wr1 0x44, I	; illegal port A timing
ENDR
dma.wr1 0x04, 99	; too many arguments
