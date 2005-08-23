; 05.2005 aralbrec

XLIB im2_Init
LIB IM2Init

.im2_Init
   ld hl,2
   add hl,sp
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld a,(hl)
   jp IM2Init

; enter:  A = 0 for 256 byte tbl, otherwise 257 bytes
;        BC = default ISR address
; uses : AF,BC,DE,HL,I
