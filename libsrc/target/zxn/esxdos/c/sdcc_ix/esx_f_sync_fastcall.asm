; unsigned char esx_f_sync(unsigned char handle)

SECTION code_esxdos

PUBLIC _esx_f_sync_fastcall

EXTERN asm_esx_f_sync

defc _esx_f_sync_fastcall = asm_esx_f_sync
