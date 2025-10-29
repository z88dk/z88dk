; void __CALLEE__ sp1_GetTiles_callee(struct sp1_Rect *r, struct sp1_tp *dest)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_GetTiles_callee

EXTERN asm_sp1_GetTiles

sp1_GetTiles_callee:

   pop af
   pop hl
   ex (sp),hl
   ld d,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)
   pop hl
   push af

;   jp asm_sp1_GetTiles
   push ix
   call asm_sp1_GetTiles
   pop ix
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sp1_GetTiles_callee
defc _sp1_GetTiles_callee = sp1_GetTiles_callee
ENDIF

