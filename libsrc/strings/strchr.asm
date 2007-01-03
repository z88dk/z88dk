; char *strchr(char *s, char c)
; return ptr of first occurrence of c in s
; 04.2001 dom

; exit :     found : hl = ptr in s where char c first found, NC flag set
;        not found : hl = 0, C flag set
; uses : asm : af, hl
;          c : af, bc, hl

XLIB strchr
XDEF ASMDISP_STRCHR

; exit : hl = pointer to first occurrence of c in s
;        carry set if no char found and hl=0

.strchr

   pop af
   pop bc
   pop hl
   push hl
   push bc
   push af
   
   ; ASM ENTRY
   ; c = char
   ; hl = char *s

.asmentry
.loop

   ld a,(hl)
   or a
   jr z, zeroret
   cp c
   ret z
   inc hl
   jp loop

.zeroret

   ld l,a
   ld h,a
   scf
   ret

DEFC ASMDISP_STRCHR = asmentry - strchr
