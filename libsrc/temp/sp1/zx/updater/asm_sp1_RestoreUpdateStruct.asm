
; sp1_RestoreUpdateStruct
; 04.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC asm_sp1_RestoreUpdateStruct

; FASTCALL

; Restores a character cell previously removed from
; the sprite engine so that it will again be drawn
; by the engine.  Restored cell is not invalidated.
;
; enter : hl = & struct sp1_update
; uses  : f

asm_sp1_RestoreUpdateStruct:

   bit 6,(hl)
   ret z                ; this cell was never removed so just return

   ld (hl),1            ; clear invalidated + removed flags
   ret
