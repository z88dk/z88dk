INCLUDE "config_private.inc"

SECTION code_env

PUBLIC __ef_esxdos_jp_size

EXTERN asm_im2_push_registers
EXTERN asm_im2_pop_registers

; return file size capped to 65534
;
; enter :  ix-3  (optional) write error code here
;          ix-5  file handle
;
; exit  : if successful
;
;            hl = capped file size
;            carry reset
;
;         if unsuccessful
;
;            carry set, ix-3=error code
;
; uses  : all registers preserved except flags

__ef_esxdos_jp_size:

   call asm_im2_push_registers  ; push all registers

   ld a,(ix-5)                  ; a = file handle
   
   ld hl,-16                    ; sizeof struct stat is 11
   add hl,sp
   ld sp,hl
   
   push hl
   pop ix
   
   rst  __ESXDOS_SYSCALL
   defb __ESXDOS_SYS_F_FSTAT
   
   pop bc
   pop de                       ; debc = file size
   
   jr c, error
   
   ld hl,16-4
   add hl,sp
   ld sp,hl

   ld a,d
   or e
   jr nz, cap
   
   ld a,b
   and c
   inc a
   jr nz, nocap
   
cap:

   ld bc,0xfffe

nocap:

   ; change HL stored on stack by asm_im2_push_registers
   ; this is tightly coupled to that routine
   
   ld hl,18
   add hl,sp                   ; hl = &HL on stack
   
   ld (hl),c
   inc hl
   ld (hl),b                   ; store file size

   call asm_im2_pop_registers
   
   or a
   ret

error:

   ld hl,16-4
   add hl,sp
   ld sp,hl
   
   ld (ix-3),a                  ; store error code

   call asm_im2_pop_registers
   
   scf
   ret
