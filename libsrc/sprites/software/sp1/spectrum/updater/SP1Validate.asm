
; SP1Validate
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB SP1Validate
LIB SP1GetUpdateStruct
XREF SP1V_DISPWIDTH

; Validate a rectangular area, ensuring the area is not drawn
; in next update.  Make sure that none of the validated area
; is invalidated by further calls before the next update otherwise
; areas of the screen may become inactive (ie are never drawn).
;
; enter : d = row coord
;         e = col coord
;         b = width
;         c = height
; uses  : af, bc, de, hl

.SP1Validate

   call SP1GetUpdateStruct       ; hl = & struct sp1_update
   ld a,c                        ; a = height
   ld de,9

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
   ld bc,9*SP1V_DISPWIDTH
   add hl,bc                     ; hl = & struct sp1_update next row leftmost column
   pop bc

   dec a                         ; a = height
   jp nz, rowloop

   ret
