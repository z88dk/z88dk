start:
dma.wr0 1			; OK
dma.wr0				; missing argument
dma.wr0 9, ext		; ext not constant
dma.wr0 9, start	; start not constant
dma.wr0 9, $		; ASMPC not constant
dma.wr0 -1			; -1 out of range
REPTI I, 255, 0, 2, 3, 128
	dma.wr0 I		; illegal base register
ENDR
dma.wr0 1, 99		; too many arguments
dma.wr0 1,
		   99		; too many arguments
dma.wr0 0x09		; missing group member
