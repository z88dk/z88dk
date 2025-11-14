; unsigned char ulap_pent_from_attr_paper(unsigned char attr)

SECTION code_clib
SECTION code_arch

PUBLIC _ulap_pent_from_attr_paper_fastcall

EXTERN asm_ulap_pent_from_attr_paper

defc _ulap_pent_from_attr_paper_fastcall = asm_ulap_pent_from_attr_paper
