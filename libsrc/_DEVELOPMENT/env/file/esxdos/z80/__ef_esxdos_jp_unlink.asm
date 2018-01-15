INCLUDE "config_private.inc"

SECTION code_env

PUBLIC __ef_esxdos_jp_unlink

EXTERN asm_im2_push_registers
EXTERN asm_im2_pop_registers

; remove the file
;
; enter : ix-1  char *
;         ix-2     filename
;
; exit  : if successful
;
;            carry reset
;
;         if unsuccessful
;
;            carry set
;
; uses  : all registers preserved except flags

__ef_esxdos_jp_unlink:

   call asm_im2_push_registers  ; push all registers

   ld a,'*'
   
   ld l,(ix-2)
   ld h,(ix-1)                  ; hl = char *filname
   
   push hl
   pop ix
   
   rst  __ESXDOS_SYSCALL
   defb __ESXDOS_SYS_F_UNLINK
   
   jr c, error

   call asm_im2_pop_registers
   
   or a
   ret

error:

   call asm_im2_pop_registers
   
   scf
   ret
