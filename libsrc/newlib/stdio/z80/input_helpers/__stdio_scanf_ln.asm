
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_scanf_ln

__stdio_scanf_ln:

   ; %ln converter called from vfscanf()
   ;
   ; enter : hl = long *p
   ;
   ; exit  : carry reset
   ;
   ; uses  : all except ix

   ld a,h
   or l
   ret z                       ; if assignment suppressed
   
   exx
   push de
   exx
   pop de                      ; de = number of chars read from stream
   
   ld (hl),e
   inc hl
   ld (hl),d
   inc hl
   
   xor a
   ld (hl),a
   inc hl
   ld (hl),a
   
   ret
