
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

   SECTION BANK_10
   org 0x8000
   
   SECTION BANK_11
   org 0x8000

   SECTION BANK_12
   org 0x8000
   
   SECTION BANK_13
   org 0x8000

   SECTION BANK_14
   org 0x8000
   
   SECTION BANK_15
   org 0x8000

   SECTION BANK_16
   org 0x8000
   
   SECTION BANK_17
   org 0x8000

   SECTION BANK_18
   org 0x8000
   
   SECTION BANK_19
   org 0x8000
   
   SECTION BANK_1A
   org 0x8000
   
   SECTION BANK_1B
   org 0x8000

   SECTION BANK_1C
   org 0x8000
   
   SECTION BANK_1D
   org 0x8000

   SECTION BANK_1E
   org 0x8000
   
   SECTION BANK_1F
   org 0x8000

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
ENDIF

;; end memory model ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
