
; Rectangle, Intervals and Points
; 05.2006 aralbrec

SECTION code_clib
PUBLIC r_IntersectRect16
PUBLIC _r_IntersectRect16
EXTERN RIntersectRect16

; int r_IntersectRect16(struct r_Rect16 *r1, struct r_Rect16 *r2, struct r_Rect16 *result)

.r_IntersectRect16
._r_IntersectRect16

   push ix                  ; RIntersectRect16 takes the result pointer in ix
   ld hl,9                  ; skip saved ix and return address
   add hl,sp
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   push de
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   ld b,(hl)
   dec hl
   ld c,(hl)
IF __CPU_RABBIT__ | __CPU_Z180__ | __CPU_KC160__
   push bc
   pop  ix
ELSE
   ld ixl,c
   ld ixh,b
ENDIF
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
   
   call RIntersectRect16
   ld hl,0
   jr nc,done
   inc l
.done
   pop ix
   ret
