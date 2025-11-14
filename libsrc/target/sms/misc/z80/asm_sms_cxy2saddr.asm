; ===============================================================
; 2017
; ===============================================================
; 
; unsigned int sms_cxy2saddr(unsigned char x, unsigned char y)
;
; Return address of character at (x,y) in the screen map.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_sms_cxy2saddr

EXTERN _GLOBAL_SMS_VRAM_SCREEN_MAP_ADDRESS

asm_sms_cxy2saddr:

   ; enter : h = y coord
   ;         l = x coord
   ;
   ; exit  : hl = screen map address
   ;
   ; uses  : f, bc, hl
   
   ld c,l
   ld b,0
   ld l,h
   ld h,b
   
   add hl,hl
   add hl,hl
   add hl,hl
   add hl,hl
   add hl,hl
   
   add hl,bc
   add hl,hl                   ; hl = 64*y + 2*x
   
   ld bc,(_GLOBAL_SMS_VRAM_SCREEN_MAP_ADDRESS)
   add hl,bc
   
   ret
