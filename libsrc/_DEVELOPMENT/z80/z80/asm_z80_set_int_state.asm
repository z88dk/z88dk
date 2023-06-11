
; ===============================================================
; Stefano Bodrato
; ===============================================================
;
; void z80_set_int_state(unsigned int state)
;
; Set the ei/di status previously retrieved.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_z80

PUBLIC asm_z80_set_int_state
PUBLIC asm_cpu_set_int_state

asm_z80_set_int_state:
asm_cpu_set_int_state:

   ; enter : l = ei/di status
   ;
   ; uses  : f

IF __CPU_R2KA__ | __CPU_R3K__

   push hl
   pop ip
   inc sp
   ret

ELSE

IF __CPU_8085__

   and $80                     ; isolate IE bit

ELSE

   IF __Z80 & __Z80_NMOS
   
      bit 0,l                  ; check carry flag
   
   ELSE
   
      bit 2,l                  ; check p/v flag
   
   ENDIF

ENDIF

   jr Z, di_state

ei_state:

   ei
   ret

di_state:

   di
   ret

ENDIF
