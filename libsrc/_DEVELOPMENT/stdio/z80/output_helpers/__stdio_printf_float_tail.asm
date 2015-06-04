
SECTION code_stdio

PUBLIC __stdio_printf_float_tail

EXTERN l_inc_sp, __stdio_send_output_chars, __stdio_printf_padding_precision_hl
EXTERN __ftoa_count, __stdio_printf_sign_0, asm__memupr, asm_isdigit
EXTERN __stdio_send_output_buffer, __stdio_printf_padding_precision_bc
EXTERN __stdio_printf_padding_width_bc, __stdio_printf_padding_width_hl

__stdio_printf_float_tail:

   ;     bc = workspace length
   ;     de = workspace *
   ;  stack = buffer *, width, output_tally, FILE *
   ;
   ; (IX-6) = flags, bit 7 = 'N', bit 4 = '#', bit 0 = precision==0
   ; (IX-5) = tz (number of zeroes to append)
   ; (IX-4) = fz (number of zeroes to insert after .)
   ; (IX-3) = iz (number of zeroes to insert before .)
   ; (IX-2) = ignore
   ; (IX-1) = '0' marks start of buffer
   ;
   ; carry set = special form just output buffer with sign

   ex af,af'                   ; carry'= special form

   ; compute float length
   
   push de                     ; save workspace *
   call __ftoa_count           ; hl = num_chars
   
   ex (sp),hl
      
   ; bc = workspace length
   ; hl = workspace *
   ; carry'= special form
   ; stack = buffer *, width, output_tally, FILE *, num_chars
   
   ; place sign into workspace buffer
   
   ld a,(ix-6)
   and $e0
   jr z, sign_done             ; if sign not output
   
   dec hl
   call __stdio_printf_sign_0
   dec hl
   inc bc

sign_done:

   ; bc = workspace length
   ; hl = workspace *
   ; carry'= special form
   ; stack = buffer *, width, output_tally, FILE *, num_chars

   pop de                      ; de = num_chars
   pop ix                      ; ix = FILE *
   
   exx
   pop hl                      ; hl'= output_tally
   exx
   
   ex (sp),hl                  ; hl = width
   
   ; bc = workspace length
   ; de = num_chars
   ; hl = field width
   ; hl'= output_tally
   ; ix = FILE *
   ; carry'= special form
   ; stack = buffer *, workspace *

   ; compute padding

   or a
   sbc hl,de
   jr nc, padding_found
   
   ld hl,0                     ; if field width exceeded

padding_found:

   ; bc = workspace length
   ; hl = padding
   ; hl'= output tally
   ; ix = FILE *
   ; carry'= special form
   ; stack = buffer *, workspace *

   ; capitalize
   
   bit 7,(ix+4)
   jr z, justification         ; if no capitalize

   ex (sp),hl                  ; hl = workspace *
   push bc                     ; save workspace length
   
   call asm__memupr
   
   pop bc
   ex (sp),hl

justification:

   ; bc = workspace length
   ; hl = padding
   ; hl'= output tally
   ; ix = FILE *
   ; carry'= special form
   ; stack = buffer *, workspace *

   pop de
   ex af,af'
   push af
   push de

   ; determine justification
   
   bit 2,(ix+5)
   jr nz, left_justify         ; if '-' flag
   
   bit 3,(ix+5)
   jr z, right_justify         ; if not '0' flag

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

left_justify_zero_pad:

   ; bc = workspace length
   ; de = workspace *
   ; hl = padding
   ; hl'= output tally
   ; ix = FILE *
   ; stack = buffer *, carry', workspace *

   jr c, left_justify          ; if special form no zeroes

   ; looking for prefix [+- ][0x]
   
   ex (sp),hl                  ; hl = workspace *

   ; bc = workspace length
   ; hl = new workspace *
   ; de = workspace *
   ; hl'= output tally
   ; ix = FILE *
   ; stack = buffer *, carry', padding

prefix_0:

   ld a,(hl)
   inc hl
   dec bc
   
   cp '0'
   jr z, prefix_x              ; look for following x or X
   
   call asm_isdigit
   jr c, prefix_0              ; if not digit ('+', '-', or ' ')

prefix_done_0:

   dec hl
   inc bc

prefix_done_1:

   ; bc = workspace length
   ; hl = workspace * + prefix
   ; de = workspace *
   ; hl'= output tally
   ; ix = FILE *
   ; stack = buffer *, carry', padding

   push hl                     ; save new workspace *

   or a
   sbc hl,de                   ; hl = prefix_len

   jr z, internal_zeroes       ; if prefix length == 0
   
   push bc                     ; save workspace length
   
   ld c,l
   ld b,h                      ; bc = prefix length
   
   ex de,hl                    ; hl = workspace *
   
   call __stdio_send_output_buffer
   
   pop bc                      ; bc = workspace length

internal_zeroes:

   pop hl                      ; hl = new workspace *

   ; bc = workspace length
   ; hl = new workspace *
   ; hl'= output tally
   ; ix = FILE *
   ; stack = buffer *, carry', padding
   
   ex (sp),hl                  ; hl = padding
   push bc                     ; save workspace length
   
   call nc, __stdio_printf_padding_precision_hl
   
   jr right_justify_join       ; print float

prefix_x:

   ld a,(hl)
   inc hl
   dec bc
   
   cp 'x'
   jr z, prefix_done_1         ; 'x' is part of prefix
   
   cp 'X'
   jr z, prefix_done_1         ; 'X' is part of prefix
   
   jr prefix_done_0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
left_justify:

   ; bc = workspace length
   ; de = workspace *
   ; hl = padding
   ; hl'= output tally
   ; ix = FILE *
   ; stack = buffer *, carry', workspace *

   pop af
   pop af
   ex (sp),hl
   ex de,hl
      
   ; bc = workspace length
   ; hl = workspace *
   ; de = buffer *
   ; hl'= output tally
   ; ix = FILE *
   ; carry = special form
   ; stack = padding
   
   call print_float
   
   pop bc                      ; bc = padding
   
   call nc, __stdio_printf_padding_width_bc
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

right_justify:

   ; bc = workspace length
   ; de = workspace *
   ; hl = padding
   ; hl'= output tally
   ; ix = FILE *
   ; stack = buffer *, carry', workspace *

   push bc                     ; save workspace length

   call __stdio_printf_padding_width_hl

right_justify_join:

   ; hl'= output tally
   ; ix = FILE *
   ; stack = buffer *, carry', workspace *, workspace length

   pop bc                      ; bc = workspace length
   pop hl                      ; hl = workspace *
   
   jp c, l_inc_sp - 4          ; if stream error

   pop af                      ; carry'
   pop de                      ; de = buffer *
   
   ; fall through to print_float
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print_float:

   ; bc = workspace length
   ; hl = workspace *
   ; de = buffer *
   ; hl'= output tally
   ; carry = special form
   ; ix = FILE *
   ;
   ; (buffer+0) = flags, bit 7 = 'N', bit 4 = '#', bit 0 = precision==0
   ; (buffer+1) = iz (number of zeroes to insert before .)
   ; (buffer+2) = fz (number of zeroes to insert after .)
   ; (buffer+3) = tz (number of zeroes to append)
   ; (buffer+4) = ignore
   ; (buffer+5) = '0' marks start of buffer

   ; follows __ftoa_print from stdlib

   jp c, __stdio_send_output_buffer  ; if special form

   ;;;;; print workspace up to non-digit

   inc de
   push de
   
   ld de,0
   
   push hl

   ; bc = remaining workspace
   ; hl = workspace *
   ; de = output length
   ; stack = buffer+1, output *

integer_part:

   ld a,(hl)
   
   cp '.'
   jr z, iz_zeroes             ; if integer part done
   
   cp 'E'
   jr z, tze_zeroes_0          ; if exponent reached
   
   cp 'P'
   jr z, tze_zeroes_0          ; if exponent reached
   
   inc de                      ; count++
   
   cpi                         ; hl++, bc--
   jp pe, integer_part         ; if workspace not exhausted

iz_zeroes:

   ; bc = remaining workspace
   ; hl = workspace *
   ; de = output length
   ; stack = buffer+1, output *

   ex (sp),hl
   
   call print_workspace
   jp c, l_inc_sp - 4          ; if stream error

   ;;;;; print iz zeroes (zeroes trailing the integer part)

   ; bc = remaining workspace
   ; stack = buffer+1, workspace *

   pop hl
   ex (sp),hl
   
   ; bc = remaining workspace
   ; hl = buffer+1
   ; stack = workspace *
   
   call print_zeroes
   jp c, l_inc_sp - 2          ; if stream error

   ld a,b
   or c
   jp z, l_inc_sp - 2          ; if done

   ;;;;; print decimal point

   ; bc = remaining workspace
   ; hl = buffer+2
   ; stack = workspace *

   push bc
   push hl
   
   ld e,'.'
   ld bc,1
   
   call __stdio_send_output_chars

   pop hl
   pop bc
   
   jp c, l_inc_sp - 2          ; if stream error

   dec bc
   
   ld a,b
   or c
   jp z, l_inc_sp - 2          ; if done

   ;;;;; print fz zeroes

   ; bc = remaining workspace
   ; hl = buffer+2
   ; stack = workspace* - 1

   call print_zeroes
   jp c, l_inc_sp - 2          ; if stream error
   
   ex (sp),hl
   inc hl                      ; hl = workspace *
   push hl

   ;;;;; print workspace up to exponent
   
   ld de,0
   
   ; bc = remaining workspace
   ; hl = workspace *
   ; de = output length
   ; stack = buffer+3, output *

fraction_part:

   ld a,(hl)

   cp 'E'
   jr z, tze_zeroes_1          ; if exponent reached
   
   cp 'P'
   jr z, tze_zeroes_1          ; if exponent reached
   
   inc de                      ; count++
   
   cpi                         ; hl++, bc--
   jp pe, integer_part         ; if workspace not exhausted

   ; hl = workspace *
   ; de = output length
   ; stack = buffer+3, output *

   pop hl
   call print_workspace

   ;;;;; print trailing zeroes

   ; stack = buffer+3

   pop hl                      ; hl = buffer+3

   jp nc, print_zeroes
   ret

   ;;;;; print trailing zeroes (ftoe - exponent present)

tze_zeroes_0:

   ; bc = remaining workspace
   ; hl = workspace *
   ; de = output length
   ; stack = buffer+1, output *

   pop af
   
   ex (sp),hl
   inc hl
   inc hl
   ex (sp),hl
   
   push af

tze_zeroes_1:

   ; bc = remaining workspace
   ; hl = workspace *
   ; de = output length
   ; stack = buffer+3, output *

   ex (sp),hl
   
   call print_workspace
   jp c, l_inc_sp - 4          ; if stream error
   
   ; bc = remaining workspace
   ; stack = buffer+3, workspace *

   pop hl
   ex (sp),hl
   
   ; bc = remaining workspace
   ; hl = buffer+3
   ; stack = workspace *
   
   call print_zeroes
   jp c, l_inc_sp - 2          ; if stream error

   ;;;;; print remaining workspace (ftoe - exponent present)

   pop hl
   jp __stdio_send_output_buffer

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print_workspace:

   ; hl = workspace *
   ; de = workspace length
   ; save bc
   
   push bc
   
   ld c,e
   ld b,d
   
   call __stdio_send_output_buffer
   
   pop bc
   ret

print_zeroes:

   ; hl = num_zeroes *
   ; save bc
   
   push bc
   
   ld c,(hl)
   ld b,0                      ; bc = number of zeroes to print
   
   inc hl
   push hl
   
   call __stdio_printf_padding_precision_bc
   
   pop hl
   pop bc
   
   ret
