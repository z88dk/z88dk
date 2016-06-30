
SECTION code_clib
SECTION code_stdlib

PUBLIC __dtoh__

EXTERN __dtoa_preamble, asm_fpclassify, __dtoa_special_form, __dtoa_base16, asm_tolower
EXTERN __dtoa_remove_zeroes, __dtoa_exp_digit, __dtoa_postamble, l_hex_nibble_hi, l_hex_nibble_lo
EXTERN __dtoa_adjust_prec

; math library supplies asm_fpclassify, __dtoa_sgnabs, __dtoa_base16

__dtoh__:

   ; enter :  c = flags (bit 4=#, bits 7 and 0 will be modified)
   ;         de = precision (clipped at 255)
   ;         hl = buffer *
   ;         exx set contains float
   ;
   ; exit  : if carry reset
   ;
   ;            bc = buffer length
   ;            de = buffer *
   ;        (IX-6) = flags, bit 7 = 'N', bit 4 = '#', bit 1 = %g, bit 0 = precision==0
   ;        (IX-5) = iz (number of zeroes to insert before .)
   ;        (IX-4) = fz (number of zeroes to insert after .)
   ;        (IX-3) = tz (number of zeroes to append)
   ;        (IX-2) = ignore
   ;        (IX-1) = '0' marks start of buffer
   ;
   ;         if carry set, special form just output buffer with sign
   ;
   ; used  : af, bc, de, hl, ix, af', bc', de', hl'

   call __dtoa_preamble

   ; EXX    = double x
   ;  E     = precision
   ; HL     = buffer_dst *
   ; IX     = buffer *
   ; (IX-6) = flags, bit 7 = 'N', bit 4 = '#', bit 1 = %g, bit 0 = precision==0
   ; (IX-5) = iz (number of zeroes to insert before .)
   ; (IX-4) = fz (number of zeroes to insert after .)
   ; (IX-3) = tz (number of zeroes to append)
   ; (IX-2) = ignore
   ; (IX-1) = '0' marks start of buffer

   call asm_fpclassify         ; supplied by math library

   cp 2
   jp nc, __dtoa_special_form  ; if inf or nan

   ex af,af'
   
   call __dtoa_base16          ; supplied by math library
   
   call __dtoa_adjust_prec     ; if precision == 255, set to max sig digits - 1
   jr nz, p1
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
   ; (IX-6) = flags, bit 7 = 'N', bit 4 = '#', bit 1 = %g, bit 0 = precision==0
   ; (IX-5) = iz (number of zeroes to insert before .)
   ; (IX-4) = fz (number of zeroes to insert after .)
   ; (IX-3) = tz (number of zeroes to append)
   ; (IX-2) = ignore
   ; (IX-1) = '0' marks start of buffer

   ld (hl),'0'
   inc hl
   ld (hl),'x'
   inc hl
   
   or a
   jr z, normal_form           ; if not zero

   call __dtoa_special_form    ; write zero string
   
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
   ; (IX-6) = flags, bit 7 = 'N', bit 4 = '#', bit 1 = %g, bit 0 = precision==0
   ; (IX-5) = iz (number of zeroes to insert before .)
   ; (IX-4) = fz (number of zeroes to insert after .)
   ; (IX-3) = tz (number of zeroes to append)
   ; (IX-2) = ignore
   ; (IX-1) = '0' marks start of buffer

   ld b,e                      ; generate precision + 1 digits
   inc b
   
   call __dtoh_digits
   jr c, decimal_point         ; if all precision digits generated
   
   dec b
   ld (ix-3),b                 ; add trailing zeroes
   
decimal_point:

   ld a,(ix+3)                 ; 1s digit
   ld (ix+2),a                 ; move left
   ld (ix+3),'.'               ; place decimal

prune_zeroes:

   call __dtoa_remove_zeroes   ; remove trailing zeroes

   ld (hl),'P'                 ; exponent separator
   inc hl
   ld (hl),'+'

   ld a,d                      ; a = exponent
   sub 4
   
   jp pe, exponent_minus       ; if negative underflow
   jp p, exponent_plus

exponent_minus:

   ld (hl),'-'
   neg

exponent_plus:

   inc hl

   cp 100
   jr c, skip_100
   
   sub 100
   
   ld (hl),'1'
   inc hl

skip_100:

   cp 10
   jr c, skip_10
   
   ld de,$0a00 + '0' - 1
   call __dtoa_exp_digit       ; 10s

skip_10:   

   add a,'0'
   
   ld (hl),a
   inc hl

   ; HL    = buffer_dst *
   ; IX    = buffer *
   ; DE'    = stack adjust
   ; stack  = mantissa
   ;
   ; (IX-6) = flags, bit 7 = 'N', bit 4 = '#', bit 1 = %g, bit 0 = precision==0
   ; (IX-5) = iz (number of zeroes to insert before .)
   ; (IX-4) = fz (number of zeroes to insert after .)
   ; (IX-3) = tz (number of zeroes to append)
   ; (IX-2) = ignore
   ; (IX-1) = '0' marks start of buffer

   exx
   
   ex de,hl
   
   add hl,sp
   ld sp,hl
   
   exx

   jp __dtoa_postamble         ; return buffer pointer and length




__dtoh_digits:

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
   
   or a
   
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
   
   or a
   
   ld (hl),a
   inc hl
   
   dec c
   djnz top_nibble

   scf                         ; indicate all chars output
   ret
