
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_printf_n

EXTERN __stdio_nextarg_hl, l_utod_de

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
   pop de                      ; de = count of chars output thus far
   
   call l_utod_de              ; de = (int)(unsigned int de)

   ld (hl),e
   inc hl
   ld (hl),d                   ; store count
   
   ret                         ; carry reset
