
XLIB __stdio_printf_c

LIB __stdio_nextarg_hl

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

output_bytes:

   ld a,STDIO_MSG_PUTC   
   jp __stdio_send_output

left_justify:

   ld e,l
   call output_char
   
   pop hl                      ; hl = width
   pop de                      ; junk buffer_digits
   
   ret c                       ; if stream error
   
width_padding:

   ; hl = width
   
   ld a,h
   or a
   jr nz, need_padding
   
   or l
   ret z                       ; if width == 0
   
   dec a
   ret z                       ; if width == 1

need_padding:

   dec hl
   
   ld e,' '
   ld c,l
   ld b,h                      ; bc = number of padding chars
   
   jr output_bytes
