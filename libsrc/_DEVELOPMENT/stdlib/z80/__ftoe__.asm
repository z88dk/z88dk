
SECTION code_stdlib

PUBLIC __ftoe__

EXTERN __ftoa_preamble, asm_fpclassify, __ftoa_special_form, __ftoa_base10
EXTERN __ftoa_digits, __ftoa_round, __ftoa_remove_zeroes, __ftoa_postamble

; math library supplies asm_fpclassify, __ftoa_base10, __ftoa_digits, __ftoa_sgnabs

__ftoe__:

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
   jr z, normal_form           ; if not inf, nan or zero

   call __ftoa_special_form

   jr nc, prune                ; if zero
   ret                         ; return with carry set if inf or nan
   
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

   ld b,1
   call __ftoa_digits          ; single digit left of decimal
   
   ld (hl),'.'
   inc hl
   
   ld b,e
   inc b
   
   call __ftoa_digits          ; generate precision + 1 digits
   jr c, round                 ; if all precision digits generated

   dec b
   ld (ix-4),b                 ; add trailing zeroes
   
   jr prune

round:
   
   call __ftoa_round
   
   ld a,(ix-1)
   cp '0'
   jr z, prune                 ; if round did not affect carry digit
   
   ld a,(ix+0)                 ; move decimal point left
   ld (ix+1),a
   ld (ix+0),'.'

   dec hl                      ; remove extra precision digit

prune:

   call __ftoa_remove_zeroes   ; remove trailing zeroes
   
   ;  D    = base 10 exponent e
   ; HL    = buffer_dst *
   ; IX    = buffer *
   ; (IX-5) = flags, bit 4 = '#', bit 0 = precision==0
   ; (IX-4) = tz (number of zeroes to append)
   ; (IX-3) = fz (number of zeroes to insert after .)
   ; (IX-2) = iz (number of zeroes to insert before .)
   ; (IX-1) = '0' marks start of buffer

   ld (hl),'e'
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
   
   ld de,$6400 + '0' - 1
   call exponent_digit         ; 100s

skip_100:

   ld de,$0a00 + '0' - 1
   call exponent_digit         ; 10s
   
   add a,'0'                   ; 1s

   ld (hl),a
   inc hl

   ; HL    = buffer_dst *
   ; IX    = buffer *
   ; (IX-5) = flags, bit 4 = '#', bit 0 = precision==0
   ; (IX-4) = tz (number of zeroes to append)
   ; (IX-3) = fz = 0
   ; (IX-2) = iz = 0
   ; (IX-1) = '0' marks start of buffer

   jp __ftoa_postamble         ; return buffer pointer and length

exponent_digit:

   inc e
   sub d

   jr nc, exponent_digit
   
   add a,d
   
   ld (hl),e
   inc hl
   
   ret
