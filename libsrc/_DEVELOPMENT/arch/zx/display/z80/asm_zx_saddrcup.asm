
; ===============================================================
; Jun 2007
; ===============================================================
;
; void *zx_saddrcup(void *saddr)
;
; Modify screen address to move up one character (eight pixels)
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_saddrcup

asm_zx_saddrcup:

   ; enter : hl = screen address
   ;
   ; exit  : hl = screen address one character up
   ;         carry set if new screen address is off screen
   ;
   ; uses  : af, hl

   ld a,l
   sub $20
   ld l,a
   ret nc
   
   ld a,h
   sub $08
   ld h,a
   
   cp $40
   ret
