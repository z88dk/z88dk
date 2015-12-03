
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_printf_float_tail

EXTERN __dtoa_count, __dtoa_print, asm__memupr, asm_isdigit
EXTERN __stdio_send_output_buffer, __stdio_printf_padding_precision_hl
EXTERN __stdio_printf_padding_width_bc, __stdio_printf_padding_width_hl

__stdio_printf_float_tail:

   ;     bc = workspace length
   ;     de = workspace *
   ;  stack = buffer_digits, tally, de', bc', BUFFER_65, FILE *, width
   ;
   ; (IX-6) = flags, bit 7 = 'N', bit 4 = '#', bit 0 = precision==0
   ; (IX-5) = iz (number of zeroes to insert before .)
   ; (IX-4) = fz (number of zeroes to insert after .)
   ; (IX-3) = tz (number of zeroes to append)
   ; (IX-2) = ignore
   ; (IX-1) = '0' marks start of buffer
   ;
   ; carry set = special form just output buffer with sign

   ex af,af'                   ; carry'= special form

   ; compute float length
   
   push de                     ; save workspace *

   call __dtoa_count           ; hl = num_chars
   ex de,hl
   
   ; bc = workspace length
   ; de = num_chars
   ; exx = float x
   ; carry'= special form
   ; stack = buffer_digits, tally, de', bc', BUFFER_65, FILE *, width, workspace *

   ld hl,64                    ; max 64 byte buffer size
   
   sbc hl,de

   pop hl                      ; hl = workspace *
   jr nc, padding              ; if float length <= max buffer size
   
   ; float length exceeds maximum
   
   ex af,af'                   ; indicate special form
   
   ld hl,float_max_s
   ld bc,#(float_max_s_end - float_max_s)
   
   ld e,c
   ld d,b

padding:

   ; bc = workspace length
   ; hl = workspace *
   ; de = num_chars
   ; exx = float x
   ; carry'= special form
   ; stack = buffer_digits, tally, de', bc', BUFFER_65, FILE *, width

   ; compute padding
   
   ex (sp),hl                  ; hl = width
   
   or a
   sbc hl,de
   
   jr nc, print_float
   ld hl,0                     ; if field width exceeded

print_float:

   ; bc = workspace length
   ; hl = padding
   ; exx = float x
   ; carry'= special form
   ; stack = buffer_digits, tally, de', bc', BUFFER_65, FILE *, workspace *

   ; write float to temporary buffer
   
   pop de                      ; de = workspace *
   push hl                     ; save padding

   ld hl,4
   add hl,sp                   ; hl = BUFFER_65 *
   
   ex af,af'
   push af                     ; save carry'
   ex af,af'
   
   call __dtoa_print
   ex de,hl
   
   pop af
   ex af,af'                   ; restore carry'
   
   ; hl = BUFFER_65 *
   ; de = output length
   ; carry'= special form
   ; stack = buffer_digits, tally, de', bc', BUFFER_65, FILE *, padding

   exx
   
   ld hl,69
   add hl,sp

   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc' restored
   inc hl

   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de' restored
   inc hl

   ld a,(hl)
   inc hl
   ld h,(hl)                   ; hl'= tally
   ld l,a

   exx
   
   ; capitalize
   
   pop ix
   ex (sp),ix                  ; ix = FILE *
   
   bit 7,(ix+4)
   jr z, justification         ; if no capitalize
   
   ld c,e
   ld b,d                      ; bc = length of buffer
   
   call asm__memupr

justification:

   ld c,e
   ld b,d

   ; bc = output length
   ; hl = BUFFER_65 *
   ; ix = FILE *
   ; hl'= tally
   ; carry'= special form
   ; stack = buffer_digits, tally, de', bc', BUFFER_65, padding
   
   ; determine justification
      
   bit 2,(ix+5)
   jr nz, left_justify         ; if '-' flag
   
   bit 3,(ix+5)
   jr z, right_justify         ; if not '0' flag

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

left_justify_zero_pad:

   ; bc = output length
   ; hl = BUFFER_65 *
   ; ix = FILE *
   ; hl'= tally
   ; carry'= special form
   ; stack = buffer_digits, tally, de', bc', BUFFER_65, padding

   ex af,af'
   jr c, left_justify          ; if special form no zeroes

   ; looking for prefix [+- ][0x]

   ld e,l
   ld d,h                      ; de = BUFFER_65 *

prefix_0:

   ld a,(hl)
   inc hl
   dec bc
   
   cp '0'
   jr z, prefix_x              ; look for following x or X
   
   call asm_isdigit
   jr c, prefix_0              ; if not digit ('+', '-', or ' ')

prefix_1:

   dec hl
   inc bc

prefix_2:

   ; bc = output length
   ; de = BUFFER_65 *
   ; hl = new BUFFER_65 * (post prefix)
   ; ix = FILE *
   ; hl'= tally
   ; stack = buffer_digits, tally, de', bc', BUFFER_65, padding

   push hl                     ; save new BUFFER_65 *

   or a
   sbc hl,de                   ; hl = prefix_len

   jr z, internal_zeroes       ; if prefix length == 0
   
   push bc                     ; save output length
   
   ld c,l
   ld b,h                      ; bc = prefix length
   
   ex de,hl                    ; hl = BUFFER_65 *
   
   call __stdio_send_output_buffer
   
   pop bc                      ; bc = output length

internal_zeroes:

   pop hl                      ; hl = new BUFFER_65 *

   ; bc = output length
   ; hl = new BUFFER_65 *
   ; hl'= output tally
   ; ix = FILE *
   ; stack = buffer_digits, tally, de', bc', BUFFER_65, padding
   
   ex (sp),hl                  ; hl = padding
   push bc                     ; save workspace length
   
   call nc, __stdio_printf_padding_precision_hl
   
   jr right_justify_join       ; print float

prefix_x:

   ld a,(hl)
   inc hl
   dec bc
   
   cp 'x'
   jr z, prefix_2              ; 'x' is part of prefix
   
   cp 'X'
   jr z, prefix_2              ; 'X' is part of prefix
   
   jr prefix_1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

left_justify:

   ; bc = output length
   ; hl = BUFFER_65 *
   ; ix = FILE *
   ; hl'= tally
   ; stack = buffer_digits, tally, de', bc', BUFFER_65, padding

   call __stdio_send_output_buffer
   
   pop bc
   call nc, __stdio_printf_padding_width_bc

   jr stack_restore

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

right_justify:

   ; bc = output length
   ; hl = BUFFER_65 *
   ; ix = FILE *
   ; hl'= tally
   ; stack = buffer_digits, tally, de', bc', BUFFER_65, padding

   ex (sp),hl                  ; hl = padding
   push bc                     ; save output length
   
   call __stdio_printf_padding_width_hl

right_justify_join:

   pop bc                      ; bc = output length
   pop hl                      ; hl = BUFFER_65 *
   
   call nc, __stdio_send_output_buffer
   
stack_restore:

   ; stack = buffer_digits, tally, de', bc', BUFFER_65
   
   ex af,af'

   ld hl,73
   add hl,sp
   ld sp,hl
   
   ex af,af'
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

float_max_s:

   defm "<double>"

float_max_s_end:
