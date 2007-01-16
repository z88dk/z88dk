; void __CALLEE__ im2_Init_callee(uchar size, void *tableaddr, void *default_isr)
; 04.2004 aralbrec

XLIB im2_Init_callee
XDEF ASMDISP_IM2_INIT_CALLEE

.im2_Init_callee

   pop hl
   pop bc
   pop af
   pop de
   push hl

.asmentry

; enter:  e = size of interrupt vector table minus 2; at least 1
;             = 254 for 256-byte table, 255 for 257-byte table
;         a = MSB of interrupt vector table address
;        bc = default ISR address
; uses : af, bc, de, hl, i

.IM2Init

   ld i,a
   ld a,e
   
   ld e,0
   ld h,d
   ld l,e
   ld (hl),c
   inc hl
   ld (hl),b
   inc hl
   ex de,hl
   ld b,0
   ld c,a
   ldir

   im 2
   ret

DEFC ASMDISP_IM2_INIT_CALLEE = asmentry - im2_Init_callee
