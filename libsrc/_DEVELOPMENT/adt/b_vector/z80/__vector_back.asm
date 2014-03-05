
XLIB __vector_back

__vector_back:

   ; enter : hl = vector *
   ;
   ; exit  : de = vector.array
   ;         bc = vector.size
   ;         hl = & vector.size + 1b
   ;
   ;         z flag set if vector is empty
   ;
   ; uses  : af, bc, de, hl
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = vector.array
   inc hl
   
   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = vector.size

   ld a,b
   or c
   ret
