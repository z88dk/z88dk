
SECTION code_fp_math48

PUBLIC mm48_cmp

EXTERN mm48__cmpac

mm48_cmp:

;     Comparison
;     -------------
;
;     NAME:      CMP
;     FUNCTION:  Compare AC to AC'.
;     OFFSET:    12H
;     OUTPUT:    ZF=1:      AC-AC'.
;                ZF=0,CF=0: AC>AC'.
;                ZF=0,CF=1: AC<AC'.
;     STACK:     2 bytes

   exx                         ;Er fortegn ens?
   ld a,b
   exx
   xor b
   jp p, mm48__cmp1            ;Ja => CMP1
   ld a,b                      ;Fortegn fra AC til
   rla                         ;carry
   ret

mm48__cmp1:

   bit 7,b                     ;Negative tal?
   jr z, mm48__cmp2            ;Nej => CMP2

   call mm48__cmp2             ;Sammenlign abs.vaerdi
   ret z                       ;Ens => Returner
   ccf                         ;Complementer resultat
   ret

mm48__cmp2:

   ld a,l                      ;Er exponenter ens?
   exx
   cp l
   exx
   ret nz                      ;Nej => Returner
   or a                        ;Er exponenter nul?
   ret z                       ;Ja => Returner
   jp mm48__cmpac              ;Sammenlign AC med AC'
