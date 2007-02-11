; void __CALLEE__ sp1_ChangeSprType_callee(struct sp1_cs *c, uchar type)
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB sp1_ChangeSprType_callee
XDEF ASMDISP_SP1_CHANGESPRTYPE_CALLEE

XREF SP1V_SPRDRAWTBL

.sp1_ChangeSprType_callee

   pop bc
   pop de
   pop hl
   push bc

.asmentry

; Change the type of a sprite char struct so that it draws using
; a different draw function.  If the occluding flag is changed,
; make sure the sprite char struct is off screen before calling.
;
; enter : hl = struct sp1_cs *
;          e = new type (bit 7 = 1 if sprite should occlude, bit 4 = 1 clear pixelbuff, bits 3:0 draw type id, zero elsewhere)
; uses  : af, bc, de, hl

.SP1ChangeSprType

   ld bc,5
   add hl,bc
   ld a,(hl)
   and $60               ; keep last row, last col flags
   or e
   ld (hl),a             ; store new type
   and $0f               ; a = draw type

   add hl,bc
   ex de,hl              ; de = & struct sp1_CS.draw_code
   add a,a
   ld c,a
   ld hl,(SP1V_SPRDRAWTBL)
   add hl,bc
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                ; hl = sprite struct draw code

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

DEFC ASMDISP_SP1_CHANGESPRTYPE_CALLEE = asmentry - sp1_ChangeSprType_callee
