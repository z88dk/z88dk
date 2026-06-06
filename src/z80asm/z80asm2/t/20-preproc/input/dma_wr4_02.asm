start:
dma.wr4 0x40		; OK
dma.wr4				; missing argument
dma.wr4 0x44, ext	; ext not constant
dma.wr4 0x44, start	; start not constant
dma.wr4 0x44, $		; ASMPC not constant
dma.wr4 2			; illegal base register
REPTI I, 0x24, 0x44, 0x28, 0x48, 0x4C
	dma.wr4 I 		; missing group member
ENDR
REPTI I, 0x10, 0x11, 0x30, 0x70
	dma.wr4 I 		; interrupts not supported
ENDR
REPTI I, 0x00, 0x01, 0x60, 0x61
	dma.wr4 I 		; illegal mode
ENDR
dma.wr4 0x40, 99	; too many arguments
