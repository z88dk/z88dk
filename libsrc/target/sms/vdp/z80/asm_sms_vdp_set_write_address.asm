; void sms_vdp_set_write_address(unsigned int addr)

SECTION code_clib
SECTION code_arch

PUBLIC asm_sms_vdp_set_write_address

EXTERN asm_sms_vram_write_de

defc asm_sms_vdp_set_write_address = asm_sms_vram_write_de - 1

   ; enter : hl = unsigned int addr
   ; uses  : af, de, hl
