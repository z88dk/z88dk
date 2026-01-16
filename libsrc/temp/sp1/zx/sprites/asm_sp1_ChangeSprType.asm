; void sp1_ChangeSprType(struct sp1_cs *c, void *drawf)
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC asm_sp1_ChangeSprType

asm_sp1_ChangeSprType:

; Change the type of a sprite char struct so that it draws using
; a different draw function.  If the occluding flag is changed,
; make sure the sprite char struct is off screen before calling.
;
; enter : hl = struct sp1_cs *
;         de = address of sprite draw function
; uses  : af, bc, de, hl

   ld bc,10
   add hl,bc
   ex de,hl              ; de = & struct sp1_CS.draw_code, hl = & draw function
   ld bc,-10
   add hl,bc             ; hl = & draw function data

   ldi                   ; copy draw code into struct sp1_cs.draw_code
   inc hl                ; but skip over graphic pointers
   inc hl
   inc de
   inc de
   ldi
   ldi
   inc hl
   inc hl
   inc de
   inc de
   ldi
   ldi
   ldi

   ret
