
SECTION code_clib
SECTION code_fp_math48

PUBLIC mm48_sin, mm48__sinc

EXTERN mm48__acpi, mm48_cmp, mm48_equal, mm48__comser, mm48__ac1_3
EXTERN mm48_fpadd, mm48__add10, mm48_fpsub, mm48_fpmul, mm48_mod

mm48_sin:

   ; sine
   ; AC' = sin(AC')
   ;
   ; enter : AC'(BCDEHL') = float x
   ;
   ; exit  : AC' = sin(x)
   ;
   ; note  : If the absolute value of AC is larger than 2*PI then AC is
   ;         set equal to AC MOD 2*PI before calculating the sine.
   ;
   ; uses  : af, af', bc', de', hl'

;SIN(X) beregnes paa flg. maade:
;Hvis ABS(X)>2*PI saa X=FRAC(X/(2*PI))*2*PI
;Hvis X<0 saa X=X+2*PI
;Hvis X>PI saa X=X-PI, fortegn -
;Hvis X>PI/2 saa X=PI-X
;Y=X/3, Z=Y^2
;SIN(Y)=Y(((((Z+K1)Z+K2)Z+K3)Z+K4)Z+K5)/K5
;K1=-110      K2=7920       K3=-332640
;K4=6652800   K5=-39916800
;SIN(X)=4(.75*SIN(Y)-SIN(Y)^3)

   push bc                     ;save AC
   push de
   push hl

mm48__sinc:

   call mm48__acpi              ;AC = 2*PI
   inc l
   
   exx

   ; AC = x
   ; AC'= 2*pi

   ld a,l                      ;Hvis tallet er mindre
   cp $80 - 20                 ;end 1E-7 saa returner
   jr c, mm48__sin7

   push bc                     ;Er ABS(AC)>2PI
   res 7,b
   call mm48_cmp
   pop bc
   
   exx
   call nc, mm48_mod           ;Ja => AC=AC MOD 2PI
   exx

mm48__sin1a:

   ; AC = x
   ; AC'= 2*pi

   bit 7,b                     ;Hvis AC<0 saa laeg
   exx
   
   ; AC = 2*pi
   ; AC'= x
   
   jr z, mm48__sin2
   call mm48_fpadd             ;AC' += 2*pi

mm48__sin2:

   ; AC = 2*pi
   ; AC'= x

   dec l                       ;AC = pi
   call mm48_cmp               ;Er AC'>PI?

   push af                     ;Gem flag som fortegn
   jr nc, mm48__sin3           ;Nej => SIN3

   call mm48_fpsub             ;AC' -= pi

mm48__sin3:

   ; AC = pi
   ; AC'= x

   dec l                       ;AC = pi/2

   call mm48_cmp               ;Er AC>PI/2?
   jr nc, mm48__sin4           ;Nej => SIN4

   inc l                       ;AC = pi
   exx
   
   ; AC = x
   ; AC'= pi
   
   call mm48_fpsub             ;AC' = pi - x

mm48__sin4:

   ; AC'= x

   exx

   ld a,l                      ;Hvis tallet er mindre
   cp $80 - 20                 ;end 1E-7 saa returner
   jr c, mm48__sin7a

   exx
   
   call mm48__ac1_3            ;AC = 1/3
   
   ; AC = 1/3
   ; AC'= x
   
   call mm48_fpmul              ;AC' /= 3

   push ix
   
   ld ix,sink-6
   ld a,5
   
   call mm48__comser
   
   pop ix

   exx
   
   ; AC = sin(x)

   call mm48_equal             ;Gem i AC'
   call mm48_fpmul             ;AC'= SIN(X)^3
   call mm48_fpmul
   
   ; AC = sin(x)
   ; AC'= sin(x)^3
   
   exx
   
   push bc                     ;save sin(x)^3
   push de
   push hl
   
   exx
   
   call mm48_equal
   
   ; AC = sin(x)
   ; AC'= sin(x)
   
   dec l
   dec l                       ;AC = 0.25*sin(x)
   
   exx
   
   dec l                       ;AC = 0.5*sin(x)
   call mm48_fpadd             ;AC'= 0.75*sin(x)
   
   pop hl                      ;AC = sin(x)^3
   pop de
   pop bc
   
   call mm48_fpsub             ;AC'= 0.75*sin(x) - sin(x)^3

   exx
   
   ; AC = x
   
   inc l                       ; AC *= 4
   inc l

mm48__sin7a:

   ; AC = x

   pop af                      ;Indsaet fortegn
   
   inc l
   dec l
   
   jr z, mm48__sin7
   jr nc, mm48__sin7
   
   ld a,b
   xor $80
   ld b,a

mm48__sin7:

   ; AC = result

   or a
   jp mm48__add10              ;Hent AC'

;Konstanter for udregning af SINUS.

sink:

   defw $DC00, $0000, $0087    ;K1
   defw $7780, $0000, $008D    ;K2
   defw $A26C, $0000, $0093    ;K3
   defw $4B07, $0000, $0097    ;K4
   defw $9845, $4000, $009A    ;K5
