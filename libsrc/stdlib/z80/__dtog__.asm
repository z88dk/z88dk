
SECTION code_clib
SECTION code_stdlib

PUBLIC __dtog__

EXTERN __dtoa_preamble, asm_fpclassify, __dtoa_special_form, __dtoa_prune
EXTERN __dtoa_base10, __dtoa_join, __dtoe_join, __dtoa_adjust_prec

; math library supplies asm_fpclassify, __dtoa_base10, __dtoa_digits, __dtoa_sgnabs

__dtog__:

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

   ld a,d
   or e
   jr nz, preamble

   inc e                       ; if precision == 0, set precision = 1

preamble:

   call __dtoa_preamble
   set 1,(ix-6)                ; indicate %g

   ; EXX    = float x
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

   dec e                       ; precision--
   call __dtoa_special_form
   
   jp nc, __dtoa_prune         ; if zero, prune like ftoa()
   ret                         ; return with carry set if inf or nan
   
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

   ld a,d
   cp -4
   jp m, style_e               ; if exponent < -4
   
   cp e
   jp p, style_e               ; if precision <= exponent

style_f:

   cpl
   add a,e
   ld e,a                      ; precision -= (exponent + 1)
   
   jp __dtoa_join

style_e:

   dec e                       ; precision--
   jp __dtoe_join
