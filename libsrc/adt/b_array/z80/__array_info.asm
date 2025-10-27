SECTION code_clib
SECTION code_adt_b_array

PUBLIC __array_info

__array_info:

   ; enter : hl = array *
   ;
   ; exit  : de = array.data
   ;         bc = array.size
   ;         hl = & array.size + 1b
   ;
   ;         z flag set if array is empty
   ;
   ; uses  : af, bc, de, hl
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = array.data
   inc hl
   
   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = array.size

   ld a,b
   or c
   ret
