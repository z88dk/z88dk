; void __CALLEE__ sp1_IterateUpdateRect_callee(struct sp1_Rect *r, void *hook)
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair zx version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_IterateUpdateRect_callee, asm0_sp1_IterateUpdateRect

EXTERN asm_sp1_IterateUpdateRect

sp1_IterateUpdateRect_callee:

   pop hl

   push ix      ; save IX to BC'
   exx
   pop bc
   exx

   pop ix
   ex (sp),hl

asm0_sp1_IterateUpdateRect:

   ld d,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)

;   jp asm_sp1_IterateUpdateRect
   exx		; save old IX
   push bc
   exx
   call asm_sp1_IterateUpdateRect
   pop ix	; restore it
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sp1_IterateUpdateRect_callee
defc _sp1_IterateUpdateRect_callee = sp1_IterateUpdateRect_callee
ENDIF

