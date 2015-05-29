
SECTION code_stdlib

PUBLIC __ftoa__

EXTERN l_setmem_hl, asm_fpclassify
EXTERN __ftoa_base10, __ftoa_digits, __ftoa_round, __ftoa_remove_zeroes

; math library supplies asm_fpclassify, __ftoa_base10, __ftoa_digits

__ftoa__:

   ; enter :  c = flags (bit 4 = #) rest cleared
   ;         de = precision (clipped at 255)
   ;         hl = buffer *
   ;         exx set contains *positive* float
   ;
   ; exit  : if carry reset
   ;
   ;                d = base 10 exponent e
   ;                hl = buffer_dst * (address of next char to write)
   ;                ix = buffer * (start of decimal string)
   ;            (IX-5) = flags, bit 4 = '#', bit 0 = precision==0
   ;            (IX-4) = iz (number of zeroes to insert before .)
   ;            (IX-3) = fz (number of zeroes to insert after .)
   ;            (IX-2) = tz (number of zeroes to append)
   ;            (IX-1) = if not '0' must be included in decimal string
   ;
   ;         if carry set, special form
   ;
   ;             a = 1 for zero, 2 for nan, 3 for inf
   ;             all except af untouched
   ;
   ; used  : af, bc, de, hl, ix, af', bc', de', hl'

   call asm_fpclassify         ; supplied by math library

   or a
   scf
   ret nz                      ; inf, nan or zero

   ld a,c
   and $10
   ld c,a                      ; keep # flag
   
   ld a,d
   or a
   jr z, check_prec
   ld e,$ff                    ; max precision is 255

check_prec:

   or e
   jr nz, save_buffer
   inc c                       ; indicate precision == 0

save_buffer:

   ld (hl),c                   ; save flags in buffer
   inc hl
   ld (hl),e                   ; save precision in buffer
   
   push hl                     ; save buffer
   
   ; EXX   = float
   ; STACK = buffer *
   
   call __ftoa_base10          ; supplied by math library

   ;  C    = max number of significant decimal digits
   ;  D    = base 10 exponent e
   ; EXX   = float in form b(*10^e), 1 <= b < 10 mantissa only
   ; STACK = buffer *

   pop hl                      ; hl = buffer *
   
   ld e,(hl)                   ; e = precision

   xor a
   call l_setmem_hl - 6
   
   ld (hl),'0'
   inc hl
   
   push hl
   pop ix
   
   ; EXX   = float in form b(*10^e), 1 <= b < 10 mantissa only
   ;  C    = remaining significant digits
   ;  D    = base 10 exponent e
   ;  E    = remaining precision
   ; HL    = buffer_dst *
   ; IX    = buffer *
   ; (IX-5) = flags, bit 4 = '#', bit 0 = precision==0
   ; (IX-4) = iz (number of zeroes to insert before .)
   ; (IX-3) = fz (number of zeroes to insert after .)
   ; (IX-2) = tz (number of zeroes to append)
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
   ld (ix-4),b                 ; number of zeroes to insert before .

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
   ; (IX-4) = iz (number of zeroes to insert before .)
   ; (IX-3) = fz (number of zeroes to insert after .)
   ; (IX-2) = tz (number of zeroes to append)
   ; (IX-1) = '0' marks start of buffer

   ld b,e                      
   inc b                       ; generate precision + 1 digits
   
   call __ftoa_digits          ; provided by math library
   jp c, __ftoa_round          ; if all precision digits generated
   
   dec b
   ld (ix-2),b                 ; add trailing zeroes
   
   jp __ftoa_remove_zeroes

fraction_only:

   ; 0.

   ; EXX    = mantissa bits, most sig four bits contain decimal digit
   ;  C     = remaining significant digits
   ;  D=A   = exponent e < 0
   ;  E     = precision
   ; HL     = buffer_dst *
   ; IX     = buffer *
   ; (IX-5) = flags, bit 4 = '#', bit 0 = precision==0
   ; (IX-4) = iz (number of zeroes to insert before .)
   ; (IX-3) = fz (number of zeroes to insert after .)
   ; (IX-2) = tz (number of zeroes to append)
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
   jp __ftoa_remove_zeroes
