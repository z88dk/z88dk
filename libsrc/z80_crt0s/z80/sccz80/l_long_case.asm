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
 
IF CPU_INTEL
   jp z, end                   ; if end of table
ELSE  
   jr z, end                   ; if end of table
ENDIF
   
   ld a,(hl)
   inc hl
   
   cp c
IF CPU_INTEL
   jp nz, loop_3
ELSE
   jr nz, loop_3
ENDIF
   
   ld a,(hl)
   inc hl
   
   cp b
IF CPU_INTEL
   jp nz, loop_2
ELSE
   jr nz, loop_2
ENDIF
   
   ld a,(hl)
   inc hl
   
   cp e
IF CPU_INTEL
   jp nz, loop_1
ELSE
   jr nz, loop_1
ENDIF
   
   ld a,(hl)
   inc hl
   
   cp d
IF CPU_INTEL
   jp nz, loop
ELSE
   jr nz, loop
ENDIF

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
IF CPU_INTEL
   jp loop
ELSE
   jr loop
ENDIF
