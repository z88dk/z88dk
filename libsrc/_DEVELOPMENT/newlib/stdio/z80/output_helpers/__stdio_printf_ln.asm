
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_printf_ln

EXTERN __stdio_nextarg_hl

__stdio_printf_ln:

   ; %ln converter called from vfprintf()
   ;
   ; enter : ix = FILE *
   ;         hl = void *stack_param
   ;         stack = buffer_digits, width, precision
   ;
   ; exit  : carry reset

   pop de
   pop de
   pop de                      ; clear stack
   
   call __stdio_nextarg_hl     ; hl = long *
   
   or h
   ret z                       ; if given nullptr
   
   exx
   push hl
   exx
   pop de                      ; de = count of chars output thus far

   xor a
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; store count
   inc hl
   
   ld (hl),a
   inc hl
   ld (hl),a
   
   ret                         ; carry reset
