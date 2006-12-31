;/* Small c library, by Jeremy Dewey (jxd45@po.cwru.edu)
;   http://www.seashellinc.com/jdewey
;
;   Synopsis:
;      itoa(char* str, int number);
;
;   Description:
;      converts the number to its string representation and stores it in str,
;      returning a pointer to str.
;
;   Example:
;      char str[6];
;      itoa(str, 568);
;
;   Notes:
;
;*/

; enter : params on stack as above
; exit  : hl = char *str
;         de = address of '\0' in str

; rewritten in assembler, 12.2006 aralbrec
; enter: C params on stack as above

XLIB itoa
LIB l_deneg

.itoa

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)                 ; de = int
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                    ; hl = destination char*
   
   ; de = int
   ; hl = dest char*

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

; #include <ctype.h>
; #include <stdlib.h>
;
;char *itoa(char *str, int num) 
;{
;   int k;
;   char c, flag, *ostr;
;
;   if (num < 0) {
;      num = -num;
;      *str++ = '-';
;   }
;   k = 10000;
;   ostr = str;
;   flag = 0;
;   while (k) {
;      c = num / k;
;      if (c || k == 1 || flag) {
;         num %= k;
;         c += '0';
;         *str++ = c;
;         flag = 1;
;      }
;      k /= 10;
;   }
;   *str = '\0';
;   return ostr;
;}
