
XLIB __w_vector_write_n

LIB asm_memcpy

__w_vector_write_n:

   ; write n copies of item into the array
   ;
   ; enter : hl = & vector.array[idx] = dst
   ;         de = item
   ;         bc = number of words * 2 (bytes, even)
   ;
   ; exit  : hl = & vector.array[idx]
   ;
   ; uses  : af, bc, de
   
   ld a,b
   or c
   ret z                       ; if nothing to write
   
   dec bc
   dec bc
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; write first item into vector
   
   ld e,l
   ld d,h
   inc de                      ; de = dst
   dec hl                      ; hl = src
   
   call asm_memcpy
   
   dec hl
   dec hl                      ; hl = & vector.array[idx]
   
   ret
