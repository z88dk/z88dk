; unsigned char ulap_pent_from_attr_paper(unsigned char attr)

SECTION code_clib
SECTION code_arch

PUBLIC _ulap_pent_from_attr_paper

EXTERN asm_ulap_pent_from_attr_paper

_ulap_pent_from_attr_paper:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_ulap_pent_from_attr_paper
