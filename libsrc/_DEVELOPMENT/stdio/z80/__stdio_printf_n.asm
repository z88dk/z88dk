
XLIB __stdio_printf_n

LIB __stdio_nextarg_hl

__stdio_printf_n:

   ; %n converter called from vfprintf()
   ;
   ; enter : ix = FILE *
   ;         hl = void *stack_param
   ;         stack = buffer_digits, width, precision
   ;
   ; exit  : carry reset

   pop de
   pop de
   pop de                      ; clear stack
   
   call __stdio_nextarg_hl     ; hl = int *
   
   or h
   ret z                       ; if given nullptr
   
   exx
   push hl
   exx
   pop bc                      ; bc = count of chars output thus far
   
   bit 7,b
   jr z, count_ok              ; if count hasn't caused signed overflow
   
   ld bc,$7fff                 ; saturate at signed max

count_ok:

   ld (hl),c
   inc hl
   ld (hl),b                   ; store count
   
   ret                         ; carry reset
