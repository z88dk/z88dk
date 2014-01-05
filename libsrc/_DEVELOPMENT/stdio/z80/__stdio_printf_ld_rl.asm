
XLIB __stdio_printf_ld
XDEF __stdio_printf_li

LIB __stdio_nextarg_de, __stdio_nextarg_hl, __stdio_printf_number_tail, __stdio_printf_number_zero, l_neg_dehl, l_ultoa

__stdio_printf_ld:
__stdio_printf_li:

   ; %ld, %li converter called from vfprintf()
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
   
   ; integer negative ?
   
   bit 7,d
   jr z, positive              ; if integer is positive
   
   set 7,(ix+5)                ; set negative flag
   call l_neg_dehl             ; change to positive for conversion
   
positive:

   ; convert integer to ascii buffer
   
   push bc                     ; save buffer_digits
   
   call l_ultoa                ; convert integer in dehl to ascii digits in buffer at bc
   
   pop hl
   ex de,hl                    ; de = buffer_digits
   
   sbc hl,de
   ld c,l
   ld b,h                      ; bc = num_sz = number of digits in ascii string
      
   ; ix = FILE *
   ; bc = num_sz
   ; stack = buffer_digits, width, precision
   
   jp __stdio_printf_number_tail
