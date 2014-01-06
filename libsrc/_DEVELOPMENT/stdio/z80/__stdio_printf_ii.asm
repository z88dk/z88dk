
XLIB __stdio_printf_I

LIB __stdio_nextarg_de, __stdio_nextarg_hl, l_utoa, __stdio_send_output

__stdio_printf_I:

   ; non-standard %I converter called from vfprintf()
   ; output host order IPv4 address in dotted decimal form
   ;
   ; enter : ix = FILE *
   ;         hl = void *stack_param
   ;         de = void *buffer_digits
   ;         stack = buffer_digits, width, precision
   ;
   ; exit  : carry set if stream error

   ld c,e
   ld b,d                      ; bc = buffer_digits
   
   ; read host order IPv4 address
   
   call __stdio_nextarg_de     ; de = MSW of long
   call __stdio_nextarg_hl     ; hl = LSW of long
   
   ; write octets to buffer

   ex de,hl                    ; hl = MSW
   push de                     ; save LSW of long
   
   ld e,c
   ld d,b                      ; de = buffer_digits
   
   ; byte 3
   
   push hl                     ; save MSW of long

   ld l,h
   ld h,0
   
   call write_octet
   
   ; byte 2
   
   pop hl
   ld h,0
   
   call write_octet
   
   ; byte 1
   
   pop hl
   push hl
   
   ld l,h
   ld h,0
   
   call write_octet
   
   ; byte 0
   
   pop hl
   ld h,0
   
   call write_octet
   
   dec de                      ; remove last '.'

   ; de = char *buffer_end
   ; stack = buffer_digits, width, precision
   
   pop bc                      ; junk precision
   pop bc                      ; bc = width
   pop hl                      ; hl = buffer_digits
   
   ex de,hl
   sbc hl,de                   ; hl = num_chars
   
   ; hl = num_chars in buffer
   ; de = buffer_digits
   ; bc = width
   
   ld a,l
   ld l,c
   ld c,a
   
   ld a,h
   ld h,b                      ; hl = width
   ld b,a                      ; bc = num_chars
   
   scf
   sbc hl,bc                   ; hl = required padding
   
   ex de,hl
   jr c, output_buffer         ; if width exceeded
   ex de,hl
   
   inc hl
   
   ; hl = required padding
   ; bc = num_chars
   ; de = buffer_digits
   
   bit 2,(ix+5)
   jr nz, left_justify

right_justify:

   push bc
   push de
   
   ld c,l
   ld b,h
   call width_padding
   
   pop hl                      ; hl = buffer_digits
   pop bc                      ; bc = num_chars
   
   ret c                       ; if stream error
   
output_buffer:

   ; hl = buffer
   ; bc = length > 0
   
   ld a,STDIO_MSG_WRIT
   jp __stdio_send_output

left_justify:

   ex hl,de
   push de                     ; save required padding
   
   call output_buffer
   
   pop bc                      ; bc = required padding
   ret c                       ; if stream error

width_padding:

   ; bc = required padding > 0
   
   ld e,' '
   
   ld a,STDIO_MSG_PUTC
   jp __stdio_send_output

write_octet:

   or a
   call l_utoa
   
   ld a,'.'

   ld (de),a
   inc de
   
   ret
