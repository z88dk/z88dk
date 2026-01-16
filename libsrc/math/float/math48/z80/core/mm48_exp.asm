
SECTION code_clib
SECTION code_fp_math48

PUBLIC mm48_exp

EXTERN am48_derror_erange_pinfc
EXTERN mm48__acln2, mm48__calcs, mm48__add10, mm48__ac1
EXTERN mm48_fpdiv, mm48_equal, mm48_frac, am48_dfix16

mm48_exp:

   ; base e exponentiation
   ; AC' = exp(AC')
   ;
   ; enter : AC'(BCDEHL') = float x
   ;
   ; exit  : success
   ;
   ;            AC' = exp(x)
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            AC' = double_max
   ;            carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

;Hvis X<0 saa udregnes EXP(X)=1/EXP(-X).
;EXP(X) beregnes paa flg. maade:
;EXP(X)=2^Y, Y=X/LN(2)
;2^Y=2^INT(Y)*2^Z, Z=FRAC(Y)
;2^Z udregnes af:
;2^Z=(((((((Z+K1)*Z+K2)*Z)2+K3)....)*Z+K7)/K7
;K1=6.6042604723   K2=62.027114868
;K3=444.01034843   K4=2563.5667136
;K5=11095.090786   K6=32013.685271
;K7=46185.984492

   push bc                     ;save AC
   push de
   push hl
   
   call mm48__acln2            ;AC = ln(2)
   exx
   
   ; AC = x
   
   or a
   bit 7,b
   push af                     ;save sign
   res 7,b
   
   exx
   call mm48_fpdiv             ; y = x / ln(2)
   exx
   
   ; AC = y
   
   ld a,l
   cp $80 + 8
   jr nc, mm48__exp4           ; if overflow
   
   call mm48_equal
   call mm48_frac
   
   ; AC = y
   ; AC'= frac(y) = z

   exx
   call am48_dfix16
   
   ld a,l
   push af                     ; save int(y)
   
   ; AC'= z

mm48__exp1:

   push ix                     ;Udregn 2^Z
   ld ix,expk - 6
   
   ld a,7
   call mm48__calcs
   
   pop ix

mm48__exp3:

   ; AC'= 2^z

   pop af                      ;Hent 2^INT(Y)
   exx
   
   ; AC = 2^z
   
   add a,l                     ;Udregn 2^Z*2^INT(Y)
   ld l,a
   jr nc, mm48__exp6           ;Ikke overflow => EXP6

mm48__exp4:

   pop af                      ;Juster stakken
   call am48_derror_erange_pinfc + 1

mm48__exp5:

   jp mm48__add10              ;Hent AC'

mm48__exp6:

   ; AC = result

   pop af                      ;Hent fortegn
   jr z, mm48__exp5            ;Positivt => EXP5
   
   exx                         ;Tag den reciprokke
   call mm48__ac1
   exx
   
   ; AC = result
   ; AC'= 1
   
   call mm48_fpdiv             ;AC'= result
   jp mm48__add10 + 1

;Konstanter for udregning af EXP.

expk:

   defw $5356, $1A0E, $DE83  ;K1
   defw $781B, $C3FF, $FB86  ;K2
   defw $5E01, $5318, $F189  ;K3
   defw $2039, $1142, $418C  ;K4
   defw $2D5C, $5CF6, $DF8E  ;K5
   defw $7A1B, $5EDB, $CD8F  ;K6
   defw $3469, $FC07, $E590  ;K7
