; void sp1_ClearRect(struct sp1_Rect *r, uchar colour, uchar tile, uchar rflag)
; CALLER linkage for function pointers

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_ClearRect

EXTERN asm_sp1_ClearRect

sp1_ClearRect:

   ld hl,2
   add hl,sp
   ld a,(hl)
   inc hl
   inc hl
   ld e,(hl)
   inc hl
   inc hl
   ld d,(hl)
   inc hl
   inc hl
   ld c,(hl)
   inc hl
   ld h,(hl)
   ld l,c
   push de
   ld d,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)
   pop hl
   
   jp asm_sp1_ClearRect
