; 05.2005 aralbrec

XLIB ba_BestFit
LIB BABestFit

.ba_BestFit
   ld hl,2
   add hl,sp
   ld b,(hl)
   inc hl
   inc hl
   ld l,(hl)
   ld h,0
   jp BABestFit

; enter: HL = starting queue number
;         B = number of queues to check
; exit : HL = address of memory block (0 = fail)
;        Carry = success
