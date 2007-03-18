; char __CALLEE__ *itoa_callee(char *s, int num)
; convert number to string and store in s
; 12.2006 aralbrec

XLIB itoa_callee
XDEF ASMDISP_ITOA_CALLEE

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

   ; skip leading zeroes
   
   ex de,hl                  ; de = char*, hl = int
   ld bc,10000
   call divide
   cp '0'
   jr nz, write10000
   ld bc,1000
   call divide
   cp '0'
   jr nz, write1000
   ld bc,100
   call divide
   cp '0'
   jr nz, write100
   ld c,10
   call divide
   cp '0'
   jr nz, write10
   jp write1
   
   ; have skipped any leading zeroes already
   
.write10000

   ld (de),a
   inc de
   ld bc,1000
   call divide

.write1000

   ld (de),a
   inc de
   ld bc,100
   call divide

.write100

   ld (de),a
   inc de
   ld c,10
   call divide

.write10

   ld (de),a
   inc de

.write1

   ld a,l
   add a,'0'
   ld (de),a
   inc de
   
   xor a                     ; terminate string with '\0'
   ld (de),a
   pop hl
   ret

.divide

   ld a,'0'-1
   or a
   
.divloop

   inc a
   sbc hl,bc
   jr nc, divloop
   add hl,bc
   ret

DEFC ASMDISP_ITOA_CALLEE = asmentry - itoa_callee
