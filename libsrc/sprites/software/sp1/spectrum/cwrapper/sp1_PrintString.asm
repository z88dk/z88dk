
; C Wrapper
; 05.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

XLIB sp1_PrintString
LIB SP1PrintString

; void sp1_PrintString(struct sp1_pss *ps, uchar *s)

.sp1_PrintString

   ld hl,5
   add hl,sp
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   ld a,(hl)
   dec hl
   ld l,(hl)
   ld h,a
   push de
   push hl
   ex de,hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld iyl,e
   ld iyh,d
   ld e,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)
   inc hl
   push hl
   exx
   pop hl
   ld b,(hl)
   inc hl
   ld c,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld a,(hl)
   ld ixl,a
   inc hl
   or (hl)
   jr z, novisit
   ld a,(hl)
   ld ixh,a
.rejoin
   exx
   pop hl
   call SP1PrintString
   pop hl
   inc hl
   inc hl
   ld (hl),e
   inc hl
   ld (hl),b
   inc hl
   ld (hl),c
   inc hl
   push hl
   exx
   pop hl
   ld (hl),b
   inc hl
   ld (hl),c
   inc hl
   ld (hl),e
   inc hl
   ld (hl),d
.justret
   ret

.novisit
   ld ix,justret
   jp rejoin
