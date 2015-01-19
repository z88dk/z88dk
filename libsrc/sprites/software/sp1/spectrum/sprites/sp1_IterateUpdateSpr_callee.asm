; void __CALLEE__ sp1_IterateUpdateSpr_callee(struct sp1_ss *s, void *hook2)
; 11.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

PUBLIC sp1_IterateUpdateSpr_callee
PUBLIC ASMDISP_SP1_ITERATEUPDATESPR_CALLEE

EXTERN l_jpix

.sp1_IterateUpdateSpr_callee

   pop hl
   pop ix
   ex (sp),hl

.asmentry

; Iterate over all the sp1_update* that the sprite's characters
; occupy in row major order, calling the user function for each
; one.  Where a sprite character is not drawn, the user function
; is not called.
;
; enter : hl = & struct sp1_ss
;         ix = user function
; uses  : af, bc, hl + whatever user function uses

.SP1IterateSprChar

   ld bc,15
   add hl,bc              ; hl = & struct sp1_ss.first

   ld c,b                 ; bc = sprite char counter = 0

.iterloop

   ld a,(hl)
   or a
   ret z

   inc hl
   ld l,(hl)
   ld h,a                 ; hl = & next struct sp1_cs
   push hl
   inc hl
   inc hl
   
   ld a,(hl)
   or a
   jr z, skipit
   inc hl
   ld l,(hl)
   ld h,a                 ; hl = struct sp1_update*
   
   push bc
   push hl
   call l_jpix            ; call userfunc(uint count, struct sp1_update *u)
   pop hl
   pop bc
   
.skipit

   pop hl
   inc bc
   jp iterloop

DEFC ASMDISP_SP1_ITERATEUPDATESPR_CALLEE = # asmentry - sp1_IterateUpdateSpr_callee
