; void __FASTCALL__ sp1_Invalidate(struct sp1_Rect *r)
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_temp_sp1

PUBLIC asm_sp1_Invalidate

EXTERN asm_sp1_GetUpdateStruct

asm_sp1_Invalidate:

; Invalidate a rectangular area so the tiles are drawn in the next update.
;
; enter : d = row coord
;         e = col coord
;         b = width
;         c = height
; uses  : af, bc, de, hl

   call asm_sp1_GetUpdateStruct
   ex de,hl                      ; de = & struct sp1_update
   ld hl,(SP1V_UPDATELISTT)
   ld a,6
   add a,l
   ld l,a
   jp nc, rowlp
   inc h                         ; hl = last struct sp1_update+6 in invalidated list

.rowlp

   push bc                       ; save b = width, c = height
   push de                       ; save first struct sp1_update in row

   ; hl = last struct sp1_update + 6 in invalidated list
   ; de = current struct sp1_update to invalidate

.collp

   ld a,(de)
   xor $80
   jp p, alreadyinlist           ; if already invalidated skip it

   ld (de),a                     ; mark as invalidated
   ld (hl),d                     ; store this struct sp1_update at tail end of invalidated list
   inc hl
   ld (hl),e

   ld hl,6
   add hl,de                     ; hl = new last struct sp1_update+6 in invalidated list

.alreadyinlist

   ld a,10
   add a,e
   ld e,a
   jp nc, noinc
   inc d

.noinc                           ; de = struct sp1_update to invalidate in next column

   djnz collp

   pop de                        ; de = first struct sp1_update in row
   ex de,hl
   ld bc,10*SP1V_DISPWIDTH
   add hl,bc
   ex de,hl                      ; de = first struct sp1_update in next row, hl = last+6 in invalidated list
   pop bc                        ; b = width, c = height

   dec c
   jp nz, rowlp

   ld (hl),0                     ; mark end of invalidated list
   ld bc,-6
   add hl,bc                     ; point to start of struct sp1_update
   ld (SP1V_UPDATELISTT),hl      ; and store as last in invalidated list

   ret
