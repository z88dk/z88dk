INCLUDE "config_private.inc"

SECTION code_env

PUBLIC __ef_esxdos_jp_open

EXTERN asm_im2_push_registers
EXTERN asm_im2_pop_registers

; open a file using the given file mode
;
; enter :  a = open mode (see __ENV_DEFINES.inc)
;
;          ix-1  char *
;          ix-2    filename
;          ix-3  (optional) write error code here
;          ix-5  store file handle here
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

__ef_esxdos_jp_open:

   call asm_im2_push_registers  ; push all registers
   
   ld b,a                       ; b = mode, compatible with esxdos
   ld a,'*'                     ; use current drive
   
   ld l,(ix-2)
   ld h,(ix-1)                  ; hl = filename
   
   push hl
   pop ix
   
   rst  __ESXDOS_SYSCALL
   defb __ESXDOS_SYS_F_OPEN
   
   jr c, error
   
   ld (ix-5),a                  ; store file handle
   
   call asm_im2_pop_registers
   
   or a
   ret

error:

   ld (ix-3),a                  ; store error code
   
   call asm_im2_pop_registers
   
   scf
   ret
