
;
; QSORT - compiled, then hand-adjusted
; Stefano, 29/10/2010
;
; $Id: qsort_callee.asm,v 1.4 2016-03-04 23:48:13 dom Exp $
;
; Original code taken from the BDS C by Leor Zolman
;
;void qsort(char *base, unsigned int nel, unsigned int width, void *compar)
;{ int i, j;
;  unsigned gap, ngap, t1;
;  int jd, t2;
;
;  t1 = nel * width;
;  for (ngap = nel / 2; ngap > 0; ngap /= 2) {
;     gap = ngap * width;
;     t2 = gap + width;
;     jd = (unsigned int) base + gap;
;     for (i = t2; i <= t1; i += width)
;        for (j =  i - t2; j >= 0; j -= gap) {
;     if ((*compar)(base+j, jd+j) <=0) break;
;         memswap(base+j, jd+j, width);
;        }
;  }
;}


PUBLIC qsort_sccz80_callee
PUBLIC _qsort_sccz80_callee
PUBLIC qsort_sccz80_enter

EXTERN   l_mult
EXTERN l_le
EXTERN memswap_callee


.qsort_sccz80_callee
._qsort_sccz80_callee
   pop   af
   pop   ix ; *compar
   pop   hl ; width
   pop de   ; nel
   pop bc   ; base
   
   ; __CALLEE__
   push af

qsort_sccz80_enter:

   push de  ; ngap
   push hl ;width
   ld (_base),bc

   ; t1 = nel * width;
   call  l_mult
   ld (_t1),hl

   ; for (ngap = nel / 2; ngap > 0; ngap /= 2) {
.i_3
   pop de   ; width
   pop hl  ; ngap
   srl h       ; _ngap/2 ..bit rotation
   rr  l
   ld a,h
   or l

   ret z
   push hl ; ngap
   push de  ; width
   
   ; gap = ngap * width;
   ;ld d,h
   ;ld e,l
   ;ld   hl,(_width)
   call  l_mult
   ld (_gap),hl
   ; t2 = gap + width;

   pop de
   push de

   push hl
   ;ex   de,hl
   ;ld   hl,(_width)
   add   hl,de
   ld (_t2),hl

   ; jd = (unsigned int) base + gap;
   ld de,(_base)
   ex (sp),hl     ; retrieve 'gap'
   add   hl,de
   ld (_jd),hl
   pop hl         ; t2
   jr i_8
   
.i_6
   ld de,(_i)
   pop hl
   push hl
   ;ld   hl,(_width)
   add   hl,de
   ;ld   (_i),hl

   ; for (i = t2 ....
.i_8
   ld (_i),hl
   ld de,(_t1)
   ex de,hl
   call  l_le
   jr nc,i_3

   ; for (j =  i - t2..
   ld de,(_i)
   ld hl,(_t2)

.i_11
   ex de,hl    ; same subtraction is used twice in the for loop
   and   a
   sbc   hl,de
   ld (_j),hl

   ; for ..; j>0; ..
   jp m,i_6
   
   push ix
   
   ; 1st arg:  base+j
   ld de,(_base)
   ;ld   hl,(_j)
   push hl
   add   hl,de
   ex (sp),hl  ; j <--> base+j
   
   ; 2nd arg: jd+j
   ld de,(_jd)
   add   hl,de
   push  hl

   ld bc,ret_addr
   push bc
   jp (ix)     ; compare function
.ret_addr

   pop bc      ; we're keeping the same args for the next call !
   pop de
   
   pop ix

   ; if ((*compar)(base+j, jd+j) <=0) break;
   dec hl
   bit 7,h
   jr nz,i_6   ; Negative sign ?   exit loop

   
   pop hl      ; width
   push hl
   
   push de  ; 1st arg:  base+j
   push bc ; 2nd arg: jd+j
   push hl ; width

   call  memswap_callee

   ; for ... j -= gap)
   ld de,(_j)
   ld hl,(_gap)
   jr i_11

SECTION bss_clib

._i   defs  2
._j   defs  2
._t1  defs  2
._t2  defs  2
._jd  defs  2
;._width defs  2
._base   defs  2
; ._ngap defs  2
._gap defs  2
