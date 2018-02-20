INCLUDE "config_private.inc"

SECTION code_env

PUBLIC __ef_esxdos_jp_seek

EXTERN asm_im2_push_registers
EXTERN asm_im2_pop_registers

; seek file
;
; enter :  bc = file position
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

__ef_esxdos_jp_seek:

   call asm_im2_push_registers  ; push all registers

   ld a,(ix-5)                  ; a = file handle
   
   ld e,c
   ld d,b
   ld bc,0                      ; bcde = seek position
   
   ld l,__ESXDOS_SEEK_SET
   
   push hl
   pop ix
   
   rst  __ESXDOS_SYSCALL
   defb __ESXDOS_SYS_F_SEEK
   
   jr c, error

   call asm_im2_pop_registers
   
   or a
   ret

error:

   ld (ix-3),a                  ; store error code
   
   call asm_im2_pop_registers
   
   scf
   ret
