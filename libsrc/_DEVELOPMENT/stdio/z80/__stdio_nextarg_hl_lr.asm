
XLIB __stdio_nextarg_hl

__stdio_nextarg_hl:

   ; return next 16-bit parameter from parameter list
   ;
   ; enter : hl = void *stack_param
   ;
   ; exit  : hl = 16-bit parameter
   ;          a = l
   ;
   ; uses  : a, hl
   
   ld a,(hl)
   dec hl
   ld l,(hl)
   ld h,a
   
   ld a,l
   ret
