
XLIB __stdio_printf_s

LIB __stdio_nextarg_hl, asm_strnlen, __stdio_send_output

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
   
   ld a,h
   or l
   jr nz, string_valid         ; if s != 0
   
   ld hl,null_s                ; output special string for NULL

string_valid:

   bit 0,(ix+5)
   jr nz, precision_specified

   ld bc,$ffff                 ; override default precision = 1

precision_specified:

   call asm_strnlen
   jr z, empty_string
   
   ; hl = min(strlen(s), precision) = string_length
   ; de = char *s
   ; stack = buffer_digits, width

   ex de,hl                    ; de = string_length
   ex (sp),hl                  ; hl = width
   
   scf
   sbc hl,de                   ; hl = necessary padding - 1
   jr c, string_only 

   inc hl

   ; hl = necessary padding
   ; de = string_length
   ; stack = buffer_digits, char *s
   
   bit 2,(ix+5)
   jr nz, left_justify

right_justify:

   push de                     ; save string_length
   
   ld c,l
   ld b,h
   call width_padding
   
   pop bc                      ; bc = string_length
   pop hl                      ; hl = char *s
   pop de                      ; junk buffer_digits
   
   ret c                       ; if stream error
   
output_string:

   ; hl = char *s
   ; bc = string_length > 0
   
   ld a,STDIO_MSG_WRIT
   jp __stdio_send_output

left_justify:

   ex (sp),hl                  ; hl = char *s
   
   ld c,e
   ld b,d                      ; bc = string_length
   
   call output_string
   
   pop bc                      ; bc = necessary padding
   pop de                      ; junk buffer_digits
   
   ret c                       ; if stream error

width_padding:

   ; bc = necessary padding > 0
   
   ld e,' '
   
   ld a,STDIO_MSG_PUTC
   jp __stdio_send_output

empty_string:

   ; stack = buffer_digits, width
   
   pop bc                      ; bc = width
   pop de                      ; junk buffer_digits
   
   ld a,b
   or c
   jr nz, width_padding
   
   ret

string_only:

   ; de = string_length
   ; stack = buffer_digits, char *s

   ld c,e
   ld b,d                      ; bc = string_length
   
   pop hl                      ; hl = char *s
   pop de                      ; junk buffer_digits
   
   jr output_string

null_s:

   defm "(null)"
   defb 0
