; void sms_vdp_init(void *vdp_register_array)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_vdp_init

EXTERN _sms_vdp_init_fastcall

_sms_vdp_init:

   pop af
   pop hl
   
   push hl
   push af
   
   jp _sms_vdp_init_fastcall
