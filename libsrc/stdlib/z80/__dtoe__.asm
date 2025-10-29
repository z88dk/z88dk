
SECTION code_clib
SECTION code_stdlib

PUBLIC __dtoe__, __dtoe_join

EXTERN __dtoa_preamble, asm_fpclassify, __dtoa_special_form, __dtoa_base10, __dtoa_adjust_prec
EXTERN __dtoa_digits, __dtoa_round, __dtoa_remove_zeroes, __dtoa_postamble, __dtoa_exp_digit

; math library supplies asm_fpclassify, __dtoa_base10, __dtoa_digits, __dtoa_sgnabs

__dtoe__:

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

   or a
   jr z, normal_form           ; if not inf, nan or zero

   call __dtoa_special_form

   jr nc, prune                ; if zero
   ret                         ; return with carry set if inf or nan
   
normal_form:

   ld (hl),e                   ; save precision
   push hl                     ; save buffer *

   ; EXX    = float x
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

   call __dtoa_adjust_prec     ; if precision == 255, set to max sig digits - 1
   jr nz, __dtoe_join
   dec e

__dtoe_join:

   ; EXX   = float in form b(*10^e), 1 <= b < 10 mantissa only
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

   ld b,1
   call __dtoa_digits          ; single digit left of decimal
   
   ld (hl),'.'
   inc hl
   
   ld b,e
   inc b
   
   call __dtoa_digits          ; generate precision + 1 digits
   jr c, round                 ; if all precision digits generated

   dec b
   ld (ix-3),b                 ; add trailing zeroes
   
   jr prune

round:
   
   call __dtoa_round
   
   ld a,(ix-1)
   cp '0'
   jr z, prune                 ; if round did not affect carry digit
   
   ld a,(ix+0)                 ; move decimal point left
   ld (ix+1),a
   ld (ix+0),'.'
   
   inc d
   dec hl                      ; remove extra precision digit

prune:

   call __dtoa_remove_zeroes   ; remove trailing zeroes
   
   ;  D    = base 10 exponent e
   ; HL    = buffer_dst *
   ; IX    = buffer *
   ; (IX-6) = flags, bit 7 = 'N', bit 4 = '#', bit 1 = %g, bit 0 = precision==0
   ; (IX-5) = iz (number of zeroes to insert before .)
   ; (IX-4) = fz (number of zeroes to insert after .)
   ; (IX-3) = tz (number of zeroes to append)
   ; (IX-2) = ignore
   ; (IX-1) = '0' marks start of buffer

   ld (hl),'E'
   inc hl
   ld (hl),'+'
   
   ld a,d                      ; a = exponent
   or a
   jp p, exponent_plus
   
   ld (hl),'-'
   neg

exponent_plus:

   inc hl                      ; hl = buffer_dst *
   
   cp 100
   jr c, skip_100
   
   sub 100
   
   ld (hl),'1'
   inc hl

skip_100:

   ld de,$0a00 + '0' - 1
   call __dtoa_exp_digit       ; 10s
   
   add a,'0'                   ; 1s

   ld (hl),a
   inc hl

   ; HL    = buffer_dst *
   ; IX    = buffer *
   ; (IX-6) = flags, bit 7 = 'N', bit 4 = '#', bit 1 = %g, bit 0 = precision==0
   ; (IX-5) = iz (number of zeroes to insert before .)
   ; (IX-4) = fz (number of zeroes to insert after .)
   ; (IX-3) = tz (number of zeroes to append)
   ; (IX-2) = ignore
   ; (IX-1) = '0' marks start of buffer

   jp __dtoa_postamble         ; return buffer pointer and length
