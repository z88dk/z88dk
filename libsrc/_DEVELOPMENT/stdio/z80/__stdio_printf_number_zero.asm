
XLIB __stdio_printf_number_zero

LIB __stdio_printf_number_tail_zero

__stdio_printf_number_zero:

   ; ix = FILE *
   ; hl = 0
   ; stack = buffer_digits, width, precision
   ; carry reset
   
   ld c,l
   ld b,h                      ; bc = num_sz = 0

   pop de                      ; de = internal_spacing = precision
   
   pop hl                      ; hl = width
   sbc hl,de                   ; hl = external_spacing = width - precision
   
   jp nc, __stdio_printf_number_tail_zero
   
   ld hl,0                     ; width field exceeded, external_spacing = 0
   jp __stdio_printf_number_tail_zero
