
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_scanf_n

EXTERN l_utod_de

__stdio_scanf_n:

   ; %n converter called from vfscanf()
   ;
   ; enter : hl = int *p
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
   
   call l_utod_de              ; unsigned to signed on de
   
   ld (hl),e
   inc hl
   ld (hl),d
   
   ret
