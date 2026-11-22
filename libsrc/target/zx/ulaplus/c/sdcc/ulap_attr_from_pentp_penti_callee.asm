; unsigned char ulap_attr_from_pentp_penti(unsigned char pentp,unsigned char penti)

SECTION code_clib
SECTION code_arch

PUBLIC _ulap_attr_from_pentp_penti_callee

EXTERN asm_ulap_attr_from_pentp_penti

_ulap_attr_from_pentp_penti_callee:

   pop hl
   ex (sp),hl

   jp asm_ulap_attr_from_pentp_penti
