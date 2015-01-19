; void __CALLEE__ sp1_PutTiles_callee(struct sp1_Rect *r, struct sp1_tp *src)
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

PUBLIC sp1_PutTiles_callee
PUBLIC ASMDISP_SP1_PUTTILES_CALLEE

EXTERN sp1_GetUpdateStruct_callee
EXTERN ASMDISP_SP1_GETUPDATESTRUCT_CALLEE, SP1V_DISPWIDTH

.sp1_PutTiles_callee

   pop af
   pop hl
   ex (sp),hl
   ld d,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)
   pop hl
   push af

.asmentry

; Copy a rectangular set of tiles and colours to screen.  The
; source array can be filled in by SP1GetTiles.
;
; enter : hl = struct sp1_tp[] array of attr/tile pairs
;          d = row coord
;          e = col coord
;          b = width
;          c = height
; uses  : af, bc, de, hl, ixl

.SP1PutTiles

   push hl
   call sp1_GetUpdateStruct_callee + ASMDISP_SP1_GETUPDATESTRUCT_CALLEE  ; hl = & struct sp1_update
   pop de                             ; de = struct sp1_tp *
   inc hl
   ex de,hl                           ; hl = struct sp1_tp *, de = & struct sp1_update
 
   ld ixl,c                           ; ixl = height
   ld c,$ff

.rowloop

   push bc                            ; save b = width
   push de                            ; save update position

.colloop

   ldi                                ; copy colour and tile from struct sp1_tp[]
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
   ex de,hl                           ; de = struct sp1_update * down one row, hl = struct sp1_tp[]
   pop bc                             ; b = width

   dec ixl
   jp nz, rowloop

   ret

DEFC ASMDISP_SP1_PUTTILES_CALLEE = # asmentry - sp1_PutTiles_callee
