
; int dup_fastcall(int fd)

SECTION code_clib
SECTION code_fcntl

PUBLIC _dup_fastcall

EXTERN asm_dup

defc _dup_fastcall = asm_dup
