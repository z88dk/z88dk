; subroutine for reading the contents of a "struct sp1_pss" into registers
; 02.2008 aralbrec
; ts2068 hi-res version

PUBLIC SP1PSPOP

; enter : de  = & string to print (or something else)
;         hl  = & struct sp1_pss to read
;
; exit  : hl = address of string to print
;          e = flags (bit 0 = invalidate?, bit 1 = xwrap?, bit 2 = yinc?, bit3 = ywrap?)
;          b = current x coordinate (relative to bounds rect IY)
;          c = current y coordinate (relative to bounds rect IY)
;        de' = current struct sp1_update *
;         ix = visit function
;         iy = bounds rectangle

.SP1PSPOP

   ld a,(hl)
   ld iyl,a
   inc hl
   ld a,(hl)
   ld iyh,a                  ; iy = & bounds rectangle
   inc hl
   ld a,(hl)                 ; a = flags
   inc hl
   ld b,(hl)                 ; b = x coordinate
   inc hl
   ld c,(hl)                 ; c = y coordinate
   inc hl
   push hl
   ex de,hl                  ; hl = & string
   ld e,a                    ; e = flags
   exx
   pop hl
   ld e,(hl)
   inc hl
   ld d,(hl)                 ; de' = & struct sp1_update
   inc hl
   ld a,(hl)
   ld ixl,a
   inc hl
   ld a,(hl)
   ld ixh,a                  ; ix = visit function
   exx

   ret
