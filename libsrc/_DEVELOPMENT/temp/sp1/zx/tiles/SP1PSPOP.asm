; subroutine for reading the contents of a "struct sp1_pss" into registers
; 02.2008 aralbrec
; sinclair spectrum version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC SP1PSPOP

; enter : de  = & string to print (or something else)
;         hl  = & struct sp1_pss to read
;
; exit  : hl = & string to print (or something else)
;          e = flags
;          b = current x coordinate (relative to bounds rect IY)
;          c = current y coordinate (relative to bounds rect IY)
;        de' = current struct sp1_update *
;         b' = current attribute mask
;         c' = current colour
;         ix = visit function
;         iy = bounds rectangle

.SP1PSPOP

   ld a,(hl)
   inc hl
   ld iyl,a
   ld a,(hl)
   inc hl
   ld iyh,a                  ; iy = bounds rectangle
   ld a,(hl)                 ; a = flags
   inc hl
   ld b,(hl)                 ; b = x coordinate
   inc hl
   ld c,(hl)                 ; c = y coordinate
   inc hl
   push hl
   ex de,hl                  ; hl = string
   ld e,a                    ; e = flags
   exx
   pop hl
   ld b,(hl)                 ; b' = attr mask
   inc hl
   ld c,(hl)                 ; c' = attr
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)                 ; de = & struct sp1_update
   inc hl
   ld a,(hl)
   ld ixl,a
   inc hl
   ld a,(hl)
   ld ixh,a                  ; ix = visit function
   exx

   ret
