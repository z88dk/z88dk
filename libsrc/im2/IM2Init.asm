; 04.2004 aralbrec

XLIB IM2Init

; DISABLE INTERRUPTS PRIOR TO CALLING

; Creates the im2 vector table, sets im2 mode and
; writes the appropriate value to the I register.
; Once interrupts are reenabled, im2 mode will be
; active.
;
; enter:  E = size of interrupt vector table minus 2; at least 1
;             = 254 for 256-byte table, 255 for 257-byte table
;         D = MSB of interrupt vector table address
;        BC = default ISR address
; uses : AF,BC,DE,HL,I

.IM2Init

   ld a,d
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
