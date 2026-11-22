
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_printf_ii

EXTERN __stdio_nextarg_de, __stdio_nextarg_hl, l_utoa
EXTERN __stdio_send_output_buffer, __stdio_printf_padding_width_hl
EXTERN __stdio_printf_padding_width_bc

__stdio_printf_ii:

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

;******************************
IF __SDCC | __SDCC_IX | __SDCC_IY
;******************************

   push de                     ; save LSW of long

;******************************
ELSE
;******************************

   ex de,hl                    ; hl = MSW
   push de                     ; save LSW of long

;******************************
ENDIF
;******************************

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
   ex de,hl

   ; hl = char *buffer_end
   ; stack = buffer_digits, width, precision
   ; carry reset

   pop bc                      ; junk precision
   pop de                      ; de = width
   pop bc                      ; bc = buffer_digits
   
   sbc hl,bc                   ; hl = num_chars = buffer_end - buffer_digits
   ex de,hl

   ; de = num_chars in buffer
   ; bc = buffer_digits
   ; hl = width
   ; carry reset
   
   sbc hl,de                   ; hl = width - num_chars = padding required
   jr nc, padding_required
   
   ld hl,0

padding_required:

   ; hl = required padding
   ; de = num_chars
   ; bc = buffer_digits

   bit 2,(ix+5)
   jr nz, left_justify

right_justify:

   push bc
   push de

   call __stdio_printf_padding_width_hl
   
   pop bc                      ; bc = num_chars
   pop hl                      ; hl = buffer_digits

   jp nc, __stdio_send_output_buffer  ; if no stream error
   
   ret

left_justify:

   push hl                     ; save required padding
   
   ld l,c
   ld h,b                      ; hl = buffer_digits
   
   ld c,e
   ld b,d                      ; bc = num_chars
   
   call __stdio_send_output_buffer
   
   pop bc                      ; bc = required padding
   
   jp nc, __stdio_printf_padding_width_bc  ; if no stream error
   
   ret

write_octet:
   
   or a
   call l_utoa

   ld a,'.'
   ld (de),a
   inc de

   ret
