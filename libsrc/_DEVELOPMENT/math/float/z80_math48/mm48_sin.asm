
SECTION code_fp_math48

PUBLIC mm48_sin
PUBLIC mm48__sinc

EXTERN mm48_acpi, mm48_cmp, mm48_equal, mm48__comser
EXTERN mm48_fpadd, mm48__add10, mm48_fpsub, mm48_fpmul, mm48_mod

mm48_sin:

;     Sine
;     ----
;
;     NAME:      SIN
;     FUNCTION:  AC=SIN(AC). AC is set equal to sine of AC. If the
;                absolute value of AC is larger than 2*PI then AC is
;                set equal to AC MOD 2*PI before calculating the sine.
;     OFFSET:    21H
;     STACK:     10 bytes.

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

   exx                         ;Gem AC'
   push bc
   push de
   push hl

mm48__sinc:

   call mm48_acpi              ;AC'=2PI
   inc l
   exx

   ld a,l                      ;Hvis tallet er mindre
   cp $80 - 20                 ;end 1E-7 saa returner
   jr c, mm48__sin7

   push bc                     ;Er ABS(AC)>2PI
   res 7,b
   call mm48_cmp
   pop bc
   call nc, mm48_mod           ;Ja => AC=AC MOD 2PI

mm48__sin1a:

   bit 7,b                     ;Hvis AC<0 saa laeg
   jr z, mm48__sin2            ;2PI til AC
   call mm48_fpadd

mm48__sin2:

   exx                         ;AC'=PI
   dec l
   exx
   call mm48_cmp               ;Er AC>PI?
   push af                     ;Gem flag som fortegn
   jr c, mm48__sin3            ;Nej => SIN3
   call mm48_fpsub             ;AC=AC-PI

mm48__sin3:

   exx                         ;AC'=PI/2
   dec l
   exx
   call mm48_cmp               ;Er AC>PI/2?
   jr c, mm48__sin4            ;Nej => SIN4
   exx                         ;AC=PI-AC
   inc l
   call mm48_fpsub

mm48__sin4:

   ld a,l                      ;Hvis tallet er mindre
   cp $80 - 20                 ;end 1E-7 saa returner
   jr c, mm48__sin7a

   exx                         ;AC=AC/3
   ld bc,$2AAA
   ld de,$AAAA
   ld hl,$AA7F
   call mm48_fpmul

   push ix
   ld ix,sink-6
   ld a,5
   call mm48__comser
   pop ix

   call mm48_equal             ;Gem i AC'
   call mm48_fpmul             ;Udregn SIN(X)^3
   call mm48_fpmul
   push bc                     ;Gem paa stakken
   push de
   push hl
   exx
   call mm48_equal             ;Udregn .75*SIN(X)
   dec l
   dec l
   exx
   dec l
   call mm48_fpadd
   exx                         ;Hent SIN(X)^3
   pop hl
   pop de
   pop bc
   exx
   call mm48_fpsub             ;Traek det fra
   inc l                       ;Gang med 4
   inc l

mm48__sin7a:

   pop af                      ;Indsaet fortegn
   inc l
   dec l
   jr z, mm48__sin7
   jr c, mm48__sin7
   ld a,b
   xor $80
   ld b,a

mm48__sin7:

   or a
   jp mm48__add10              ;Hent AC'

;Konstanter for udregning af SINUS.

sink:

   defw $DC00, $0000, $0087    ;K1
   defw $7780, $0000, $008D    ;K2
   defw $A26C, $0000, $0093    ;K3
   defw $4B07, $0000, $0097    ;K4
   defw $9845, $4000, $009A    ;K5
