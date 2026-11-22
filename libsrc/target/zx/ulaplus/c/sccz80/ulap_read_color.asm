; unsigned char ulap_read_color(unsigned char pent)

SECTION code_clib
SECTION code_arch

PUBLIC ulap_read_color

EXTERN asm_ulap_read_color

defc ulap_read_color = asm_ulap_read_color
