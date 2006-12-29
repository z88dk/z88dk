
; SP1GetTiles
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB SP1GetTiles
LIB SP1GetUpdateStruct
XREF SP1V_DISPWIDTH

; Copy colour and tile from background into destination array.  Can
; be printed to screen as a macro by SP1PutTiles.
;
; enter : hl = & struct sp1_tp[] destination array to store tile info
;          d = row coord
;          e = col coord
;          b = width
;          c = height
; uses  : af, bc, de, hl, af'

.SP1GetTiles

   push hl
   call SP1GetUpdateStruct        ; hl = & struct sp1_update
   pop de                         ; de = dest address

   ld a,c                         ; a = height
   ld c,$ff

.rowloop

   push bc                        ; save b = width
   push hl                        ; save update position
   ex af,af                       ; a' = height

.colloop

   inc hl
   ldi
   ldi
   ldi
   ld a,6
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

   ex af,af                       ; a = height
   dec a
   jp nz, rowloop

   ret
