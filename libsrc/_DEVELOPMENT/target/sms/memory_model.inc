
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; memory model ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF __MMAP = -1

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; user supplied memory map ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   INCLUDE "mmap.inc"

ENDIF

IF __MMAP = 0

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; standard CODE/DATA/BSS memory map ;;;;;;;;;;;;;;;;;;;;;;;
   ;; sms rom banks mapped to 0x8000    ;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   INCLUDE "../crt_memory_model.inc"
   
   SECTION BANK_02
   org 0x8000
   
   SECTION BANK_03
   org 0x8000

   SECTION BANK_04
   org 0x8000
   
   SECTION BANK_05
   org 0x8000

   SECTION BANK_06
   org 0x8000
   
   SECTION BANK_07
   org 0x8000

   SECTION BANK_08
   org 0x8000
   
   SECTION BANK_09
   org 0x8000
   
   SECTION BANK_0A
   org 0x8000
   
   SECTION BANK_0B
   org 0x8000

   SECTION BANK_0C
   org 0x8000
   
   SECTION BANK_0D
   org 0x8000

   SECTION BANK_0E
   org 0x8000
   
   SECTION BANK_0F
   org 0x8000

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
ENDIF

;; end memory model ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
