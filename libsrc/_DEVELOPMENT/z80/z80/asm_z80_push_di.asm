
; ===============================================================
; Stefano Bodrato
; aralbrec: accommodate nmos z80 bug
; ===============================================================
;
; void z80_push_di(void)
;
; Save the current ei/di status on the stack and disable ints.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_z80

PUBLIC asm_z80_push_di
PUBLIC asm_cpu_push_di

asm_z80_push_di:
asm_cpu_push_di:

IF __CPU_R2KA__ | __CPU_R3K__

   ipset 3


ELSE

   ; exit  : stack = ei_di_status
   ;
   ; uses  : af

   ex (sp),hl
   push hl


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
      jp PE, continue          ; carry set if ints enabled
      
      dec sp
      dec sp
      pop hl                   ; have a look at zero word underneath SP
      
      ld a,h
      or l
      jr Z, continue           ; int did not occur, ints are disabled, carry reset
      
      scf                      ; int occurred, set carry

   ELSE
   
      ; cmos z80 has no bug
      
      ld a,i

   ENDIF

ENDIF

continue:
   
   di
   
   push af
   pop hl                      ; hl = ei_di status
   
   pop af                      ; af = ret
   ex (sp),hl                  ; restore hl, push ei_di_status
   
   push af

ENDIF

   ret
