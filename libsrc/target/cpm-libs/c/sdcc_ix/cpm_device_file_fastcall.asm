; FILE *cpm_device_file_fastcall(const char *name) __z88dk_fastcall

SECTION code_clib
SECTION code_arch

PUBLIC _cpm_device_file_fastcall

EXTERN asm_cpm_device_file

defc _cpm_device_file_fastcall = asm_cpm_device_file
