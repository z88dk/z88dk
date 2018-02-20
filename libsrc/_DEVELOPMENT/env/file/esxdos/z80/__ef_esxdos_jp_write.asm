INCLUDE "config_private.inc"

SECTION code_env

PUBLIC __ef_esxdos_jp_write

EXTERN asm_im2_push_registers
EXTERN asm_im2_pop_registers

; write to file
;
; enter :  hl = void *src
;          bc = len > 0
;
;          ix-3  (optional) write error code here
;          ix-5  file handle
;
; exit  : if successful
;
;            carry reset
;
;         if unsuccessful
;
;            carry set, ix-3=error code
;
; uses  : all registers preserved except flags

__ef_esxdos_jp_write:

   ex de,hl
   call asm_im2_push_registers  ; push all registers
   
   ex de,hl                     ; hl = void *src
   ld a,(ix-5)                  ; a = file handle
   
   push hl
   pop ix
   
   rst  __ESXDOS_SYSCALL
   defb __ESXDOS_SYS_F_WRITE
   
   jr c, error

   call asm_im2_pop_registers
   ex de,hl
   
   or a
   ret

error:

   ld (ix-3),a                  ; store error code
   
   call asm_im2_pop_registers
   ex de,hl
   
   scf
   ret
