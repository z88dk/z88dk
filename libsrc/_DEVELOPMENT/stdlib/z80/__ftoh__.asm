
SECTION code_stdlib

PUBLIC __ftoh__

EXTERN __ftoa_preamble, asm_fpclassify, __ftoa_special_form, __ftoa_base16, asm_tolower
EXTERN __ftoa_remove_zeroes, __ftoa_exp_digit, __ftoa_postamble, l_hex_nibble_hi, l_hex_nibble_lo

; math library supplies asm_fpclassify, __ftoa_sgnabs, __ftoa_base16

__ftoh__:

   ; enter :  c = flags (bit 4=#, bits 7 and 0 will be modified)
   ;         de = precision (clipped at 255)
   ;         hl = buffer *
   ;         exx set contains float
   ;
   ; exit  : if carry reset
   ;
   ;            bc = buffer length
   ;            de = buffer *
   ;           (IX-5) = flags, bit 7='N', bit 4='#', bit 0=(precision==0), others unaffected
   ;           (IX-4) = tz (number of zeroes to append)
   ;           (IX-3) = fz (number of zeroes to insert after .)
   ;           (IX-2) = iz (number of zeroes to insert before .)
   ;           (IX-1) = ignore
   ;
   ;         if carry set, special form just output buffer with sign
   ;
   ; used  : af, bc, de, hl, ix, af', bc', de', hl'

   call __ftoa_preamble

   ; EXX    = float x
   ;  E     = precision
   ; HL     = buffer_dst *
   ; IX     = buffer *
   ; (IX-5) = flags, bit 7 = 'N', bit 4 = '#', bit 0 = precision==0
   ; (IX-4) = tz (number of zeroes to append)
   ; (IX-3) = fz (number of zeroes to insert after .)
   ; (IX-2) = iz (number of zeroes to insert before .)
   ; (IX-1) = '0' marks start of buffer

   call asm_fpclassify         ; supplied by math library

   cp 2
   jp nc, __ftoa_special_form  ; if inf or nan

   ex af,af'
   
   call __ftoa_base16          ; supplied by math library
   
   ld a,e
   inc a
   jr nz, p1

   ld e,c                      ; if precision == 255, set to max sig digits - 1
   dec e

p1:

   ex af,af'

   ;  A     = fpclassify
   ;  C     = max number of significant hex digits
   ;  D     = base 2 exponent
   ;  E     = precision
   ; HL     = buffer_dst *
   ; IX     = buffer *
   ; HL'    = mantissa *
   ; DE'    = stack adjust
   ; stack  = mantissa
   ;
   ; (IX-5) = flags, bit 7 = 'N', bit 4 = '#', bit 0 = precision==0
   ; (IX-4) = tz (number of zeroes to append)
   ; (IX-3) = fz (number of zeroes to insert after .)
   ; (IX-2) = iz (number of zeroes to insert before .)
   ; (IX-1) = '0' marks start of buffer

   ld (hl),'0'
   inc hl
   ld (hl),'x'
   inc hl
   
   or a
   jr z, normal_form           ; if not zero

   call __ftoa_special_form    ; write zero string
   
   ld d,4                      ; to make exponent print as zero
   jr prune_zeroes

normal_form:

   inc hl                      ; gap at (ix+2) "0x-"

   ;  C     = max number of significant hex digits
   ;  D     = base 2 exponent
   ;  E     = precision
   ; HL     = buffer_dst *
   ; IX     = buffer *
   ; HL'    = mantissa *
   ; DE'    = stack adjust
   ; stack  = mantissa
   ;
   ; (IX-5) = flags, bit 7 = 'N', bit 4 = '#', bit 0 = precision==0
   ; (IX-4) = tz (number of zeroes to append)
   ; (IX-3) = fz (number of zeroes to insert after .)
   ; (IX-2) = iz (number of zeroes to insert before .)
   ; (IX-1) = '0' marks start of buffer

   ld b,e                      ; generate precision + 1 digits
   inc b
   
   call __ftoh_digits
   jr c, decimal_point         ; if all precision digits generated
   
   dec b
   ld (ix-4),b                 ; add trailing zeroes
   
decimal_point:

   ld a,(ix+3)                 ; 1s digit
   ld (ix+2),a                 ; move left
   ld (ix+3),'.'               ; place decimal

prune_zeroes:

   call __ftoa_remove_zeroes   ; remove trailing zeroes

   ld (hl),'P'                 ; exponent separator
   inc hl
   ld (hl),'+'

   ld a,d                      ; a = exponent
   cp 4
   jp p, exponent_plus

exponent_minus:

   ld (hl),'-'

   sub 4
   neg
   add a,4

exponent_plus:

   sub 4
   inc hl

   cp 100
   jr nc, e_100
   
   cp 10
   jr nc, e_10

   jr e_1

e_100:

   ld de,$6400 + '0' - 1
   call __ftoa_exp_digit       ; 100s

e_10:

   ld de,$0a00 + '0' - 1
   call __ftoa_exp_digit       ; 10s

e_1:

   add a,'0'
   
   ld (hl),a
   inc hl

   ; HL    = buffer_dst *
   ; IX    = buffer *
   ; DE'    = stack adjust
   ; stack  = mantissa
   ;
   ; (IX-5) = flags, bit 4 = '#', bit 0 = precision==0
   ; (IX-4) = tz (number of zeroes to append)
   ; (IX-3) = fz = 0
   ; (IX-2) = iz = 0
   ; (IX-1) = '0' marks start of buffer

   exx
   
   ex de,hl
   
   add hl,sp
   ld sp,hl
   
   exx

   jp __ftoa_postamble         ; return buffer pointer and length




__ftoh_digits:

   ;  B = number of digits to generate
   ;  C = number of significant hex digits
   ; HL = buffer *
   ; HL'= mantissa *

   ld a,c
   or a

top_nibble:

   ret z
   
   exx
   ld a,(hl)
   exx
   
   call l_hex_nibble_hi
   call asm_tolower
   
   ld (hl),a
   inc hl
   
   dec c
   djnz lower_nibble

   scf                         ; indicate all chars output
   ret

lower_nibble:

   ret z
   
   exx
   ld a,(hl)
   dec hl
   exx
   
   call l_hex_nibble_lo
   call asm_tolower
   
   ld (hl),a
   inc hl
   
   dec c
   djnz top_nibble

   scf                         ; indicate all chars output
   ret
