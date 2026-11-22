SECTION code_clib
SECTION code_adt_w_array

PUBLIC __w_array_write_n

EXTERN asm_memcpy

__w_array_write_n:

   ; write n copies of item into the array
   ;
   ; enter : hl = & array.data[idx] = dst
   ;         de = item
   ;         bc = number of words * 2 (bytes)
   ;
   ; exit  : hl = & array.data[idx]
   ;
   ; uses  : af, bc, de
   
   ld a,b
   or c
   ret z                       ; if nothing to write
   
   dec bc
   dec bc
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; write first item into array
   
   ld e,l
   ld d,h
   inc de                      ; de = dst
   dec hl                      ; hl = src
   
   call asm_memcpy
   
   dec hl
   dec hl                      ; hl = & array.data[idx]
   
   ret
