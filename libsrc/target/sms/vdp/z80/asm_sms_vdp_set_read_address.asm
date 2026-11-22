; void sms_vdp_set_read_address(unsigned int addr)

SECTION code_clib
SECTION code_arch

PUBLIC asm_sms_vdp_set_read_address

EXTERN asm_sms_vram_read_hl

defc asm_sms_vdp_set_read_address = asm_sms_vram_read_hl

   ; enter : hl = unsigned int addr
   ; uses  : af
