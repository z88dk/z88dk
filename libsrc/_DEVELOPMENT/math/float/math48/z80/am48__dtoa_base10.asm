
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48__dtoa_base10

EXTERN am48_dmulpow10, am48_dmul10a, mm48__right

am48__dtoa_base10:

   ; convert double from standard form "a * 2^n"
   ; to a form mulitplied by power of 10 "b * 10^e"
   ; where 1 <= b < 10 with b in double format
   ;
   ; mainly original math48 code
   ;
   ; enter : AC'= double x, x positive
   ;
   ; exit  : AC'= b where 1 <= b < 10 all mantissa bits only
   ;          C = max number of significant decimal digits (11)
   ;          D = base 10 exponent e
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'

   ; x = a * 2^n = b * 10^e
   ; e = n * log(2) = n * 0.301.. = n * 0.01001101...(base 2) = INT((n*77 + 5)/256)

   exx
   ld a,l
   exx

   ;  A = n (binary exponent)
   ; AC'= x

   sub $80                     ; remove bias
   ld l,a
   sbc a,a
   ld h,a                      ; hl = signed n
   
   push hl                     ; save n
   add hl,hl
   add hl,hl
   push hl                     ; save 4*n
   add hl,hl
   ld c,l
   ld b,h                      ; bc = 8*n
   add hl,hl
   add hl,hl
   add hl,hl                   ; hl = 64*n
   add hl,bc
   pop bc
   add hl,bc
   pop bc
   add hl,bc                   ; hl = 77*n
   ld bc,5
   add hl,bc                   ; rounding fudge factor
   
   ld a,h                      ; a = INT((77*n+5)/256)
   cp -39
   jr nz, no_correction
   inc a

no_correction:

   push af                     ; save exponent e
   
   neg
   call nz, am48_dmulpow10     ; x *= 10^-e
   
   pop de                      ; d = exponent e
   
   exx
   
   ; AC = b
   ;  D'= exponent e

   ld a,l
   cp $80+1                    ; remaining fraction part < 1 ?
   jr nc, align_digit          ; if no
      
   exx
   
   ; AC'= b
   ;  D = exponent e

   dec d                       ; e--   
   call am48_dmul10a           ; b *= 10

   exx
   
align_digit:

   ; AC = b, 1 < b < 10
   ;  D'= exponent e
   
   ; there is one decimal digit in four bits of AC
   ; align these bits so they are the first four in register B
   
   set 7,b                     ; restore mantissa bit

   ld a,$80+4
   sub l
   ld l,0
   jr z, rotation_done         ; if exponent is 4

digit_loop:

   call mm48__right            ; shift mantissa bits right
   rr l
   
   dec a
   jr nz, digit_loop

rotation_done:

   exx

   ld c,11                     ; max significant digits
   ret
