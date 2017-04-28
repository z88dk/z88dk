
; void z180_delay_ms_fastcall(uint ms)

SECTION code_clib
SECTION code_z180

PUBLIC _z180_delay_ms_fastcall

EXTERN asm_z180_delay_ms

defc _z180_delay_ms_fastcall = asm_z180_delay_ms
