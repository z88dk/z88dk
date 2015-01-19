; void __CALLEE__ sp1_GetTiles_callee(struct sp1_Rect *r, struct sp1_tp *dest)
; 01.2008 aralbrec, Sprite Pack v3.0
; ts2068 hi-res version

PUBLIC sp1_GetTiles_callee
PUBLIC ASMDISP_SP1_GETTILES_CALLEE

EXTERN sp1_GetUpdateStruct_callee
EXTERN ASMDISP_SP1_GETUPDATESTRUCT_CALLEE, SP1V_DISPWIDTH

.sp1_GetTiles_callee

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

; Copy colour and tile from background into destination array.  Can
; be printed to screen as a macro by SP1PutTiles.
;
; enter : hl = & struct sp1_tp[] destination array to store tile info
;          d = row coord
;          e = col coord
;          b = width
;          c = height
; uses  : af, bc, de, hl, ixl

.SP1GetTiles

   push hl
   call sp1_GetUpdateStruct_callee + ASMDISP_SP1_GETUPDATESTRUCT_CALLEE  ; hl = & struct sp1_update
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
   ld a,7
   add a,l
   ld l,a
   jp nc, noinc
   inc h

.noinc

   djnz colloop

   pop hl                         ; hl = & struct sp1_update in same row leftmost column
   ld bc,9*SP1V_DISPWIDTH
   add hl,bc                      ; hl = & struct sp1_update in next row leftmost column
   pop bc

   dec ixl
   jp nz, rowloop

   ret

DEFC ASMDISP_SP1_GETTILES_CALLEE = # asmentry - sp1_GetTiles_callee
