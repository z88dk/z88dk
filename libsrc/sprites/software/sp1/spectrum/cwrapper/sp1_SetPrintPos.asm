
; C Wrapper
; 05.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

XLIB sp1_SetPrintPos
LIB SP1GetUpdateStruct

; void sp1_SetPrintPos(struct sp1_pss *ps, uchar row, uchar col)

.sp1_SetPrintPos

   ld hl,2
   add hl,sp
   ld c,(hl)
   inc hl
   inc hl
   ld b,(hl)
   inc hl
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld (hl),c
   inc hl
   ld (hl),b
   inc hl
   inc hl
   inc hl
   push hl
   ld a,(de)
   add a,b
   ld h,a
   inc de
   ld a,(de)
   add a,c
   ld l,a
   ex de,hl
   call SP1GetUpdateStruct
   pop de
   ex de,hl
   ld (hl),e
   inc hl
   ld (hl),d
   ret
