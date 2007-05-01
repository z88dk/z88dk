; char __CALLEE__ *ltoa_callee(char *s, long num)
; convert long to string and store in s
; 04.2007 aralbrec

XLIB ltoa_callee
XDEF ASMDISP_LTOA_CALLEE
XDEF ASMDISP2_LTOA_CALLEE

LIB l_long_neg

.ltoa_callee

   pop af
   pop hl
   pop de
   pop bc
   push af

.asmentry

   ; dehl = long num
   ;   bc = char *s
   
   push bc

   bit 7,d                     ; negative num?
   jr z, notneg
   ld a,'-'                    ; write negative sign
   ld (bc),a
   inc bc
   call l_long_neg             ; make it positive, bc okay

.notneg

   push de
   exx
   pop hl
   exx
   ld de,constants
   push de
   
.skipleading0

   ; hl'hl = num
   ; bc    = char *
   ; stack = constants
   
   ex (sp),hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ex (sp),hl
   exx
   ex (sp),hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ex (sp),hl
   
   ld a,d
   or e
   exx
   or d
   or e
   jr z, writelast
   
   ; hl'hl = arg1
   ; de'de = arg2
   
   call divide
   cp '0'
   jp z, skipleading0

.write

   ;     a = ascii code of digit to write
   ;    bc = char *
   ; hl'hl = num
   ; stack = constants

   ld (bc),a
   inc bc
   
   ex (sp),hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ex (sp),hl
   exx
   ex (sp),hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ex (sp),hl
   
   ld a,d
   or e
   exx
   or d
   or e
   jr z, writelast
   
   ; hl'hl = arg1
   ; de'de = arg2
   
   call divide
   jp write

.writelast

   ;    hl  = remaining num
   ;    bc  = char *
   ; stack  = constants
   
   ld a,l
   add a,'0'
   ld (bc),a
   inc bc
   
   xor a
   ld (bc),a
   pop hl
   pop hl
   ret

.divide

   ld a,'0'-1

.divloop

;        hl'hl = arg1
;        de'de = arg2
; exit : hl'hl = arg1 % arg2
;           a  = ascii arg1/arg2

   inc a
   sbc hl,de
   exx
   sbc hl,de
   exx
   jr nc, divloop
   add hl,de
   exx
   adc hl,de
   exx
   ret

.constants                     ; little endian

   defw $ca00, $3b9a           ; 1,000,000,000
   defw $e100, $05f5           ;   100,000,000
   defw $9680, $0098           ;    10,000,000
   defw $4240, $000f           ;     1,000,000
   defw $86a0, $0001           ;       100,000
   defw $2710, $0000           ;        10,000
   defw $03e8, $0000           ;         1,000
   defw $0064, $0000           ;           100
   defw $000a, $0000           ;            10
   defw $0000, $0000           ; end of table

DEFC ASMDISP_LTOA_CALLEE = asmentry - ltoa_callee
DEFC ASMDISP2_LTOA_CALLEE = notneg - ltoa_callee

