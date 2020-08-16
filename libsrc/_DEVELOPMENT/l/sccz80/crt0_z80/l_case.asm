;       Small C+ Z80 Run time library
;       The new case statement..maybe things will work now!
;       13/10/98

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_case

l_case:

   ex de,hl                    ; de = switch value
   pop hl                      ; hl = & switch_table

loop:

   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = & case_code or 0
   inc hl
   
   ld a,b
   or c
   jr z, end                   ; default or continuation code
   
   ld a,(hl)
   inc hl
   
   cp e
   
   ld a,(hl)
   inc hl
   
   jr nz, loop
   
   cp d
   jr nz, loop
   
   ld h,b
   ld l,c                      ; cases matched
   
end:

   jp (hl)
