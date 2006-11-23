; 04.2004 aralbrec

XLIB IM2Init
XREF _im2_vtable

; DISABLE INTERRUPTS PRIOR TO CALLING

; Creates the im2 vector table, sets im2 mode and
; writes the appropriate value to the I register.
; Once interrupts are reenabled, im2 mode will be
; active.
;
; enter:  A = size of interrupt vector table minus 2; at least 1
;             = 254 for 256-byte table, 255 for 257-byte table
;        BC = default ISR address
; uses : AF,BC,DE,HL,I

.IM2Init
   ld hl,256*(_im2_vtable/256)
   ld e,l
   ld d,h
   ld (hl),c
   inc hl
   ld (hl),b
   inc hl
   ex de,hl
   ld b,0
   ld c,a
   ldir

   ld a,_im2_vtable/256
   ld i,a
   im 2
   ret
