
SECTION code_clib
SECTION code_fp_math48

PUBLIC mm48_sqr

EXTERN am48_derror_edom_zc
EXTERN mm48_equal, mm48_fpdiv, mm48_fpadd, mm48_fpsub, mm48__add10

mm48_sqr:

   ; square root
   ; AC' = SQR(AC')
   ;
   ; enter : AC'(BCDEHL') = float x
   ;
   ; exit  : success
   ;
   ;            AC' = SQR(x)
   ;            carry reset
   ;
   ;         fail if domain error
   ;
   ;            AC' = 0
   ;            carry set
   ;
   ; uses  : af, af', bc', de', hl'

;Kvadratroden beregnes med Newton-Raphson
;iterationsmetoden. Et gaet udregnes ud fra
;det foregaaende gaet efter formelen:
;I(n+1)=(X/I(n)+I(n))/2.
;Som foerste gaet halveres X's exponent.
;Der fortsaettes indtil ABS(I(n+1)-I(n)) er
;mindre end den halve exponent af X minus 20.

   exx
   
   ; AC = x
   
   ld a,b
   inc l
   dec l
   
   exx
   
   ret z                       ; if x == 0
   
   or a
   jp m, am48_derror_edom_zc   ; if x < 0

   push bc                     ; save AC
   push de
   push hl

   exx
   
   call mm48_equal

   ld a,l                      ;Foerste iteration:
   add a,$80                   ;halver exponenten
   sra a
   add a,$80
   ld l,a                      ;Sammenligningsvaerdi
   
   sub 20                      ;er den halve exponent
   push af                     ;Gem s.vaerdi

   exx

mm48__sqr1:

   ; AC = x
   ; AC'= y
   
   push bc                     ;Gem tallet
   push de                     ;(push x)
   push hl

   exx
   
   ; AC = y
   ; AC'= x
   
   call mm48_fpdiv             ;Divider med og adder
   call mm48_fpadd             ;forrige gaet

   exx
   
   ; AC = x
   ; AC'= y
   
   dec l                       ;Halver
   call mm48_fpsub
   
   exx
   
   ld a,l
   
   ; AC'= x
   
   pop hl                      ;Hent tallet
   pop de                      ;(pop x)
   pop bc
   
   ex (sp),hl                  ;Hent s.vaerdi ind i H
   cp h
   ex (sp),hl                  ;Fortsaet indtil forsk.
   jr nc, mm48__sqr1           ;er lille nok

   ; AC'= result
   
   pop af
   
   or a
   jp mm48__add10 + 1
