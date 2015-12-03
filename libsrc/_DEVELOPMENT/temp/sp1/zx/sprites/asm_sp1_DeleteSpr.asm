
; void sp1_DeleteSpr(struct sp1_ss *s)
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC asm_sp1_DeleteSpr

EXTERN asm_free

; Delete the sprite, freeing any memory that was allocated in its
; creation.  Sprite must not be display on screen (move off-screen
; first).
;
; enter : hl = struct sp1_ss *
; uses  : af, bc, de, hl

asm_sp1_DeleteSpr:

   ex de,hl
   ld hl,15
   add hl,de                 ; hl = & struct sp1_ss.first

loop:

   ld b,(hl)
   inc hl
   ld c,(hl)                 ; bc = next struct sp1_cs to delete
   push bc
   ex de,hl
   push hl
   call asm_free             ; free current struct sp1_cs
   pop hl
   pop de
   ld l,e
   ld h,d                    ; de = hl = next struct sp1_cs to delete

   inc h
   dec h
   jp nz, loop

   ret
