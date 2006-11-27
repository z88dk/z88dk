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
   inc hl
   ld d,(hl)
   inc hl
   ld e,(hl)
   jp IM2Init

; enter:  E = size of interrupt vector table minus 2; at least 1
;             = 254 for 256-byte table, 255 for 257-byte table
;         D = MSB of interrupt vector table address
;        BC = default ISR address
; uses : AF,BC,DE,HL,I
