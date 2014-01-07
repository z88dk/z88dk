
XLIB __stdio_printf_lx
XDEF __stdio_printf_lX

LIB __stdio_nextarg_de, __stdio_nextarg_hl, __stdio_printf_number_tail, __stdio_printf_number_zero, l_ultoh

__stdio_printf_lX:

   set 7,(ix+4)                ; set capitalize flag

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
   
   call __stdio_nextarg_de     ; de = LSW of long
   call __stdio_nextarg_hl     ; hl = MSW of long
   
   or h
   or e
   or d
   jp z, __stdio_printf_number_zero  ; if integer is zero
   
   ex de,hl                    ; dehl = long
   
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
