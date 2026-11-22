
SECTION code_clib
SECTION code_fp_math48

PUBLIC mm48_ln

EXTERN am48_derror_edom_minfc, am48_derror_erange_minfc, mm48__acsqr2_2
EXTERN mm48__comser, mm48__acln2, am48_double16, mm48__zero, mm48__ac1
EXTERN mm48_fpmul, mm48_fpsub, mm48_fpadd, mm48_fpdiv, mm48__add10

mm48_ln:

   ; natural logarithm
   ; AC' = ln(AC')
   ;
   ; enter : AC'(BCDEHL') = float x
   ;
   ; exit  : success
   ;
   ;            AC'= ln(x)
   ;            carry reset
   ;
   ;         fail if domain error
   ;
   ;            AC'= double_min
   ;            carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

;LN(X) beregnes paa flg. maade:
;X=Y*2^N, 1<=Y<2
;Z=Y*SQR(2)/2
;U=(Z-1)/(Z+1), V=U^2
;R=U((((((V+K1)V+K2)V+K3)V+K4)V+K5)V+K6)/K6
;Kn=13/(13-2n)
;LN(X)=2*R+LN(2)/2+N*LN(2)

   exx
   
   ; AC = x
   
   ld a,b
   
   inc l
   dec l

   exx
   
   ; AC' = x
   
   jp z, am48_derror_erange_minfc ; if x == 0
   
   or a
   jp m, am48_derror_edom_minfc   ; if x < 0
   
   push bc                     ; save AC
   push de
   push hl
   
   call mm48__acsqr2_2         ; AC = sqr(2)/2

   exx

   ld a,l                      ;Udregn N
   ld l,$80 + 1                ;Udregn Y
   sub l
   push af                     ;Gem N
   
   ; AC'= SQR(2)/2
   ; AC = x
   
   call mm48_fpmul             ;Udregn Z
   call mm48__ac1
   
   ; AC = 1
   ; AC'= z
   
   call mm48_fpsub
   inc l

   ; AC = 2
   ; AC'= z - 1

   exx
   call mm48_fpadd
   exx

   ; AC = z + 1
   ; AC'= z - 1

   call mm48_fpdiv

   ; AC'= v = (z-1)/(z+1)

   push ix                     ;Udregn LN(V)
   ld ix,lnk - 6
   ld a,6
   call mm48__comser
   pop ix

   exx
   inc l
   exx
   
   call mm48__acln2
   dec l                       ;AC = ln(2)/2
   
   call mm48_fpadd             ;AC'= z + ln(2)/2 = w
   
   exx
   
   pop af
   
   push bc                     ; save w
   push de
   push hl

   ld l,a
   ld h,0
   jr nc, mm48__ln1
   dec h

mm48__ln1:

   call am48_double16
   
   ; AC = ln(2)/2
   ; AC'= float(n)
   
   inc l
   call mm48_fpmul             ; AC'= ln(2)*float(n)
   
   pop hl                      ; AC = w
   pop de
   pop bc
   
   call mm48_fpadd
   exx
   
   ; AC = result
   
   ld a,l
   cp $80 - 25                 ;LN(X)<3E-8 => LN(X)=0
   call c, mm48__zero

   jp mm48__add10              ;Hent AC'

;Konstanter for udregning af LN.

lnk:

   defw $1745, $D174, $5D81   ;K1
   defw $38E3, $8E38, $E481   ;K2
   defw $6DB6, $DB6D, $B781   ;K3
   defw $2666, $6666, $6682   ;K4
   defw $0AAA, $AAAA, $AB83   ;K5
   defw $5000, $0000, $0084   ;K6
