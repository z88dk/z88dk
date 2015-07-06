
; uint32_t _random_uniform_xor_32__fastcall(uint32_t seed)

SECTION code_stdlib

PUBLIC __random_uniform_xor_32__fastcall

EXTERN asm_random_uniform_xor_32

defc __random_uniform_xor_32__fastcall = asm_random_uniform_xor_32
