
SECTION code_clib
SECTION code_fp_math48

PUBLIC mm48_cmp, mm48__cmp2

EXTERN mm48__cmpac

mm48_cmp:

   ; compare AC to AC' (effective AC - AC')
   ;
   ; enter : AC (BCDEHL ) = float x
   ;         AC'(BCDEHL') = float y
   ;
   ; exit  : ZF=1:      AC=AC'.
   ;         ZF=0,CF=0: AC>AC'.
   ;         ZF=0,CF=1: AC<AC'.
   ;
   ; uses  : af

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
