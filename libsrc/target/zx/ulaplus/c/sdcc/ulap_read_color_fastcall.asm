; unsigned char ulap_read_color(unsigned char pent)

SECTION code_clib
SECTION code_arch

PUBLIC _ulap_read_color_fastcall

EXTERN asm_ulap_read_color

defc _ulap_read_color_fastcall = asm_ulap_read_color
