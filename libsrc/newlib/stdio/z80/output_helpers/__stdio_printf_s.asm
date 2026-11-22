
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_printf_s

EXTERN __stdio_nextarg_hl, asm_strnlen
EXTERN __stdio_send_output_buffer, __stdio_printf_padding_width_hl, __stdio_printf_padding_width_bc

__stdio_printf_s:

   ; %s converter called from vfprintf()
   ;
   ; enter : ix = FILE *
   ;         hl = void *stack_param
   ;         de = void *buffer_digits
   ;         stack = buffer_digits, width, precision
   ;
   ; exit  : carry set if stream error

   call __stdio_nextarg_hl     ; hl = char *s
   pop bc                      ; bc = precision
   
   or h
   jr nz, string_valid         ; if s != 0
   
   ld hl,null_s                ; output special string for NULL

string_valid:

   bit 0,(ix+5)
   jr nz, precision_specified

   ld bc,$ffff                 ; override default precision = 1

precision_specified:

   call asm_strnlen
   
   ; hl = min(strlen(s), precision) = string_length
   ; de = char *s
   ; stack = buffer_digits, width
   ; carry reset

   ex de,hl                    ; de = string_length
   ex (sp),hl                  ; hl = width
   
   sbc hl,de                   ; hl = required padding
   jr nc, padding_required
   
   ld hl,0

padding_required:

   ; hl = required padding
   ; de = string_length
   ; stack = buffer_digits, char *s
   
   bit 2,(ix+5)
   jr nz, left_justify

right_justify:

   push de                     ; save string_length
   
   call __stdio_printf_padding_width_hl
   
   pop bc                      ; bc = string_length
   pop hl                      ; hl = char *s
   pop de                      ; junk buffer_digits
   
   jp nc, __stdio_send_output_buffer  ; if no stream error
   ret

left_justify:

   ex (sp),hl                  ; hl = char *s
   
   ld c,e
   ld b,d                      ; bc = string_length
   
   call __stdio_send_output_buffer
   
   pop bc                      ; bc = necessary padding
   pop de                      ; junk buffer_digits
   
   jp nc, __stdio_printf_padding_width_bc  ; if no stream error
   ret

null_s:

   defm "<null>"
   defb 0
