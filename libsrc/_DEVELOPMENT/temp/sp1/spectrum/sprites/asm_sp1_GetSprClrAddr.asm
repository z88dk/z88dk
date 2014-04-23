; void sp1_GetSprClrAddr(struct sp1_ss *s, uchar **sprdest)
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB asm_sp1_GetSprClrAddr

LIB asm_sp1_IterateSprChar

asm_sp1_GetSprClrAddr:

; Stores address of attr_mask member in all struct_sp1_cs
; making up a sprite into array passed in.
;
; enter : hl = & struct sp1_ss
;         de = destination array of sprite colour addresses
; uses  : af, bc, de, hl, ix

   ld ix,getaddr
   jp asm_sp1_IterateSprChar

getaddr:

   ; hl = & struct sp1_cs
   ; de = current position in destination array of sprite colour addresses

   ld bc,6
   add hl,bc
   ex de,hl                    ; de = & struct sp1_cs.attr_mask, hl = address array
   ld (hl),e                   ; store address of sprite tile's colour info into array
   inc hl
   ld (hl),d
   inc hl
   ex de,hl                    ; de = next destination address in array of pointers

   ret
