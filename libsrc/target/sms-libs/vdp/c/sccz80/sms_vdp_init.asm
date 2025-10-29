; void sms_vdp_init(void *vdp_register_array)

SECTION code_clib
SECTION code_arch

PUBLIC sms_vdp_init

EXTERN asm_sms_vdp_init

sms_vdp_init:

   di
   
   call asm_sms_vdp_init
   
   ei
   ret
