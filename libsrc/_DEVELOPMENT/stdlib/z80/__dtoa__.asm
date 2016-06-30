
SECTION code_clib
SECTION code_stdlib

PUBLIC __dtoa__, __dtoa_join, __dtoa_prune

EXTERN __dtoa_preamble, asm_fpclassify, __dtoa_special_form, __dtoa_base10
EXTERN __dtoa_digits, __dtoa_round, __dtoa_remove_zeroes, __dtoa_postamble
EXTERN __dtoa_adjust_prec

; math library supplies asm_fpclassify, __dtoa_base10, __dtoa_digits

__dtoa__:

   ; enter :  c = flags (bit 4=#, bits 7 and 0 will be modified)
   ;         de = precision (clipped at 255)
   ;         hl = buffer *
   ;         exx set contains double
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

   or a
   jr z, normal_form           ; if not inf, nan, zero
   
   call __dtoa_special_form

   jr nc, __dtoa_prune         ; if zero
   ret                         ; return with carry set if inf, nan

normal_form:
   
   ld (hl),e                   ; save precision
   push hl                     ; save buffer *

   ; EXX    = double x
   ; IX     = buffer *
   ; STACK  = buffer *
   ; (IX-6) = flags, bit 7 = 'N', bit 4 = '#', bit 1 = %g, bit 0 = precision==0
   ; (IX-5) = iz (number of zeroes to insert before .)
   ; (IX-4) = fz (number of zeroes to insert after .)
   ; (IX-3) = tz (number of zeroes to append)
   ; (IX-2) = ignore
   ; (IX-1) = '0' marks start of buffer
   
   call __dtoa_base10          ; supplied by math library

   pop hl                      ; hl = buffer *
   ld e,(hl)                   ; e = precision

   call __dtoa_adjust_prec
   
__dtoa_join:

   ; EXX   = double in form b(*10^e), 1 <= b < 10 mantissa only
   ;  C    = remaining significant digits
   ;  D    = base 10 exponent e
   ;  E    = remaining precision
   ; HL    = buffer_dst *
   ; IX    = buffer *
   ; (IX-6) = flags, bit 7 = 'N', bit 4 = '#', bit 1 = %g, bit 0 = precision==0
   ; (IX-5) = iz (number of zeroes to insert before .)
   ; (IX-4) = fz (number of zeroes to insert after .)
   ; (IX-3) = tz (number of zeroes to append)
   ; (IX-2) = ignore
   ; (IX-1) = '0' marks start of buffer

   ld a,d
   or a
   jp m, fraction_only         ; if exponent < 0
   
integer_digits:

   ; d.

   inc a
   ld b,a                      ; b = number of integer digits
   
   call __dtoa_digits          ; provided by math library
   jr c, fraction_begin        ; if form ddd.ddd
   
   ; ddd000.
   
   ld (hl),'0'
   inc hl
   
   dec b
   ld (ix-5),b                 ; number of zeroes to insert before .

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
   ; (IX-6) = flags, bit 7 = 'N', bit 4 = '#', bit 1 = %g, bit 0 = precision==0
   ; (IX-5) = iz (number of zeroes to insert before .)
   ; (IX-4) = fz (number of zeroes to insert after .)
   ; (IX-3) = tz (number of zeroes to append)
   ; (IX-2) = ignore
   ; (IX-1) = '0' marks start of buffer

   ld b,e                      
   inc b                       ; generate precision + 1 digits
   
   call __dtoa_digits          ; provided by math library
   jr c, round                 ; if all precision digits generated
   
   dec b
   ld (ix-3),b                 ; add trailing zeroes

   jr __dtoa_prune

round:

   call __dtoa_round

__dtoa_prune:

   call __dtoa_remove_zeroes
   jp __dtoa_postamble

fraction_only:

   ; 0.

   ; EXX    = mantissa bits, most sig four bits contain decimal digit
   ;  C     = remaining significant digits
   ;  D=A   = exponent e < 0
   ;  E     = precision
   ; HL     = buffer_dst *
   ; IX     = buffer *
   ; (IX-6) = flags, bit 7 = 'N', bit 4 = '#', bit 1 = %g, bit 0 = precision==0
   ; (IX-5) = iz (number of zeroes to insert before .)
   ; (IX-4) = fz (number of zeroes to insert after .)
   ; (IX-3) = tz (number of zeroes to append)
   ; (IX-2) = ignore
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

   ld (ix-4),a                 ; number of zeroes to insert after .

   sub e
   cpl
   ld e,a                      ; e = remaining precision digits

   jr fraction_digits

precision_less:

   ; fraction part all zeroes
   
   ld (ix-4),e                 ; number of zeroes to insert after .
   jr __dtoa_prune
