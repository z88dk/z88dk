
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_printf_number_tail
PUBLIC __stdio_printf_number_tail_zero

EXTERN __stdio_printf_sign, asm__memlwr, l_maxu_bc_hl, l_addu_hl_de
EXTERN __stdio_send_output_buffer, __stdio_printf_padding_width_hl, __stdio_printf_padding_precision_bc
EXTERN __stdio_printf_padding_precision_hl, __stdio_printf_padding_width_bc

__stdio_printf_number_tail_zero:

   ; ix = FILE *
   ; hl = 0
   ; stack = buffer_digits, width, precision
   ; carry reset
   
   ld c,l
   ld b,h                      ; bc = num_sz = 0

   pop de                      ; de = internal_spacing = precision
   
   pop hl                      ; hl = width
   sbc hl,de                   ; hl = external_spacing = width - precision
   
   jr nc, number_zero
   
   ld hl,0                     ; width field exceeded, external_spacing = 0
   jr number_zero

__stdio_printf_number_tail:

   or a
   sbc hl,de
   ld c,l
   ld b,h                      ; bc = num_sz = number of digits written to ascii buffer

   ; common tail code for outputting number on stream
   ;
   ; enter : ix = FILE *
   ;         bc = num_sz = number of ascii digits generated in buffer
   ;         stack = void *buffer_digits, width, precision
   ;
   ; exit  : carry set if stream error
   ;
   ; NOTE: (buffer_digits - 3) points at buffer space of three free bytes

   ; determine internal spacing to satisfy precision field
 
   pop hl                      ; hl = precision
 
   ld e,l
   ld d,h

   call l_maxu_bc_hl
   ex de,hl                    ; de = max(precision, num_sz)
   
   or a
   sbc hl,bc                   ; hl = precision - num_sz = internal_spacing
   jr nc, internal_required
   
   ld hl,0                     ; precision field exceeded

internal_required:

   ; continue computation of output size (num_chars)

   ; ix = FILE *
   ; hl = internal_spacing
   ; bc = num_sz
   ; de = num_chars = max(precision, num_sz)
   ; stack = buffer_digits, width
   
   ld a,(ix+5)                 ; get conversion flags
   and $e0                     ; are any of negative, '+' or ' ' set ?
   jr z, no_sign               ; if no

   inc de                      ; num_chars++
   
no_sign:

   bit 4,(ix+5)                ; base indicator flag set ?
   jr z, no_base_indicator     ; if no

   inc de                      ; num_chars++
   
   bit 1,(ix+5)                ; is this octal or hex conversion ?
   jr nz, no_base_indicator    ; if octal
   
   inc de                      ; num_chars++

no_base_indicator:

   ; determine external spacing to satisfy width field

   ex (sp),hl
   
   ; ix = FILE *
   ; hl = width
   ; bc = num_sz
   ; de = num_chars
   ; stack = buffer_digits, internal_spacing

   sbc hl,de                   ; hl = width - num_chars
   jr nc, external_required
   
   ld hl,0                     ; width field exceeded

external_required:

   ; deal with '0' flag

   pop de

number_zero:

   ; ix = FILE *
   ; hl = external_spacing
   ; bc = num_sz
   ; de = internal_spacing
   ; stack = buffer_digits
   
   ld a,(ix+5)                 ; get conversion flags
   and $0d                     ; keep '0', '-', precision_specified
   cp $08                      ; is '0' set and '-' reset and 'P' reset ?
   
   jr nz, spacing_ok
   
   ; any external_spacing required becomes internal_spacing
   
   call l_addu_hl_de
   
   ex de,hl                    ; de = internal_spacing = external_spacing + internal_spacing
   ld hl,0                     ; hl = external_spacing = 0

spacing_ok:

   push de
   
   ; ix = FILE *
   ; bc = num_sz = number of ascii digits in buffer
   ; hl = external_spacing
   ; stack = void *buffer_digits, internal_spacing

   bit 2,(ix+5)
   jr nz, left_justify         ; if left justify flag selected
   
right_justify:
   
   push bc                     ; save num_sz
   
   call __stdio_printf_padding_width_hl  ; fill width with spaces
  
   pop bc                      ; bc = num_sz
   pop de                      ; de = internal_spacing
   pop hl                      ; hl = void *buffer_digits

   ret c                       ; if stream error

out_internal:

   ; bc = num_sz
   ; de = internal_spacing
   ; hl = void *buffer_digits

   ld a,b
   or c
   jr z, num_is_zero           ; if number is zero

   dec hl
   dec hl
   dec hl                      ; hl = buffer_digits - 3 = void *buffer
   
   ; output precision field
   ;
   ; bc = num_sz = number of ascii digits in buffer
   ; de = internal_spacing = number of 0s to fulfill precision
   ; hl = void *buffer
   
   push bc                     ; save num_sz
   push de                     ; save internal_spacing
   
   ld e,l
   ld d,h                      ; de = void *buffer
   
   bit 6,(ix+4)
   call nz, __stdio_printf_sign  ; if signed conversion, write possible sign to buffer
   
   bit 4,(ix+5)
   jr z, no_base_indicator_2   ; if base indicator flag is not selected
   
   ; write base indicator
   
   ld (hl),'0'                 ; for both octal or hex base indicator
   
   bit 1,(ix+5)
   jr nz, octal_base           ; if octal prefix

hex_base:

   inc hl
   ld (hl),'x'
   
   bit 7,(ix+4)
   jr z, octal_base            ; if lower case
   
   ld (hl),'X'

octal_base:

   inc hl

no_base_indicator_2:

   ; hl = one char past end of buffer
   ; de = void *buffer
   ; stack = num_sz, internal_spacing
   
   or a
   sbc hl,de
   
   ld c,l
   ld b,h                      ; bc = number of prefix chars

   ex de,hl                    ; hl = void *buffer
   push hl                     ; save buffer
   
   call __stdio_send_output_buffer
   
   pop de                      ; de = void *buffer
   jr c, stream_error

no_prefix_chars:

   ; de = void *buffer
   ; stack = num_sz, internal_spacing
   
   pop bc                      ; bc = internal_spacing
   push de                     ; save buffer
   
   call __stdio_printf_padding_precision_bc  ; output 0s to fulfill precision

stream_error:

   pop hl                      ; hl = buffer
   pop bc                      ; bc = num_sz
   
   ret c                       ; if stream error
   
   inc hl
   inc hl
   inc hl                      ; hl = void *buffer_digits
   
   bit 7,(ix+4)
   jp nz, __stdio_send_output_buffer  ; if upper case

   push bc                     ; save num_sz
   
   call asm__memlwr            ; uncapitalize buffer
   
   pop bc                      ; bc = num_sz
   jp __stdio_send_output_buffer

num_is_zero:

   ; for zero, only the precision filler is output
   
   ; de = internal_spacing = number of 0s to fulfill precision

   ex de,hl
   jp __stdio_printf_padding_precision_hl

left_justify:

   ; ix = FILE *
   ; bc = num_sz = number of ascii digits in buffer
   ; hl = external_spacing
   ; stack = void *buffer_digits, internal_spacing

   pop de                      ; de = internal spacing
   ex (sp),hl                  ; hl = void *buffer_digits
   
   call out_internal           ; output precision field
      
   pop bc                      ; bc = external_spacing
   
   jp nc, __stdio_printf_padding_width_bc  ; if no stream error
   ret
