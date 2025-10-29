; unsigned char ulap_pent_from_attr_ink(unsigned char attr)

SECTION code_clib
SECTION code_arch

PUBLIC ulap_pent_from_attr_ink

EXTERN asm_ulap_pent_from_attr_ink

defc ulap_pent_from_attr_ink = asm_ulap_pent_from_attr_ink
