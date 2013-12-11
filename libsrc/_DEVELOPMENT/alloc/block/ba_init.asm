
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void ba_init(int num)
;
; Clear all queues to empty.
;
; ===============================================================

INCLUDE "../../crt_vars.inc"

XLIB ba_init
XDEF asm_ba_init

LIB asm_memset

ba_init:
asm_ba_init:

   ; enter : hl = number of queues
   ;
   ; exit  : none
   ;
   ; uses  :
   
   add hl,hl
   ld c,l
   ld b,h                      ; bc = sizeof qtbl in bytes
   
   ld hl,(__qtbl)
   ld e,0
   jp asm_memset
