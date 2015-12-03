
SECTION code_clib
SECTION code_fp_math48

PUBLIC mm48__acpi

mm48__acpi:

   ; set AC = pi

   ld bc,$490F
   ld de,$DAA2
   ld hl,$2182

   ret
