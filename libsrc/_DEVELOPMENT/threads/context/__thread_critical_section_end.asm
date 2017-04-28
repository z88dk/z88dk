INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_threads

PUBLIC __thread_critical_section_end

IFDEF __Z80

   EXTERN asm_z80_pop_ei
   defc __thread_critical_section_end = asm_z80_pop_ei

ENDIF

IFDEF __Z180

   EXTERN asm_z180_pop_ei
   defc __thread_critical_section_end = asm_z180_pop_ei

ENDIF
