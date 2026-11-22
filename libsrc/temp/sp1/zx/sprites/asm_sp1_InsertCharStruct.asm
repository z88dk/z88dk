
; void sp1_InsertCharStruct_callee(struct sp1_update *u, struct sp1_cs *cs)
; 05.2007 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC asm_sp1_InsertCharStruct

EXTERN __sp1_add_spr_char

asm_sp1_InsertCharStruct:

   ; hl = struct sp1_cs *
   ; de = struct sp1_update *

   inc hl
   inc hl
   ld (hl),d                   ; store sp1_update into sp1_cs.update
   inc hl
   ld (hl),e
   inc hl
   ld a,(hl)                   ; a = plane
   inc hl                      ; hl = & sp1_cs.type
   
   bit 7,(hl)                  ; is it occluding type?
   ex de,hl
   jr z, notoccluding
   inc (hl)                    ; increase # occluding sprites in update struct

.notoccluding

   inc de
   ld c,e
   ld b,d                      ; bc = & sp1_cs.attr_mask
   ld de,4
   add hl,de                   ; hl = & sp1_update.slist
   jp __sp1_add_spr_char
