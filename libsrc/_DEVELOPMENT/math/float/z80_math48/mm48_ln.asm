
SECTION code_fp_math48

PUBLIC mm48_ln

EXTERN mm48__comser, mm48__acln2, mm48_float, mm48__zero, mm48__ac1
EXTERN mm48_fpmul, mm48_fpsub, mm48_fpadd, mm48_fpdiv, mm48__add10

mm48_ln:

;     Natural logaritm
;     ----------------
;
;     NAME:      LN
;     FUNCTION:  AC=LN(AC). AC is set equal to the natural
;                logarithm of AC.
;     OFFSET:    18H
;     OUTPUT:    CF=0: OK.
;                CF=1: AC<=0.
;     STACK:     10 bytes.

;LN(X) beregnes paa flg. maade:
;X=Y*2^N, 1<=Y<2
;Z=Y*SQR(2)/2
;U=(Z-1)/(Z+1), V=U^2
;R=U((((((V+K1)V+K2)V+K3)V+K4)V+K5)V+K6)/K6
;Kn=13/(13-2n)
;LN(X)=2*R+LN(2)/2+N*LN(2)

   inc l                       ;Er AC nul?
   dec l
   scf                         ;Indiker fejl
   ret z                       ;Ja => Returner
   bit 7,b                     ;Negativ?
   ret nz                      ;Ja => Returner

   exx                         ;Gem AC'
   push bc
   push de
   push hl
   ld bc,$3504                 ;AC'=SQR(2)/2
   ld de,$F333
   ld hl,$FB80
   exx

   ld a,l                      ;Udregn N
   ld l,$80 + 1                ;Udregn Y
   sub l
   push af                     ;Gem N

   call mm48_fpmul             ;Udregn Z
   exx                         ;Udregn U
   call mm48__ac1
   exx
   call mm48_fpsub
   push bc
   push de
   push hl
   exx
   inc l
   call mm48_fpadd
   exx
   pop hl
   pop de
   pop bc
   call mm48_fpdiv

   push ix                     ;Udregn LN(Z)
   ld ix,lnk - 6
   ld a,6
   call mm48__comser
   pop ix

   inc l                       ;Laeg LN(2)/2 til
   exx
   call mm48__acln2
   dec l
   exx
   call mm48_fpadd
   pop af
   push bc                     ;Gem resultat
   push de
   push hl
   ld l,a                      ;Udregn N*LN(2)
   ld h,0
   jr nc, mm48__ln1
   dec h

mm48__ln1:

   call mm48_float
   exx
   inc l
   call mm48_fpmul
   exx
   pop hl                      ;Hent resultat
   pop de
   pop bc
   call mm48_fpadd             ;Adder
   ld a,l
   cp $80 - 25                 ;LN(X)<3E-8 => LN(X)=0
   call c, mm48_zero
   jp mm48__add10              ;Hent AC'

;Konstanter for udregning af LN.

lnk:

   defw $1745, $D174, $5D81   ;K1
   defw $38E3, $8E38, $E481   ;K2
   defw $6DB6, $DB6D, $B781   ;K3
   defw $2666, $6666, $6682   ;K4
   defw $0AAA, $AAAA, $AB83   ;K5
   defw $5000, $0000, $0084   ;K6
