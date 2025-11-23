; void sms_vdp_init(void *vdp_register_array)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_vdp_init_fastcall

EXTERN asm_sms_vdp_init

_sms_vdp_init_fastcall:

   di
   
   call asm_sms_vdp_init
   
   ei
   ret
