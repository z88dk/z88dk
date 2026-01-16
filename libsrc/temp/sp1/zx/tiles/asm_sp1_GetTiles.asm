; void sp1_GetTiles(struct sp1_Rect *r, struct sp1_tp *dest)
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_temp_sp1

PUBLIC asm_sp1_GetTiles

EXTERN asm_sp1_GetUpdateStruct

asm_sp1_GetTiles:

; Copy colour and tile from background into destination array.  Can
; be printed to screen as a macro by SP1PutTiles.
;
; enter : hl = & struct sp1_tp[] destination array to store tile info
;          d = row coord
;          e = col coord
;          b = width
;          c = height
; uses  : af, bc, de, hl, ixl

   push hl
   call asm_sp1_GetUpdateStruct   ; hl = & struct sp1_update
   pop de                         ; de = dest address
   inc hl

   ld ixl,c                       ; ixl = height
   ld c,$ff

.rowloop

   push bc                        ; save b = width
   push hl                        ; save update position

.colloop

   ldi
   ldi
   ldi
   ld a,7
   add a,l
   ld l,a
   jp nc, noinc
   inc h

.noinc

   djnz colloop

   pop hl                         ; hl = & struct sp1_update in same row leftmost column
   ld bc,10*SP1V_DISPWIDTH
   add hl,bc                      ; hl = & struct sp1_update in next row leftmost column
   pop bc

   dec ixl
   jp nz, rowloop

   ret
