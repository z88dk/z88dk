
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_double64u

EXTERN am48_double32u

am48_double64u:

   ; 64-bit unsigned long to double
   ;
   ; enter : dehl'dehl = 64-bit unsigned long long n
   ;
   ; exit  : AC'= (double)(n)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   exx
   
   ld a,d
   or e
   or h
   or l
   
   exx
   
   jp z, am48_double32u        ; if top 32 bits are zero
   
   ld c,$80 + 64               ; c = exponent
   
coarse_loop:

   ld a,d

   exx
   
   inc d
   dec d
   
   jr nz, fine_adjust
   
   ld d,e
   ld e,h
   ld h,l
   ld l,a
   
   exx
   
   ld d,e
   ld e,h
   ld h,l
   ld l,0
   
   ld a,c
   sub 8
   ld c,a
   
   jr coarse_loop

fine_adjust:

   bit 7,d
   
   exx
   
   jr nz, normalized

fine_loop:

   dec c
   
   add hl,hl
   rl e
   rl d
   
   exx
   
   adc hl,hl
   rl e
   rl d
   
   exx
   
   jp p, fine_loop

normalized:

   ; dehl'dehl = normalized mantissa
   ; c = exponent

   ld b,d
   push bc
   
   exx
   
   ld b,d
   ld c,e
   ex de,hl
   
   pop hl
   res 7,b
   
   exx
   ret
