
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; memory map ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF __MMAP = -1

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; user supplied memory map ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
ifelse(M4__MMAP,-1,`include(`./mmap.inc')')

   SECTION UNASSIGNED
   org 0

ENDIF

IF __MMAP = 0

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; standard CODE/DATA/BSS memory map ;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   INCLUDE "../crt_memory_model_z80.inc"

Z88DK_FOR(`LOOP', `0', `111',
`
   SECTION BANK_`'LOOP
   org CRT_ORG_BANK_`'LOOP
   
   SECTION BANK_`'LOOP`'_L
   org CRT_ORG_BANK_`'LOOP`'_L
   
   SECTION BANK_`'LOOP`'_H
   org CRT_ORG_BANK_`'LOOP`'_H
')

Z88DK_FOR(`LOOP', `0', `223',
`
   SECTION PAGE_`'LOOP
   org CRT_ORG_PAGE_`'LOOP
')

Z88DK_FOR(`LOOP', `0', `15',
`
   SECTION DIV_`'LOOP
   org CRT_ORG_DIV_`'LOOP
')

ifelse(M4__CRT_APPEND_MMAP,1,`include(`./mmap.inc')')

   SECTION UNASSIGNED
   org 0

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
ENDIF

IF __MMAP = 1

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; esxdos extended dot command ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   INCLUDE "crt_memory_model_dotx.inc"

Z88DK_FOR(`LOOP', `0', `111',
`
   SECTION BANK_`'LOOP
   org CRT_ORG_BANK_`'LOOP
   
   SECTION BANK_`'LOOP`'_L
   org CRT_ORG_BANK_`'LOOP`'_L
   
   SECTION BANK_`'LOOP`'_H
   org CRT_ORG_BANK_`'LOOP`'_H
')

Z88DK_FOR(`LOOP', `0', `223',
`
   SECTION PAGE_`'LOOP
   org CRT_ORG_PAGE_`'LOOP
')

Z88DK_FOR(`LOOP', `0', `15',
`
   SECTION DIV_`'LOOP
   org CRT_ORG_DIV_`'LOOP
')

ifelse(M4__CRT_APPEND_MMAP,1,`include(`./mmap.inc')')

   SECTION UNASSIGNED
   org 0

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
ENDIF

IF __MMAP = 2

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; nextos extended dot command ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   INCLUDE "crt_memory_model_dotn.inc"

Z88DK_FOR(`LOOP', `0', `111',
`
   SECTION BANK_`'LOOP
   org CRT_ORG_BANK_`'LOOP
   
   SECTION BANK_`'LOOP`'_L
   org CRT_ORG_BANK_`'LOOP`'_L
   
   SECTION BANK_`'LOOP`'_H
   org CRT_ORG_BANK_`'LOOP`'_H
')

Z88DK_FOR(`LOOP', `0', `223',
`
   SECTION PAGE_`'LOOP
   org CRT_ORG_PAGE_`'LOOP
')

Z88DK_FOR(`LOOP', `0', `15',
`
   SECTION DIV_`'LOOP
   org CRT_ORG_DIV_`'LOOP
')

ifelse(M4__CRT_APPEND_MMAP,1,`include(`./mmap.inc')')

   SECTION UNASSIGNED
   org 0

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
ENDIF

;; end memory model ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
