; void __FASTCALL__ adt_StackCreateS(struct adt_Stack *s)
; 11.2006 aralbrec

XLIB adt_StackCreateS

; initialize an adt_Stack*

.adt_StackCreateS

   xor a
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   ret

