; void sms_vdp_init(void *vdp_register_array)

SECTION code_clib
SECTION code_arch

PUBLIC sms_vdp_init_fastcall

EXTERN asm_sms_vdp_init

sms_vdp_init_fastcall:

   di
   
   call asm_sms_vdp_init
   
   ei
   ret
