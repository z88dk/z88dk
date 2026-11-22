; ===============================================================
; 2018
; ===============================================================
; 
; unsigned char check_version_esxdos(uint16_t ev)
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_arch

PUBLIC asm_check_version_esxdos

EXTERN error_znc, error_mc

asm_check_version_esxdos:

   ; check if esxdos version >= ev
   ;
   ; esxdos does not have a version number yet so use 0 or 1
   ; to check if it is present.
   ;
   ; enter : hl = uint16_t ev
   ;
   ; exit  : success if minimum esxdos version met
   ;
   ;            hl = 0, carry reset
   ;
   ;         fail if minimum esxdos version not met
   ;
   ;            hl = -1, carry set
   ;
   ; uses  : af, bc, de, hl

   rst __ESX_RST_SYS
   defb __ESX_M_DOSVERSION

   jp nc, error_mc             ; if esxdos not present
   jp error_znc                ; pass
