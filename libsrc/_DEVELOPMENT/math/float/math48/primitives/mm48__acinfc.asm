
SECTION code_fp_math48

PUBLIC mm48__acinfc, mm48__acpinfc, mm48__acminfc

mm48__acinfc:

   ; Set AC = huge val, sign depends on B
   ; Set carry flag
   
   bit 7,b
   jr z, mm48__acpinfc

mm48__acminfc:

   call mm48__acpinfc
   
   set 7,b
   ret

mm48__acpinfc:

   ; Set AC = + huge_val 
   ; Set carry flag
   
   ld bc,$7fff
   ld e,c
   ld d,c
   ld h,c
   ld l,c
   scf
   ret
