; void in_MouseAMXInit(uchar xvector, uchar yvector)
; 09.2005 aralbrec

XLIB in_MouseAMXInit
LIB INMouseAMXInit

; see GMouseAMXInit.asm for comments

.in_MouseAMXInit
   ld hl,2
   add hl,sp
   ld c,(hl)
   inc hl
   inc hl
   ld b,(hl)
   jp INMouseAMXInit
