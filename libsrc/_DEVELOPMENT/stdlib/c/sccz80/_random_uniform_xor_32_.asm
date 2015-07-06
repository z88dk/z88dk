
; uint32_t _random_uniform_xor_32_(uint32_t seed)

SECTION code_stdlib

PUBLIC _random_uniform_xor_32_

EXTERN asm_random_uniform_xor_32

defc _random_uniform_xor_32_ = asm_random_uniform_xor_32
