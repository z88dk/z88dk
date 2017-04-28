INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_threads

PUBLIC __thread_critical_section_begin

IFDEF __Z80

   EXTERN asm_z80_push_di
   defc __thread_critical_section_begin = asm_z80_push_di

ENDIF

IFDEF __Z180

   EXTERN asm_z180_push_di
   defc __thread_critical_section_begin = asm_z180_push_di

ENDIF
