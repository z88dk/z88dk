
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
   org CRT_ORG_BANK_02
   
   SECTION BANK_03
   org CRT_ORG_BANK_03

   SECTION BANK_04
   org CRT_ORG_BANK_04
   
   SECTION BANK_05
   org CRT_ORG_BANK_05

   SECTION BANK_06
   org CRT_ORG_BANK_06
   
   SECTION BANK_07
   org CRT_ORG_BANK_07

   SECTION BANK_08
   org CRT_ORG_BANK_08
   
   SECTION BANK_09
   org CRT_ORG_BANK_09
   
   SECTION BANK_0A
   org CRT_ORG_BANK_0A
   
   SECTION BANK_0B
   org CRT_ORG_BANK_0B

   SECTION BANK_0C
   org CRT_ORG_BANK_0C
   
   SECTION BANK_0D
   org CRT_ORG_BANK_0D

   SECTION BANK_0E
   org CRT_ORG_BANK_0E
   
   SECTION BANK_0F
   org CRT_ORG_BANK_0F

   SECTION BANK_10
   org CRT_ORG_BANK_10
   
   SECTION BANK_11
   org CRT_ORG_BANK_11

   SECTION BANK_12
   org CRT_ORG_BANK_12
   
   SECTION BANK_13
   org CRT_ORG_BANK_13

   SECTION BANK_14
   org CRT_ORG_BANK_14
   
   SECTION BANK_15
   org CRT_ORG_BANK_15

   SECTION BANK_16
   org CRT_ORG_BANK_16
   
   SECTION BANK_17
   org CRT_ORG_BANK_17

   SECTION BANK_18
   org CRT_ORG_BANK_18
   
   SECTION BANK_19
   org CRT_ORG_BANK_19
   
   SECTION BANK_1A
   org CRT_ORG_BANK_1A
   
   SECTION BANK_1B
   org CRT_ORG_BANK_1B

   SECTION BANK_1C
   org CRT_ORG_BANK_1C
   
   SECTION BANK_1D
   org CRT_ORG_BANK_1D

   SECTION BANK_1E
   org CRT_ORG_BANK_1E
   
   SECTION BANK_1F
   org CRT_ORG_BANK_1F

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
ENDIF

;; end memory model ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
