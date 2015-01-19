; void __FASTCALL__ sp1_Validate(struct sp1_Rect *r)
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

PUBLIC sp1_Validate
PUBLIC ASMDISP_SP1_VALIDATE

EXTERN sp1_GetUpdateStruct_callee
EXTERN ASMDISP_SP1_GETUPDATESTRUCT_CALLEE, SP1V_DISPWIDTH

.sp1_Validate

   ld d,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)

.asmentry

; Validate a rectangular area, ensuring the area is not drawn
; in next update.  Make sure that none of the validated area
; is invalidated by further calls before the next update otherwise
; areas of the screen may become inactive (ie are never drawn).
;
; enter : d = row coord
;         e = col coord
;         b = width
;         c = height
; uses  : f, bc, de, hl

.SP1Validate

   call sp1_GetUpdateStruct_callee + ASMDISP_SP1_GETUPDATESTRUCT_CALLEE  ; hl = & struct sp1_update
   ld de,10

.rowloop

   push bc                       ; save b = width
   push hl                       ; save update position

.colloop

   bit 6,(hl)                    ; has this update char been removed from the display?
   jr nz, skipit                 ; if so we must not validate it
   res 7,(hl)                    ; validate update char

.skipit

   add hl,de
   djnz colloop

   pop hl                        ; hl = & struct sp1_update same row leftmost column
   ld bc,10*SP1V_DISPWIDTH
   add hl,bc                     ; hl = & struct sp1_update next row leftmost column
   pop bc

   dec c                         ; c = height
   jp nz, rowloop

   ret

DEFC ASMDISP_SP1_VALIDATE = # asmentry - sp1_Validate
