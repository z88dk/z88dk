; ===============================================================
; 2018
; ===============================================================
; 
; unsigned char check_version_nextzxos(uint16_t nv)
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_arch

PUBLIC asm_check_version_nextzxos

EXTERN error_znc, error_mc

asm_check_version_nextzxos:

   ; check if nextzxos version >= nv
   ;
   ; enter : hl = uint16_t cv
   ;            = MMmm (major, minor) in bcd
   ;              v 1.94 would be 0x0194
   ;
   ; exit  : success if minimum nextzxos version met
   ;
   ;            hl = 0, carry reset
   ;
   ;         fail if minimum nextzxos version not met
   ;
   ;            hl = -1, carry set
   ;
   ; uses  : af, bc, de, hl

   push hl
   
   rst __ESX_RST_SYS
   defb __ESX_M_DOSVERSION

   pop hl                      ; hl = cv
   
   jp c, error_mc              ; if nextzxos not present
   
   or a
   jp nz, error_mc             ; if nextzxos is in 48k mode
   
   ex de,hl
   sbc hl,de
   
   jp c, error_mc              ; if nextzxos version < minimum
   jp error_znc                ; pass
