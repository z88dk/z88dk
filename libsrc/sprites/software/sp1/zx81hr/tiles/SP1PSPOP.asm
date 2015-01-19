; subroutine for reading the contents of a "struct sp1_pss" into registers
; 02.2008 aralbrec
; zx81 hi-res version

PUBLIC SP1PSPOP
EXTERN SP1V_TEMP_IX

; enter : de  = & string to print (or something else)
;         hl  = & struct sp1_pss to read
;
; exit  : de' = & struct sp1_update
;          e  = flags
;          c  = y coordinate
;          b  = x coordinate
;         ix  = & bounds rectangle
;         hl  = & string to print (or something else)
; (SP1V_TEMP_IX) = & visit function

.SP1PSPOP

   ld a,(hl)
   ld ixl,a
   inc hl
   ld a,(hl)
   ld ixh,a                  ; ix = & bounds rectangle
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
   ld (SP1V_TEMP_IX),a
   inc hl
   ld a,(hl)
   ld (SP1V_TEMP_IX + 1),a   ; (SP1V_TEMP_IX) = visit function
   exx

   ret
