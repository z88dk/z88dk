; ===============================================================
; 2018
; ===============================================================
; 
; unsigned char check_version_core(uint16_t cv)
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_arch

PUBLIC asm_check_version_core

EXTERN error_znc, error_mc

asm_check_version_core:

   ; check if hardware core version >= cv
   ;
   ; enter : hl = uint16_t cv
   ;            = MmSS (major, minor, sub) in hexadecimal
   ;              v 1.10.51 would be 0x1a33
   ;
   ; exit  : success if minimum core version met
   ;
   ;            hl = 0, carry reset
   ;
   ;         fail if minimum core version not met
   ;
   ;            hl = -1, carry set
   ;
   ; uses  : af, bc, e, hl
   
   ; check for emulator
      
   ld bc,__IO_NEXTREG_REG
      
   ld a,__REG_MACHINE_ID
   out (c),a
      
   inc b
   in a,(c)
      
   cp __RMI_EMULATORS
   jp z, error_znc             ; pass if emulator
   
   ; check core version
   
   dec b
   
   ; hl = MmSS
   ; bc = IO_NEXTREG_REG

   ld e,__REG_VERSION
   out (c),e
      
   inc b
   in e,(c)                    ; e = core version major minor

   ld a,h
   cp e
   
   jp c, error_znc             ; pass if minimum < core version
   jp nz, error_mc             ; fail if minimum > core version
   
   ; check core sub version
   
   dec b
   
   ld a,__REG_SUB_VERSION
   out (c),a
      
   inc b
   in a,(c)                    ; a = core sub version
      
   cp l
   
   jp c, error_mc              ; fail if core sub version < minimum
   jp error_znc                ; pass
