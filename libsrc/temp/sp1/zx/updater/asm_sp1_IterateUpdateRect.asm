; void __CALLEE__ sp1_IterateUpdateRect_callee(struct sp1_Rect *r, void *hook)
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_temp_sp1

PUBLIC asm_sp1_IterateUpdateRect

EXTERN asm_sp1_GetUpdateStruct, l_jpix

asm_sp1_IterateUpdateRect:

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

   call asm_sp1_GetUpdateStruct  ; hl = & struct sp1_update

.rowloop

   push bc
   push hl                       ; save update position

.colloop

   push ix
   push bc
   push hl
   call l_jpix
   pop hl
   ld bc,10
   add hl,bc
   pop bc
   pop ix
   djnz colloop

   pop hl                        ; hl = & struct sp1_update same row leftmost column
   ld bc,10*SP1V_DISPWIDTH
   add hl,bc                     ; hl = & struct sp1_update next row leftmost column
   pop bc

   dec c                         ; c = height
   jp nz, rowloop

   ret
