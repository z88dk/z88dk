
; SP1IterateUpdateRect
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB SP1IterateUpdateRect
LIB SP1GetUpdateStruct, l_jpix
XREF SP1V_DISPWIDTH

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

   call SP1GetUpdateStruct       ; hl = & struct sp1_update
   ld a,c                        ; a = height

.rowloop

   push bc
   push hl                       ; save update position
   push af

.colloop

   push bc
   push hl
   call l_jpix
   pop hl
   ld bc,9
   add hl,bc
   pop bc
   djnz colloop

   pop af
   pop hl                        ; hl = & struct sp1_update same row leftmost column
   ld bc,9*SP1V_DISPWIDTH
   add hl,bc                     ; hl = & struct sp1_update next row leftmost column
   pop bc

   dec a                         ; a = height
   jp nz, rowloop

   ret
