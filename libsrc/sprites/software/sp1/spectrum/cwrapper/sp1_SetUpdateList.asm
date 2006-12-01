
; C Wrapper
; 11.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

; void sp1_SetUpdateList(struct sp1_update *head, struct sp1_update *tail)

XLIB sp1_SetUpdateList
LIB SP1SetUpdateList

.sp1_SetUpdateList

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   jp SP1SetUpdateList
