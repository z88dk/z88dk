
SECTION code_clib
SECTION code_fp_math48

PUBLIC mm48_pwr

EXTERN am48_derror_edom_zc, am48_derror_onc, mm48__retzero
EXTERN mm48_ln, mm48_fpmul, mm48_exp, mm48__sleft

mm48_pwr:

   ; power
   ; AC' = AC'^AC = exp(AC*ln(AC'))
   ;
   ; enter : AC'(BCDEHL') = float x
   ;         AC (BCDEHL ) = float y
   ;
   ; exit  : success
   ;
   ;            AC'= x^y
   ;            carry reset
   ;
   ;         fail if domain error
   ;
   ;            AC'= double_max, double_min or zero
   ;            carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

   ; accept negative x if y is an integer
   
   exx
   
   ; x^y
   ; AC = x
   ; AC'= y
      
   ld a,b
   res 7,b                     ; x = abs(x)
   
   inc l
   dec l

   exx
   
   jp z, am48_derror_edom_zc   ; if x == 0
   
   inc l
   dec l
   
   jp z, am48_derror_onc       ; if y == 0
   
   or a
   jp p, positive              ; if x > 0
   
   ; x < 0 requires that y is an integer
    
   ; AC'= abs(x)
   ; AC = y != 0

   ld a,l
   sub $80 + 1
   
   jp c, am48_derror_edom_zc   ; if |y| < 1 (not integer)
   
   inc a                       ; a = num times to shift y left
   
   cp 41
   jr nc, positive             ; if |y| is very large it becomes even integer
   
   push bc
   push de
   push hl                     ; save y
   
   set 7,b

loop:

   call mm48__sleft
   dec a
   jr nz, loop
   
   ex af,af'                   ; carry' set if y is odd
   
   ld a,b
   or c
   or d
   or e
   or h
   
   pop hl
   pop de
   pop bc                      ; restore y
   
   jp nz, am48_derror_edom_zc  ; if y is not an integer
   
   ex af,af'
   jr nc, positive             ; if y is even
   
   call positive
   
   exx
   set 7,b                     ; negate result
   exx
   
   ret

;X^Y beregnes af EXP(Y*LN(X)).

positive:

   ; x^y
   ; AC'= x > 0
   ; AC = y != 0

   call mm48_ln
   call mm48_fpmul
   
   jp nc, mm48_exp

   ; multiply overflowed

   exx

   bit 7,b
   jp nz, mm48__retzero        ; if -inf return zero without error

   exx
   ret
