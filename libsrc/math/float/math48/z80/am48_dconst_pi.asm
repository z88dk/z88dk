
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dconst_pi

EXTERN mm48__acpi

   ; set AC = pi
   ;
   ; uses : bc, de, hl
   
defc am48_dconst_pi = mm48__acpi
