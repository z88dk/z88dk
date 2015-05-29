
SECTION code_stdlib

PUBLIC __ftoa_special_form

EXTERN asm_strcpy, __ftoa_remove_zeroes

__ftoa_special_form:

   ;  A     = fpclassify = 1 if zero, 2 if nan, 3 if inf
   ;  E     = precision
   ; HL     = buffer_dst *
   ; IX     = buffer *
   ; (IX-5) = flags, bit 7 = 'N', bit 4 = '#', bit 0 = precision==0
   ; (IX-4) = tz (number of zeroes to append)
   ; (IX-3) = fz (number of zeroes to insert after .)
   ; (IX-2) = iz (number of zeroes to insert before .)
   ; (IX-1) = '0' marks start of buffer

   dec a
   jr z, zero
   
   ld de,nan
   
   dec a
   jr z, string
   
   ld de,inf

string:

   ex de,hl
   call asm_strcpy
   ex de,hl
   
   scf
   ret

zero:

   ld (hl),'0'
   inc hl
   ld (hl),'.'
   inc hl
   
   ld d,0                      ; exponent = 0
   ld (ix-4),e                 ; number of trailing zeroes = precision

   jp __ftoa_remove_zeroes

nan:

   defm "nan"
   defb 0

inf:

   defm "inf"
   defb 0
