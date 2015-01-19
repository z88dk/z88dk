; void __CALLEE__ sp1_IterateUpdateRect_callee(struct sp1_Rect *r, void *hook)
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

PUBLIC sp1_IterateUpdateRect_callee
PUBLIC ASMDISP_SP1_ITERATEUPDATERECT_CALLEE, CDISP_SP1_ITERATEUPDATERECT_CALLEE

EXTERN sp1_GetUpdateStruct_callee, l_jpix
EXTERN ASMDISP_SP1_GETUPDATESTRUCT_CALLEE, SP1V_DISPWIDTH

.sp1_IterateUpdateRect_callee

   pop hl
   pop ix
   ex (sp),hl

.centry

   ld d,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)

.asmentry

; Iterate over all the struct_sp1_update making up
; a rectangular area in row major order.  Call a
; user supplied function with each struct_sp1_update
; iterated as parameter.
;
; enter : d = row coord
;         e = col coord
;         b = width
;         c = height
;        ix = void (*func)(struct sp1_update*), hl also holds parameter
; uses  : af, bc, de, hl  (de can be used by user function to hold state between calls)

.SP1IterateUpdateRect

   call sp1_GetUpdateStruct_callee + ASMDISP_SP1_GETUPDATESTRUCT_CALLEE  ; hl = & struct sp1_update

.rowloop

   push bc
   push hl                       ; save update position

.colloop

   push bc
   push hl
   call l_jpix
   pop hl
   ld bc,10
   add hl,bc
   pop bc
   djnz colloop

   pop hl                        ; hl = & struct sp1_update same row leftmost column
   ld bc,10*SP1V_DISPWIDTH
   add hl,bc                     ; hl = & struct sp1_update next row leftmost column
   pop bc

   dec c                         ; c = height
   jp nz, rowloop

   ret

DEFC ASMDISP_SP1_ITERATEUPDATERECT_CALLEE = # asmentry - sp1_IterateUpdateRect_callee
DEFC CDISP_SP1_ITERATEUPDATERECT_CALLEE = # centry - sp1_IterateUpdateRect_callee
