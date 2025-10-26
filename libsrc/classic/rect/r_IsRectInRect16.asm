
; Rectangle, Intervals and Points
; 05.2006 aralbrec

SECTION code_clib
PUBLIC r_IsRectInRect16
PUBLIC _r_IsRectInRect16
EXTERN RIsRectInRect16

; int r_IsRectInRect16(struct r_Rect16 *r1, struct r_Rect16 *r2)

.r_IsRectInRect16
._r_IsRectInRect16

   ld hl,5
   add hl,sp
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   push de
   ld d,(hl)
   dec hl
   ld e,(hl)
   ex de,hl
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ex (sp),hl
   ld a,(hl)
   inc hl
   push hl
   ld h,(hl)
   ld l,a

   ; stack = r2.y, r1.width-1

   exx
   
   pop hl
   inc hl
   pop de
   ld a,(hl)
   inc hl
   ex af,af
   ld a,(hl)
   inc hl
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   push bc
   ld c,(hl)
   inc hl
   ld b,(hl)
   push bc
   ex de,hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   push de
   ld e,(hl)
   inc hl
   ld d,(hl)
   push de
   ld d,a
   ex af,af
   ld e,a
   
   exx
   
   call RIsRectInRect16
   ld hl,0
   ret nc
   inc l
   ret
