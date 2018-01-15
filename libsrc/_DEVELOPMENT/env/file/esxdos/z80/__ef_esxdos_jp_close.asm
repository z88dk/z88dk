INCLUDE "config_private.inc"

SECTION code_env

PUBLIC __ef_esxdos_jp_close

EXTERN asm_im2_push_registers
EXTERN asm_im2_pop_registers

; close the file
;
; enter : ix-5  file handle
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

__ef_esxdos_jp_close:

   call asm_im2_push_registers  ; push all registers

   ld a,(ix-5)                  ; a = file handle
   
   rst  __ESXDOS_SYSCALL
   defb __ESXDOS_SYS_F_CLOSE
   
   jr c, error
   
   call asm_im2_pop_registers
   
   or a
   ret

error:

   call asm_im2_pop_registers
   
   scf
   ret
