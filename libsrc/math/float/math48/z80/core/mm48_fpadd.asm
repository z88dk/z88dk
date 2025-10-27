
SECTION code_clib
SECTION code_fp_math48

PUBLIC mm48_fpadd, mm48__add1, mm48__add10

EXTERN am48_derror_erange_pinfc
EXTERN mm48__sub1, mm48__addac, mm48__cmpac, mm48__zero
EXTERN mm48__sright, mm48__right, mm48__sleft, mm48__subac

mm48_fpadd:

   ; floating point add
   ; AC' = AC' + AC
   ;
   ; enter : AC (BCDEHL ) = float a
   ;         AC'(BCDEHL') = float b
   ;
   ; exit  : AC (BCDEHL ) unchanged
   ;
   ;         success
   ;
   ;            AC'(BCDEHL') = a + b
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            AC'(BCDEHL') = double_max or double_min
   ;            carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

   bit 7,b                     ;is AC negative?
   exx
   
   ; AC' active
   
   jp nz, mm48__sub1           ;Ja => SUB1

mm48__add1:

   ; AC' active

   exx
   
   ; AC active
   
   ld a,l                      ;is AC zero?
   or a
   ret z                       ;yes return AC'

   push bc                     ;save AC
   push de
   push hl
   exx
   
   ; AC' active
   
   ld a,l                      ;is AC' zero?
   or a
   jr nz, mm48__add2           ;Nej => ADD2
   
   exx
   
   ; AC active
   ; return AC
   
   res 7,b                     ;make positive
   jr mm48__add10

mm48__add2:

   ; AC' active

   push bc                     ;Gem fortegn
   set 7,b                     ;Saet MSB
   xor a                       ;Saet Z'
   ex af,af'
   exx
   set 7,b                     ;Saet MSB'
   ld a,l                      ;A=EXP'-EXP
   exx
   sub l
   jr z, mm48__add4            ;EXP=EXP' => ADD4
   jr nc, mm48__add3           ;EXP<EXP' => ADD3

   neg                         ;Goer A positiv
   ex af,af'                   ;Nulstil Z'
   dec a
   ex af,af'
   exx                         ;Juster AC'

mm48__add3:

   call mm48__sright           ;Skift til hoejre
   inc l                       ;Er EXP=EXP'?
   dec a
   jr nz, mm48__add3           ;Nej => ADD3

   ex af,af'                   ;Var det AC'?
   jr z, mm48__add4            ;Nej => ADD4
   exx                         ;Ja => Ombyt

mm48__add4:

   pop af                      ;Hent AC fortegn
   and $80                     ;Negativt?
   jr nz, mm48__add5           ;Ja => ADD5

   call mm48__addac            ;MANT=MANT+MANT'
   jr nc, mm48__add9           ;Ikke overflow => ADD9
   call mm48__right            ;Roter til hoejre
   or a
   inc l                       ;Juster exponent
   jr nz, mm48__add9

   call am48_derror_erange_pinfc + 1
   jr mm48__add10

mm48__add5:

   call mm48__cmpac            ;Sammenlign
   ccf                         ;Komplementer carry og
   push af                     ;gem som fortegn
   jr z, mm48__addz            ;AC=AC' => ADDZ
   jr c, mm48__add6            ;AC>AC' => ADD6
   exx                         ;AC<AC' => Ombyt

mm48__add6:

   call mm48__subac            ;MANT=MANT-MANT'

mm48__add7:

   bit 7,b                     ;Normaliseret?
   jr nz, mm48__add8           ;Ja => ADD8
   call mm48__sleft            ;Skift til venstre
   inc l                       ;Er exponent -128?
   dec l
   jr z, mm48__addz            ;Ja => AC lig nul
   dec l                       ;Traek 1 fra exponent
   jr mm48__add7

mm48__addz:

   call mm48__zero

mm48__add8:

   pop af                      ;Hent fortegn

mm48__add9:

   jr c, mm48__add9a           ;Carry => negativt
   res 7,b

mm48__add9a:

   or a

mm48__add10:

   ; result in BCDEHL

   exx                         ;AC' = result
   
   ; mm48__add10 + 1 is another entry point
   
   pop hl                      ;restore AC
   pop de
   pop bc

   ret
