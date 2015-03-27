
SECTION code_fp_math48

PUBLIC mm48_fpsub
PUBLIC mm48__sub1

EXTERN mm48__add1

mm48_fpsub:

;     Subtraktion
;     ------------
;
;     NAME:      FPSUB
;     FUNCTION:  AC=AC-AC'. The number in AC' is subtracted from
;                the number in AC and the result is placed in AC.
;     OFFSET:    03H
;     OUTPUT:    CF=0: OK.
;                CF=1: Overflow.
;     STACK:     12 bytes.

   exx                         ;Er AC negativ?
   bit 7,b
   exx
   jp nz,mm48__add1            ;Ja => ADD1

mm48__sub1:

   call mm48__fpneg            ;AC=-AC
   call mm48__add1             ;Laeg AC' til AC

mm48__fpneg:

   inc l                       ;Er AC nul?
   dec l
   ret z                       ;Ja => Returner
   ex af,af'                   ;Gem carry
   ld a,b                      ;Komplementer fortegn
   xor $80
   ld b,a
   ex af,af'                   ;Hent carry
   ret
