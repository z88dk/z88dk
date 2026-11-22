
SECTION code_clib
SECTION code_adt_wa_priority_queue

PUBLIC __w_heap_swap

__w_heap_swap:

   ; enter : hl = word *
   ;         de = word *
   ;
   ; exit  : hl = word * (unchanged)
   ;         de += 2
   ;         swap two words at addresses de, hl
   ;
   ; uses  : af, bc, de

   ld a,(de)
   ldi

   ld c,a
   ld a,(de)
   ld b,a
   
   ld a,(hl)
   ld (de),a

   ld (hl),b   
   dec hl
   ld (hl),c

   inc de
   ret
