
INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_general

PUBLIC console_01_input_terminal_fdriver

EXTERN l_jpix

console_01_input_terminal_fdriver:

   ; First call to the driver from either FILE* or file descriptor.
   ; The purpose here is to lock the FDSTRUCT, move & FDSTRUCT.JP
   ; into ix and then to forward to the main driver.
   
   ex (sp),ix                  ; ix = & FDSTRUCT.JP
   
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   IF _CLIB_OPT_MULTITHREAD & $10
   
   EXTERN asm_mtx_lock, l_offset_ix_de, driver_error_enolck_zc
   
   push af
   push bc
   push de
   push hl
   
   ld hl,8
   call l_offset_ix_de         ; hl = & FDSTRUCT.mutex

   call asm_mtx_lock
   
   pop hl
   pop de
   pop bc
   
   jp c, driver_error_enolck_zc - 1
   
   pop af
   
   ENDIF
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   call l_jpix                 ; forward to main driver
   
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   IF _CLIB_OPT_MULTITHREAD & $10

   EXTERN asm_mtx_unlock

   push af
   push bc
   push de
   push hl
   
   ld hl,8
   call l_offset_ix_de         ; hl = & FDSTRUCT.mutex

   call asm_mtx_unlock
   
   pop hl
   pop de
   pop bc
   pop af
   
   ENDIF
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   pop ix                      ; restore ix
   ret
