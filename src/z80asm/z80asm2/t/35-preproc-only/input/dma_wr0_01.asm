dma.wr0 1
dma.wr0 0x09, 1					; bit 3
dma.wr0 0x11, 2					; bit 4
dma.wr0 0x19, 0x8002			; bits 3 and 4
dma.wr0 0x21, 2					; bit 5
dma.wr0 0x41, 2					; bit 6
dma.wr0 0x61, 0x8002			; bits 5 and 6
dma.wr0 0x29, 1, 2				; bits 3 and 5
dma.wr0 0x51, 1, 2				; bits 4 and 6
dma.wr0 0x49, 1, 2				; bits 3 and 6
dma.wr0 0x31, 1, 2				; bits 4 and 5
dma.wr0 0x79, 0x4002, 0x8002	; bits 3, 4, 5 and 6
