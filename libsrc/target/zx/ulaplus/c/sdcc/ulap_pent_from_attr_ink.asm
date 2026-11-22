; unsigned char ulap_pent_from_attr_ink(unsigned char attr)

SECTION code_clib
SECTION code_arch

PUBLIC _ulap_pent_from_attr_ink

EXTERN asm_ulap_pent_from_attr_ink

_ulap_pent_from_attr_ink:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_ulap_pent_from_attr_ink
