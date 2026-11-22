; unsigned char ulap_pent_from_attr_ink(unsigned char attr)

SECTION code_clib
SECTION code_arch

PUBLIC _ulap_pent_from_attr_ink_fastcall

EXTERN asm_ulap_pent_from_attr_ink

defc _ulap_pent_from_attr_ink_fastcall = asm_ulap_pent_from_attr_ink
