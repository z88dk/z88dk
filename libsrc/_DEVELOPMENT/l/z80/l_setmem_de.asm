
SECTION code_clib
SECTION code_l

PUBLIC l_setmem_de

   ; write byte to buffer pointed at by de
   ; invoke with "call l_setmem_de - (n*2)" to write n bytes to memory  
   ;
   ; enter : de = char *buffer
   ;          a = fill byte
   ;
   ; exit  : de = char *buffer (one byte past last byte written)
   ;
   ; uses  : de

   ld (de),a
   inc de
   ld (de),a
   inc de
   ld (de),a
   inc de
   ld (de),a
   inc de

   ld (de),a
   inc de
   ld (de),a
   inc de
   ld (de),a
   inc de
   ld (de),a
   inc de

l_setmem_de:

   ret
