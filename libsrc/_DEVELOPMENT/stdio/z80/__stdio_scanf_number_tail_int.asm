
XLIB __stdio_scanf_number_tail_int

LIB l_saturated_inc_hl

__stdio_scanf_number_tail_int:

   ; enter : de = int *p
   ;         hl = integer

   ; WRITE INTEGER TO INT *P
   
   ld a,d
   or e
   ret z                       ; if assignment is suppressed
   
   exx
   call l_saturated_inc_hl     ; items assigned++
   exx
   
   ex de,hl
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; *p = integer
   
   or a
   ret
