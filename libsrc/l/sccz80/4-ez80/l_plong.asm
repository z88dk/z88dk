;       Z88 Small C+ Run Time Library 
;       Long functions
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_plong

l_plong:
   ld a,l
   ld l,c
   ld c,a
   ld a,h
   ld h,b
   ld b,a
   defb $ed, $0f	;ld (hl),bc
   inc hl
   inc hl
   defb $ed, $1f	;ld (hl),de
   ld hl,bc
   ret
