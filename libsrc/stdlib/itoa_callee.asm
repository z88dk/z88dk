; char __CALLEE__ *itoa_callee(char *s, int num)
; convert int to string and store in s
; 12.2006 aralbrec

XLIB itoa_callee
XDEF ASMDISP_ITOA_CALLEE
XDEF ASMDISP2_ITOA_CALLEE

LIB l_deneg

.itoa_callee

   pop hl
   pop de
   ex (sp),hl
   
   ; enter : de = int num
   ;         hl = char *s
   ; exit  : hl = char *s
   ;         de = addr of terminating '\0' in s
   ; uses  : af, bc, de

.asmentry

   push hl
   
   bit 7,d                   ; is num negative?
   jr z, notneg
   ld (hl),'-'               ; write negative sign
   inc hl
   call l_deneg              ; negate number

.notneg

   ex de,hl
   ld bc,constants
   push bc
   
   ; de = char *
   ; hl = int
   ; stack = constants

.skipleading0

   ex (sp),hl                  ; hl = & constant
   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = constant
   
   ld a,b
   or c
   jr z, write1                ; if constant == 0, reached end
   
   inc hl
   ex (sp),hl                  ; hl = int, stack = & next constant
   
   call divide                 ; a = hl/bc + '0', hl = hl%bc
   cp '0'
   jp z, skipleading0

.write

   ld (de),a                   ; write digit into string
   inc de
   
   ex (sp),hl
   ld c,(hl)
   inc hl
   ld b,(hl)
   
   ld a,b
   or c
   jr z, write1

   inc hl
   ex (sp),hl

   call divide
   jp write

.write1                        ; reached 1s position, write out last digit

   pop hl                      ; hl = int
   ld a,l
   add a,'0'
   ld (de),a                   ; write last digit
   inc de
   
   xor a                       ; terminate string with '\0'
   ld (de),a
   
   pop hl                      ; hl = char *s
   ret

.divide

   ld a,'0'-1
   
.divloop

   inc a
   sbc hl,bc
   jr nc, divloop
   add hl,bc
   ret

.constants

   defw 10000, 1000, 100, 10, 0

DEFC ASMDISP_ITOA_CALLEE = asmentry - itoa_callee
DEFC ASMDISP2_ITOA_CALLEE = notneg - itoa_callee

