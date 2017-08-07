
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; memory map ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   INCLUDE "../crt_memory_model_z80.inc"

   SECTION BANK_00
   org CRT_ORG_BANK_00
   
   SECTION BANK_01
   org CRT_ORG_BANK_01

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

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
ENDIF

IF __MMAP = 1

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; esxdos extended dot command ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   INCLUDE "crt_memory_model_dotx.inc"

   SECTION BANK_00
   org CRT_ORG_BANK_00
   
   SECTION BANK_01
   org CRT_ORG_BANK_01

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

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
ENDIF

;; end memory model ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
