; void sms_vdp_set_read_address(unsigned int addr)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_vdp_set_read_address

EXTERN asm_sms_vdp_set_read_address

_sms_vdp_set_read_address:

   pop af
   pop hl

   push hl
   push af

   jp asm_sms_vdp_set_read_address
