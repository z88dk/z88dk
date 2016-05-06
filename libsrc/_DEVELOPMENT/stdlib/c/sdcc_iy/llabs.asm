
; long long llabs(long long i)

SECTION code_clib
SECTION code_stdlib

PUBLIC _llabs

EXTERN l_neg_64_mhl

_llabs:

   ld hl,2
   add hl,sp
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = result *
   inc hl                      ; hl = & i
   
   push de
   
   ld bc,8
   ldir                        ; copy i to result
   
   dec hl                      ; hl = & MSB(i)
   bit 7,(hl)
   
   pop hl                      ; hl = result *
   
   ret z                       ; if i is positive
   jp l_neg_64_mhl             ; result = -result
