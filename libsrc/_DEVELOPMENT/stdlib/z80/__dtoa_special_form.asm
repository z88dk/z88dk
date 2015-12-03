
SECTION code_clib
SECTION code_stdlib

PUBLIC __dtoa_special_form

EXTERN asm_strcpy, __dtoa_nan_s, __dtoa_inf_s

__dtoa_special_form:

   ;  A     = fpclassify = 1 if zero, 2 if nan, 3 if inf
   ;  E     = precision
   ; HL     = buffer_dst *
   ; IX     = buffer *
   ; carry reset
   ;
   ; (IX-6) = flags, bit 7 = 'N', bit 4 = '#', bit 0 = precision==0
   ; (IX-5) = iz (number of zeroes to insert before .)
   ; (IX-4) = fz (number of zeroes to insert after .)
   ; (IX-3) = tz (number of zeroes to append)
   ; (IX-2) = ignore
   ; (IX-1) = '0' marks start of buffer

   dec a
   jr z, zero
   
   ld de,__dtoa_nan_s
   
   dec a
   jr z, string
   
   ld de,__dtoa_inf_s

string:

   ex de,hl
   call asm_strcpy
   ex de,hl
   
   scf
   ret                         ; return with carry set to indicate string

zero:

   ld (hl),'0'
   inc hl
   ld (hl),'.'
   inc hl
   
   ld d,0                      ; exponent = 0
   ld (ix-3),e                 ; number of trailing zeroes = precision

   ret                         ; return with carry reset to indicate zero
