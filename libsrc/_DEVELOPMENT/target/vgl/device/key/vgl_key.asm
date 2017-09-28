INCLUDE "config_private.inc"

;SECTION data_clib
;SECTION data_vgl_keyboard
SECTION code_driver

PUBLIC vgl_key_arm
PUBLIC vgl_key_peek
PUBLIC vgl_key_get


vgl_key_arm:
   push af
   
   ; Prepare next getkey
   ld a, 0xc0
   ld (__VGL_KEY_STATUS_ADDRESS), a
   
   pop af
   ret

vgl_key_peek:
   ; Check if a key was pressed.
   ; Returns ZERO if not, else: the ASCII code
   
   ; Poll the status
   ld a, (__VGL_KEY_STATUS_ADDRESS)
   ; Check if button was pressed
   cp 0xd0
   ; if not: return 0
   jr nz, vgl_key_peek_nothing
   
   ; else: Get current key
   ld a, (__VGL_KEY_CURRENT_ADDRESS)
   
   ; Prepare next
   call vgl_key_arm
   ret
   
   vgl_key_peek_nothing:
      ld a, 0x00
      ret
   

vgl_key_get:
   ; Wait for a key to be pressed
   
   call vgl_key_arm
   
   vgl_key_get_loop:
      ld a, (__VGL_KEY_STATUS_ADDRESS)
      ; Check if button was pressed
      cp 0xd0
      ; Loop if nothing pressed
      jr nz, vgl_key_get_loop
   
   ; Get current key
   ld a, (__VGL_KEY_CURRENT_ADDRESS)
   
   ; Prepare next
   call vgl_key_arm
   
   
   ret

