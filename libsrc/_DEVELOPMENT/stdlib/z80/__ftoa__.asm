
SECTION code_stdlib

PUBLIC __ftoa__, __ftoa_join, __ftoa_prune

EXTERN __ftoa_preamble, asm_fpclassify, __ftoa_special_form, __ftoa_base10
EXTERN __ftoa_digits, __ftoa_round, __ftoa_remove_zeroes, __ftoa_postamble

; math library supplies asm_fpclassify, __ftoa_base10, __ftoa_digits, __ftoa_sgnabs

__ftoa__:

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

   or a
   jr z, normal_form           ; if not inf, nan, zero
   
   call __ftoa_special_form

   jr nc, __ftoa_prune         ; if zero
   ret                         ; return with carry set if inf, nan

normal_form:
   
   ld (hl),e                   ; save precision
   push hl                     ; save buffer *

   ; EXX    = float x
   ; IX     = buffer *
   ; STACK  = buffer *
   ; (IX-5) = flags, bit 7 = 'N', bit 4 = '#', bit 0 = precision==0
   ; (IX-4) = tz (number of zeroes to append)
   ; (IX-3) = fz (number of zeroes to insert after .)
   ; (IX-2) = iz (number of zeroes to insert before .)
   ; (IX-1) = '0' marks start of buffer
   
   call __ftoa_base10          ; supplied by math library

   pop hl                      ; hl = buffer *
   ld e,(hl)                   ; e = precision

__ftoa_join:

   ; EXX   = float in form b(*10^e), 1 <= b < 10 mantissa only
   ;  C    = remaining significant digits
   ;  D    = base 10 exponent e
   ;  E    = remaining precision
   ; HL    = buffer_dst *
   ; IX    = buffer *
   ; (IX-5) = flags, bit 4 = '#', bit 0 = precision==0
   ; (IX-4) = tz (number of zeroes to append)
   ; (IX-3) = fz (number of zeroes to insert after .)
   ; (IX-2) = iz (number of zeroes to insert before .)
   ; (IX-1) = '0' marks start of buffer

   ld a,d
   or a
   jp m, fraction_only         ; if exponent < 0
   
integer_digits:

   ; d.

   inc a
   ld b,a                      ; b = number of integer digits
   
   call __ftoa_digits          ; provided by math library
   jr c, fraction_begin        ; if form ddd.ddd
   
   ; ddd000.
   
   ld (hl),'0'
   inc hl
   
   dec b
   ld (ix-2),b                 ; number of zeroes to insert before .

fraction_begin:

   ld (hl),'.'
   inc hl
   
fraction_digits:

   ; EXX    = mantissa bits, most sig four bits contain decimal digit
   ;  C     = remaining significant digits
   ;  D     = exponent e
   ;  E     = remaining precision
   ; HL     = buffer_dst *
   ; IX     = buffer *
   ; (IX-5) = flags, bit 4 = '#', bit 0 = precision==0
   ; (IX-4) = tz (number of zeroes to append)
   ; (IX-3) = fz (number of zeroes to insert after .)
   ; (IX-2) = iz (number of zeroes to insert before .)
   ; (IX-1) = '0' marks start of buffer

   ld b,e                      
   inc b                       ; generate precision + 1 digits
   
   call __ftoa_digits          ; provided by math library
   jr c, round                 ; if all precision digits generated
   
   dec b
   ld (ix-4),b                 ; add trailing zeroes

   jr __ftoa_prune

round:

   call __ftoa_round

__ftoa_prune:

   call __ftoa_remove_zeroes
   jp __ftoa_postamble

fraction_only:

   ; 0.

   ; EXX    = mantissa bits, most sig four bits contain decimal digit
   ;  C     = remaining significant digits
   ;  D=A   = exponent e < 0
   ;  E     = precision
   ; HL     = buffer_dst *
   ; IX     = buffer *
   ; (IX-5) = flags, bit 4 = '#', bit 0 = precision==0
   ; (IX-4) = tz (number of zeroes to append)
   ; (IX-3) = fz (number of zeroes to insert after .)
   ; (IX-2) = iz (number of zeroes to insert before .)
   ; (IX-1) = '0' marks start of buffer

   ld (hl),'0'
   inc hl
   ld (hl),'.'
   inc hl
   
   neg
   dec a
   jr z, fraction_digits       ; if form 0.ddd

   dec a
   cp e
   jr nc, precision_less       ; if precision < number of leading zeroes
   
   ld (hl),'0'
   inc hl

   ld (ix-3),a                 ; number of zeroes to insert after .

   sub e
   cpl
   ld e,a                      ; e = remaining precision digits

   jr fraction_digits

precision_less:

   ; fraction part all zeroes
   
   ld (ix-3),e                 ; number of zeroes to insert after .
   jr __ftoa_prune
