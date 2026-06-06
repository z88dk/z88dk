start:
dma.wr2 0x00		; OK
dma.wr2				; missing argument
dma.wr2 0x40, ext	; ext not constant
dma.wr2 0x40, start	; start not constant
dma.wr2 0x40, $		; ASMPC not constant
REPTI I, 1, 2, 3, 4, 5, 6, 7, 0x80, 0xFF
	dma.wr2 I		; illegal base register
ENDR
dma.wr2 0x40 		; missing group member
dma.wr2 0x40, 0x20	; missing group member
REPTI I, 0x03, 0x10, 0x13, 0x87
	dma.wr2 0x40, I	; illegal port B timing
ENDR
dma.wr2 0x00, 99	; too many arguments
