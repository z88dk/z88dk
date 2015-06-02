
; =============================================================
; May 2015
; =============================================================
;
; size_t ftoe(float x, char *buf, uint16_t prec, uint16_t flag)
;
; (-d.dddde+dd)
;
; Write zero-terminated floating point number to buffer and
; return number of characters written not including '\0'
;
; If buf == 0, number of chars returned not incl '\0'
;
; =============================================================

SECTION code_stdlib

PUBLIC asm_ftoe

EXTERN __ftoe__, __ftoa_asm_exit

asm_ftoe:

   ; enter :  c = flag (bit 6='+', bit 5=' ', bit 4='#')
   ;         de = precision (clipped at 255)
   ;         hl = char *buf (0 = no write to buffer)
   ;        EXX = float x
   ;
   ; exit  : hl = number of characters written not incl '\0'
   ;         de = char *buf
   ;
   ; uses  : af, bc, de, hl, ix, af', bc', de', hl'

   ld a,c

   ld c,l
   ld b,h
   
   ld hl,-32
   add hl,sp
   ld sp,hl                    ; create 32 bytes of workspace
   
   push bc                     ; save buf
   
   ld c,a
   call __ftoe__

   ;            bc = buffer length
   ;            de = buffer *
   ;           (IX-5) = flags, bit 7='N', bit 4='#', bit 0=(precision==0), others unaffected
   ;           (IX-4) = tz (number of zeroes to append)
   ;           (IX-3) = fz (number of zeroes to insert after .)
   ;           (IX-2) = iz (number of zeroes to insert before .)
   ;           (IX-1) = ignore
   ;
   ;         if carry set, special form just output buffer with sign
   ;
   ;            stack = char *buf

   jp __ftoa_asm_exit
