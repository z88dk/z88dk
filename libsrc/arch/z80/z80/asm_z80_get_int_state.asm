; ===============================================================
; Stefano Bodrato
; aralbrec: accommodate nmos z80 bug
; ===============================================================
;
; unsigned char z80_get_int_state(void)
;
; Retrieve the current ei/di status.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_z80

PUBLIC asm_z80_get_int_state
PUBLIC asm_cpu_get_int_state

asm_z80_get_int_state:
asm_cpu_get_int_state:

   ; exit  : l = ei/di status
   ;
   ; uses  : af, hl

IF  __CPU_RABBIT__

   push ip
   dec sp
   pop hl
   ld l,h
   ret

ELSE

IF __CPU_8085__

   rim

ELSE

   IF __Z80 & __Z80_NMOS
   
      ; nmos z80 bug prevents use of "ld a,i" to gather IFF2 into p/v flag
      ; see http://www.z80.info/zip/ZilogProductSpecsDatabook129-143.pdf
      
      ; this is zilog's suggested solution, note status in carry flag not p/v
      
      ld hl,0
      
      push hl
      pop hl                   ; zero written underneath SP
      
      scf
      
      ld a,i
      jp pe, continue          ; carry set if ints enabled
      
      dec sp
      dec sp
      pop hl                   ; have a look at zero word underneath SP
      
      ld a,h
      or l
      jr z, continue           ; int did not occur, ints are disabled, carry reset
      
      scf                      ; int occurred, set carry

   ELSE
   
      ; cmos z80 has no bug
      
      ld a,i

   ENDIF

ENDIF

continue:
   
   push af
   pop hl

   ret

ENDIF
