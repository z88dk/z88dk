
XLIB __stdio_nextarg_de

__stdio_nextarg_de:

   ; return next 16-bit parameter from parameter list
   ;
   ; enter : hl = void *stack_param
   ;
   ; exit  : de = 16-bit parameter
   ;         hl = hl - 2
   ;
   ; uses  : de, hl
   
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   
   ret
