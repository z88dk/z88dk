; void sp1_PutTiles(struct sp1_Rect *r, struct sp1_tp *src)
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_temp_sp1

PUBLIC asm_sp1_PutTiles

EXTERN asm_sp1_GetUpdateStruct

asm_sp1_PutTiles:

; Copy a rectangular set of tiles and colours to screen.  The
; source array can be filled in by SP1GetTiles.
;
; enter : hl = struct sp1_tp[] array of attr/tile pairs
;          d = row coord
;          e = col coord
;          b = width
;          c = height
; uses  : af, bc, de, hl, ixl

   push hl
   call asm_sp1_GetUpdateStruct       ; hl = & struct sp1_update
   pop de                             ; de = struct sp1_tp *
   inc hl
   ex de,hl                           ; hl = struct sp1_tp *, de = & struct sp1_update
 
   ld ixl,c                           ; ixl = height
   ld c,$ff

.rowloop

   push bc                            ; save b = width
   push de                            ; save update position

.colloop

   ldi                                ; copy colour and tile from struct sp1_tp[

   ldi                                ; into struct sp1_update
   ldi
   ld a,7
   add a,e
   ld e,a
   jp nc, noinc
   inc d                              ; de = next struct sp1_update * one column to right

.noinc

   djnz colloop

   ex (sp),hl                         ; hl = struct sp1_update * in same row but leftmost column
   ld bc,10*SP1V_DISPWIDTH
   add hl,bc                          ; hl = struct sp1_update * one row down leftmost column
   pop de
   ex de,hl                           ; de = struct sp1_update * down one row, hl = struct sp1_tp[

   pop bc                             ; b = width

   dec ixl
   jp nz, rowloop

   ret
