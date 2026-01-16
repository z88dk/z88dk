; void sms_vdp_set_read_address(unsigned int addr)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_vdp_set_read_address_fastcall

EXTERN asm_sms_vdp_set_read_address

defc _sms_vdp_set_read_address_fastcall = asm_sms_vdp_set_read_address
