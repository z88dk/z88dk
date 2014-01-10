
XLIB __stdio_printf_lu

LIB __stdio_nextarg_de, __stdio_nextarg_hl, __stdio_printf_number_tail, __stdio_printf_number_zero, l_ultoa

__stdio_printf_lu:

   ; %lu converter called from vfprintf()
   ;
   ; enter : ix = FILE *
   ;         hl = void *stack_param
   ;         de = void *buffer_digits
   ;         stack = buffer_digits, width, precision
   ;
   ; exit  : carry set if stream error
   ;
   ; NOTE: (buffer_digits - 3) points at buffer space of three free bytes

   ; read uint to convert
   
   ld c,e
   ld b,d                      ; bc = buffer_digits
   
   ; read unsigned long
   
   call __stdio_nextarg_de     ; de = MSW of long
   call __stdio_nextarg_hl     ; hl = LSW of long
   
   or h
   or e
   or d
   jp z, __stdio_printf_number_zero  ; if long is zero
   
   ; convert unsigned long to ascii buffer
   
   push bc                     ; save buffer_digits
   
   exx
   push bc
   push hl
   exx

   call l_ultoa                ; convert long in dehl to ascii digits in buffer at bc

   exx
   pop hl
   pop bc
   exx
   
   pop hl
   ex de,hl                    ; de = buffer_digits
   
   sbc hl,de
   ld c,l
   ld b,h                      ; bc = num_sz = number of digits in ascii string
      
   ; ix = FILE *
   ; bc = num_sz
   ; stack = buffer_digits, width, precision
   
   jp __stdio_printf_number_tail
