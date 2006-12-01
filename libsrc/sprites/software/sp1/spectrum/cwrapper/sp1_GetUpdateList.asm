
; C Wrapper
; 11.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

; void sp1_GetUpdateList(struct sp1_update **head, struct sp1_update **tail)

XLIB sp1_GetUpdateList
LIB SP1GetUpdateList

.sp1_GetUpdateList

   call SP1GetUpdateList
   push hl
   ld c,e
   ld b,d
   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ex de,hl
   ld (hl),c
   inc hl
   ld (hl),b
   ex de,hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   pop bc
   ld (hl),c
   inc hl
   ld (hl),b
   ret
   
; exit  : hl = struct sp1_update *head
;         de = struct sp1_update *tail
