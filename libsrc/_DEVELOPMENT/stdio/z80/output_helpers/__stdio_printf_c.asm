
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_printf_c

EXTERN __stdio_nextarg_hl
EXTERN __stdio_send_output_chars, __stdio_printf_padding_width_hl

__stdio_printf_c:

   ; %c converter called from vfprintf()
   ;
   ; enter : ix = FILE*
   ;         hl = void *stack_param
   ;         stack = buffer_digits, width, precision
   ;
   ; exit  : carry set if stream error

   pop de                      ; junk precision
   call __stdio_nextarg_hl     ; l = char

   bit 2,(ix+5)                ; left justify ?
   jr nz, left_justify

right_justify:

   ex (sp),hl                  ; hl = width
   call width_padding          ; satisfy width

   pop de                      ; e = char
   pop hl                      ; junk buffer_digits
   
   ret c                       ; if stream error
   
output_char:

   ld bc,1
   jp __stdio_send_output_chars

left_justify:

   ld e,l
   call output_char
   
   pop hl                      ; hl = width
   pop de                      ; junk buffer_digits
   
   ret c                       ; if stream error
   
width_padding:

   ld a,h
   or l
   ret z
   
   dec hl
   jp __stdio_printf_padding_width_hl
