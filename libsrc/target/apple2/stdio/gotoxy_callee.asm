;
;   CPM Library
;   Apple II version
;
;   void gotoxy_callee(uint x, uint y)
;
;	Stefano Bodrato - 2025
;

SECTION code_clib

PUBLIC gotoxy_callee
PUBLIC _gotoxy_callee
PUBLIC asm_gotoxy

EXTERN __console_x
EXTERN __console_y

EXTERN	a2_ctl
EXTERN	a2_sendchar


.gotoxy_callee
._gotoxy_callee

   pop hl
   pop de
   pop bc
   push hl

.asm_gotoxy

   ; c = x    e = y
   ld    b,e
   push  bc

   ld    l,7
   call  a2_ctl

   LD    A,($F396)      ; XY coordinate offset
   OR    A

   pop  hl

   ; Reverse coordinates if negative
   JP    P,no_reverse
   AND   $7F
   LD E,L
   LD L,H
   LD H,E
no_reverse:

   LD E,A
   ADD A,L
   LD L,A
   LD A,E
   ADD A,H
   
   PUSH HL
   ld    l,a
   call  a2_sendchar
   POP HL

   jp    a2_sendchar


