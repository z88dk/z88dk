
SECTION code_fp_math48

PUBLIC mm48_exp

EXTERN mm48__acln2, mm48__calcs, mm48__add10, mm48__ac1
EXTERN mm48_fpdiv, mm48_equal, mm48_frac, mm48_fix

mm48_exp:

;     Exponentiation
;     --------------
;
;     NAME:      EXP
;     FUNCTION:  AC=EXP(AC). AC is set equal to e raised to the
;                exponent given in AC, where e is the base number
;                for the natural logarithm.
;     OFFSET:    1BH
;     OUTPUT:    CF=0: OK.
;                CF=1: Overflow.
;     STACK:     40 bytes.

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

   exx                         ;Gem AC'
   push bc
   push de
   push hl
   call mm48__acln2            ;AC'=LN(2)
   exx

   or a                        ;Gem fortegn
   bit 7,b
   push af
   res 7,b                     ;Goer positivt

   call mm48_fpdiv             ;Udregn Y
   ld a,l                      ;Er Y>128?
   cp $80 + 8
   jr nc, mm48__exp4           ;Ja => EXP4

   call mm48_equal             ;AC'=Y
   call mm48_frac              ;Udregn Z=FRAC(Y)
   exx                         ;Udregn INT(Y)
   call mm48_fix
   ld a,l
   push af                     ;Gem INT(Y)
   exx

mm48__exp1:

   push ix                     ;Udregn 2^Z
   ld ix,expk - 6
   ld a,7
   call mm48__calcs
   pop ix

mm48__exp3:

   pop af                      ;Hent 2^INT(Y)
   add a,l                     ;Udregn 2^Z*2^INT(Y)
   ld l,a
   jr nc, mm48__exp6           ;Ikke overflow => EXP6

mm48__exp4:

   pop af                      ;Juster stakken
   scf                         ;Indiker overflow

mm48__exp5:

   jp mm48__add10              ;Hent AC'

mm48_exp6:

   pop af                      ;Hent fortegn
   jr z, mm48__exp5            ;Positivt => EXP5
   exx                         ;Tag den reciprokke
   call mm48__ac1
   call mm48_fpdiv
   jr mm48__exp5

;Konstanter for udregning af EXP.

expk:

   defw $5356, $1A0E, $DE83  ;K1
   defw $781B, $C3FF, $FB86  ;K2
   defw $5E01, $5318, $F189  ;K3
   defw $2039, $1142, $418C  ;K4
   defw $2D5C, $5CF6, $DF8E  ;K5
   defw $7A1B, $5EDB, $CD8F  ;K6
   defw $3469, $FC07, $E590  ;K7
