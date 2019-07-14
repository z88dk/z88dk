;       Small C+ Z80 Run time library
;       13/10/98 The new case statement..maybe things will work now!
;       11/2014  Removed use of ix

                SECTION   code_crt0_sccz80
PUBLIC l_long_case

l_long_case:

   ; Case statement for longs
   ; Enter with dehl = number to check against..

   ld c,l
   ld b,h
   
   ; debc = number to check against

   pop hl                      ; hl = & switch table

loop:

   ld a,(hl)
   inc hl
   or (hl)
   inc hl
   
   jr z, end                   ; if end of table
   
   ld a,(hl)
   inc hl
   
   cp c
   jr nz, loop_3
   
   ld a,(hl)
   inc hl
   
   cp b
   jr nz, loop_2
   
   ld a,(hl)
   inc hl
   
   cp e
   jr nz, loop_1
   
   ld a,(hl)
   inc hl
   
   cp d
   jr nz, loop

   ; match
   
   ld bc,-5
   add hl,bc
   
   ld a,(hl)
   dec hl
   ld l,(hl)
   ld h,a
   
end:

   jp (hl)

loop_3:

   inc hl

loop_2:

   inc hl

loop_1:

   inc hl
   jr loop
