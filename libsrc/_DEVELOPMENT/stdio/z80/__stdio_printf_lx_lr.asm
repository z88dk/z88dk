
XLIB __stdio_printf_lx

LIB __stdio_nextarg_de, __stdio_nextarg_hl, __stdio_printf_number_tail, __stdio_printf_number_zero, l_ultoh

__stdio_printf_lx:

   ; %lx, %lX converter called from vfprintf()
   ;
   ; enter : ix = FILE *
   ;         hl = void *stack_param
   ;         de = void *buffer_digits
   ;         stack = buffer_digits, width, precision
   ;
   ; exit  : carry set if stream error
   ;
   ; NOTE: (buffer_digits - 3) points at buffer space of three free bytes

   ld c,e
   ld b,d                      ; bc = void *buffer_digits

   ; read long to convert
   
   call __stdio_nextarg_de     ; de = MSW of long
   call __stdio_nextarg_hl     ; hl = LSW of long
   
   or h
   or e
   or d
   jp z, __stdio_printf_number_zero  ; if integer is zero
   
   ; convert unsigned long to ascii buffer
   
   push bc                     ; save buffer_digits
   
   call l_ultoh                ; convert unsigned long in hl to ascii digits in buffer at de
   
   pop hl
   ex de,hl                    ; de = buffer_digits
   
   or a
   sbc hl,de
   ld c,l
   ld b,h                      ; bc = num_sz = number of digits in ascii string
      
   ; ix = FILE *
   ; bc = num_sz
   ; stack = buffer_digits, width, precision
   
   jp __stdio_printf_number_tail
