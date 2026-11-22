
SECTION code_clib
SECTION code_l

PUBLIC l_fast_ultob

EXTERN l_fast_utob, l_setmem_de
   
l_fast_ultob:

   ; write unsigned binary long to ascii buffer
   ;
   ; enter : dehl = unsigned long
   ;           bc = char *buffer
   ;         carry set to write leading zeroes
   ;
   ; exit  : de   = char *buffer (one byte past last char written)
   ;         carry set if in write loop
   ;
   ; uses  : af, b, de, hl

   inc e
   dec e
   jr nz, bit_32

   inc d
   dec d
   jr nz, bit_32
   
   ; 16-bit number
   
   ld e,c
   ld d,b

   jp nc, l_fast_utob

   ld a,'0'
   call l_setmem_de - 16
   call l_setmem_de - 16
   
   jp l_fast_utob

bit_32:

   push hl                     ; save least significant word
   ex de,hl

   ld e,c
   ld d,b
   
   call l_fast_utob            ; write most significant binary digits
   jr c, was_writing
   
   dec de                      ; remove solo '0' in buffer
   
was_writing:

   pop hl                      ; hl = least significant word
   jp l_fast_utob              ; write last binary digits
