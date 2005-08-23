; 04.2004 aralbrec

XLIB IM2Init
XREF _im2_vtable

; DISABLE INTERRUPTS PRIOR TO CALLING

; Creates the im2 vector table, sets im2 mode and
; writes the appropriate value to the I register.
; Once interrupts are reenabled, im2 mode will be
; active.
;
; enter:  A = 0 for 256 byte tbl, otherwise 257 bytes
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
   ld bc,254
   or a
   jr z, smalltbl
   inc bc
.smalltbl
   ldir

   ld a,_im2_vtable/256
   ld i,a
   im 2
   ret
