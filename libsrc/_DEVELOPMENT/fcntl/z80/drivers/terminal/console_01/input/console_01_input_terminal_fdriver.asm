
INCLUDE "clib_cfg.asm"

SECTION seg_code_fcntl

PUBLIC console_01_input_terminal_fdriver

EXTERN l_jpix

console_01_input_terminal_fdriver:

   ; First call to the driver from either FILE* or file descriptor.
   ; The purpose here is to lock the FDSTRUCT, move & FDSTRUCT.JP
   ; into ix and then to forward to the main driver.
   
   ex (sp),ix                  ; ix = & FDSTRUCT.JP
   
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   IF _CLIB_OPT_MULTITHREAD & $10
   
   EXTERN asm_mtx_lock, error_enolck_zc
   
   push af
   push bc
   push de
   push hl
   
   call mutex_address
   call asm_mtx_lock
   
   pop hl
   pop de
   pop bc
   
   jp c, error_enolck_zc - 1   ; if lock could not be acquired
   
   pop af
   
   ENDIF
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   call l_jpix                 ; forward to main driver
   
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   IF _CLIB_OPT_MULTITHREAD & $10

   push af
   push bc
   push de
   push hl
   
   call mutex_address
   call asm_mtx_lock
   
   pop hl
   pop de
   pop bc
   pop af
   
   ENDIF
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   pop ix                      ; restore ix
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF _CLIB_OPT_MULTITHREAD & $10
   
mutex_address:

   push ix
   pop hl                      ; hl = & FDSTRUCT.JP
   
   ld de,8
   add hl,de                   ; hl = & FDSTRUCT.mutex
   
   ret   
   
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
