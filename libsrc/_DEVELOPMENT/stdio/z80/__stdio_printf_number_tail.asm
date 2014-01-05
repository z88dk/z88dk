
XLIB __stdio_printf_number_tail

LIB __stdio_send_output, __stdio_printf_sign, asm__strnupr, l_maxu_bc_hl

__stdio_printf_number_tail:

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

__stdio_printf_number_tail_zero:

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
   
   add hl,de
   
   ex de,hl                    ; de = internal_spacing = external_spacing + internal_spacing
   ld hl,0                     ; hl = external_spacing = 0
   
   jr nc, spacing_ok           ; no overflow
   
   ld de,$ffff                 ; internal_spacing = max $ffff

spacing_ok:

   push de
   
   ; ix = FILE *
   ; bc = num_sz = number of ascii digits in buffer
   ; hl = external_spacing
   ; stack = void *buffer_digits, internal_spacing

   bit 2,(ix+5)
   jr nz, left_justify         ; if left justify flag selected
   
   ; right justify output
   
   push bc                     ; save num_sz
   
   ld e,' '
   
   ld a,h                      ; test if external_spacing == 0
   or l
   call nz, out_repeated_char  ; output spaces to fill field width
   
   pop bc                      ; bc = num_sz
   pop de                      ; de = internal_spacing
   pop hl                      ; hl = void *buffer_digits

   ret c                       ; if stream error

out_internal:

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
   jr z, no_base_indicator     ; if base indicator flag is not selected
   
   ; write base indicator
   
   ld (hl),'0'                 ; for both octal or hex base indicator
   
   bit 1,(ix+5)
   jr nz, octal_base           ; if octal prefix

hex_base:

   ld (hl),'x'
   
   bit 7,(ix+4)
   jr z, octal_base            ; if lower case
   
   ld (hl),'X'

octal_base:

   inc hl

no_base_indicator:

   ; hl = one char past end of buffer
   ; de = void *buffer
   ; stack = num_sz, internal_spacing
   
   or a
   sbc hl,de                   ; hl = number of chars in buffer to output
   jr z, no_prefix_chars

   ; there are prefix chars in the buffer
   
   ld c,l
   ld b,h                      ; bc = number of prefix chars
   ex de,hl                    ; hl = void *buffer
   
   push hl                     ; save buffer
   
   ld a,STDIO_MSG_WRIT
   call __stdio_send_output
   
   pop de                      ; de = void *buffer
   jr c, stream_error

no_prefix_chars:

   ; de = void *buffer
   ; stack = num_sz, internal_spacing
   
   pop hl                      ; hl = internal_spacing
   push de                     ; save buffer
   
   ld e,'0'
   
   ld a,h                      ; test if internal_spacing == 0
   or l
   call nz, out_repeated_char  ; output 0s to fulfill precision

stream_error:

   pop hl                      ; hl = buffer
   pop bc                      ; bc = num_sz
   
   ret c                       ; if stream error
   
   inc hl
   inc hl
   inc hl                      ; hl = void *buffer_digits
   
   ld a,STDIO_MSG_WRIT
   
   bit 7,(ix+4)
   jp z, __stdio_send_output   ; if lower case

   push bc                     ; save num_sz
   
   call asm__strnupr           ; capitalize buffer
   
   pop bc                      ; bc = num_sz
   
   ld a,STDIO_MSG_WRIT
   jp __stdio_send_output

num_is_zero:

   ; for zero only the precision filler is output
   
   ; de = internal_spacing = number of 0s to fulfill precision

   ld a,d
   or e
   ret z                       ; no precision filler
   
   ex de,hl
   ld e,'0'
   
   jr out_repeated_char

left_justify:

   ; ix = FILE *
   ; bc = num_sz = number of ascii digits in buffer
   ; hl = external_spacing
   ; stack = void *buffer_digits, internal_spacing

   pop de                      ; de = internal spacing
   ex (sp),hl                  ; hl = void *buffer_digits
   
   call out_internal           ; output precision field
      
   pop hl                      ; hl = external_spacing
   ret c                       ; if stream error
   
   ld e,' '
   
   ld a,h                      ; test if external_spacing == 0
   or l
   ret z

   ; fall through to output spaces
   
out_repeated_char:

   ; hl = number of chars to output
   ;  e = char to output
   
   ld a,STDIO_MSG_PUTC
   
   ld c,l
   ld b,h                      ; bc = num chars
   
   jp __stdio_send_output
