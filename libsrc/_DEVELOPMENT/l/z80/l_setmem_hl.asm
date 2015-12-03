
SECTION code_clib
SECTION code_l

PUBLIC l_setmem_hl

   ; write byte to buffer pointed at by hl
   ; invoke with "call l_setmem_hl - (n*2)" to write n bytes to memory
   ;
   ; enter : hl = char *buffer
   ;          a = fill byte
   ;
   ; exit  : hl = char *buffer (one byte past last byte written)
   ;
   ; uses  : hl

   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl

   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl

   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl

   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl

l_setmem_hl:

   ret
