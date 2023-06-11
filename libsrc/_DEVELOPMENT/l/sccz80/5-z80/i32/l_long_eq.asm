;       Z88 Small C+ Run Time Library 
;       Long functions
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_long_eq

l_long_eq:

   ; dehl == secondary?  carry if true
   ;
   ; dehl  = primary
   ; stack = secondary, ret
   
   pop ix
   
   pop bc
   
   ld a,c
   cp l
   jr nz, notequal_0
   
   ld a,b
   cp h
   jr nz, notequal_0
   
   pop bc
   
   ld a,c
   cp e
   jr nz, notequal_1
   
   ld a,b
   cp d
   jr nz, notequal_1

equal:

   scf
	ld hl,1
   jp (ix)

notequal_0:

   pop bc

notequal_1:

   xor a
	ld l,a
	ld h,a
   jp (ix)
