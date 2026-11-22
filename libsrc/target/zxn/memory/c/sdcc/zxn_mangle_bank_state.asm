; unsigned int zxn_mangle_bank_state(unsigned int state)

SECTION code_clib
SECTION code_arch

PUBLIC _zxn_mangle_bank_state

EXTERN asm_zxn_mangle_bank_state

_zxn_mangle_bank_state:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_zxn_mangle_bank_state
