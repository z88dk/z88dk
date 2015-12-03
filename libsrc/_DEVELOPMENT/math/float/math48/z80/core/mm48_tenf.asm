
SECTION code_clib
SECTION code_fp_math48

PUBLIC mm48_tenf

EXTERN mm48__getcix, mm48_mul10, mm48_fpmul, mm48_fpdiv
EXTERN l_inc_sp, am48_derror_erange_infc, mm48__retzero

mm48_tenf:

   ; multiply by power of 10
   ; AC' = AC' * 10^A
   ;
   ; enter :          A   = power of 10, |A| < 40
   ;         AC'(BCDEHL') = float x
   ;
   ; exit  : success
   ;
   ;            AC' = AC' * 10^A
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            AC' = double_max or double_min
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'

;Multiplicer AC' med 10^A.

   push af                     ;Gem AF
   or a                        ;Positiv exponent?
   jp p, mm48__tf1             ;Ja => TF1
   neg                         ;A=ABS(A)

mm48__tf1:

   push af                     ;Gem flag

   cp 39
   jr nc, mm48__tenf_range     ;cannot multiply powers that high

   srl a                       ;A=INT(A/4)
   srl a
   ld hl,-6                    ;Udregn offset til
   ld de,6                     ;konstant nummer A
   inc a

mm48__tf2:

   add hl,de
   dec a
   jr nz, mm48__tf2
   ex de,hl
   push ix                     ;Gem IX
   ld ix,con10                 ;Hent konstant
   add ix,de
   call mm48__getcix
   pop ix                      ;Hent IX
   pop af                      ;Hent exponent
   and 3                       ;Juster faktor
   jr z, mm48__tf4

mm48__tf3:

   push af
   exx
   call mm48_mul10
   exx
   jp c, l_inc_sp - 4          ;if overflow
   pop af
   dec a
   jr nz, mm48__tf3

mm48__tf4:

   pop af                      ;Hent exponent
   or a                        ;Positiv?
   jp p, mm48_fpmul            ;Ja => Multipicer
   jp mm48_fpdiv               ;Nej => Divider

mm48__tenf_range:

   pop af
   pop af
   
   or a
   
   jp m, mm48__retzero         ; if exp < 0 return 0   
   jp am48_derror_erange_infc  ; if exp > 0 return infinity

;Tier potens konstanter for konvertering.

con10:

   defw $0000, $0000, $0081 ;1E+00
   defw $1C40, $0000, $008E ;1E+04
   defw $3EBC, $2000, $009B ;1E+08
   defw $68D4, $A510, $00A8 ;1E+12  -- anders, transposition of digits here!!
   defw $0E1B, $C9BF, $04B6 ;1E+16
   defw $2D78, $EBC5, $ACC3 ;1E+20
   defw $53C2, $1BCE, $CDD0 ;1E+24
   defw $013F, $3978, $F9DE ;1E+28
   defw $1DC5, $ADA8, $2BEB ;1E+32
   defw $4097, $CE7B, $C9F8 ;1E+36
