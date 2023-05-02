
;
; QSORT - compiled, then hand-adjusted
; Stefano, 29/10/2010
;
; $Id: qsort_callee.asm $
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

SECTION code_clib
PUBLIC qsort_sccz80_callee
PUBLIC _qsort_sccz80_callee
PUBLIC qsort_sccz80_enter

EXTERN   l_mult
EXTERN l_le
EXTERN memswap_callee
EXTERN l_setix, l_jpix


.qsort_sccz80_callee
._qsort_sccz80_callee
   pop   af

IF __CPU_GBZ80__ || __CPU_INTEL__
	pop	hl	; *compar
    call l_setix
ELSE
	pop	ix	; *compar
ENDIF

   pop   hl ; width
   pop de   ; nel
   pop bc   ; base
   
   ; __CALLEE__
   push af

qsort_sccz80_enter:

   push de  ; ngap
   push hl ;width

IF __CPU_GBZ80__ || __CPU_INTEL__

   push hl
IF __CPU_GBZ80__
   ld hl,_base
   ld (hl),bc
ELSE
   ld h,b
   ld l,c
   ld (_base),hl
ENDIF
   pop hl

ELSE
   ld (_base),bc
ENDIF

   ; t1 = nel * width;
   call  l_mult

IF __CPU_GBZ80__
   ld de,_t1
   ex de,hl
   ld (hl),de   
ELSE
   ld (_t1),hl
ENDIF

   ; for (ngap = nel / 2; ngap > 0; ngap /= 2) {
.i_3
   pop de   ; width
   pop hl  ; ngap

IF __CPU_GBZ80__ || __CPU_INTEL__
   ld a,h
   and a
   rra
   ld h,a
   ld a,l
   rra
   ld l,a
   or h
ELSE
   srl h       ; _ngap/2 ..bit rotation
   rr  l
   ld a,h
   or l
ENDIF

   ret z
   push hl ; ngap
   push de  ; width
   
   ; gap = ngap * width;
   ;ld d,h
   ;ld e,l
   ;ld   hl,(_width)
   call  l_mult

IF __CPU_GBZ80__
   ld de,_gap
   ex de,hl
   ld (hl),de   
   ex de,hl
ELSE
   ld (_gap),hl
ENDIF

   ; t2 = gap + width;

   pop de	; width
   push de

   push hl
   ;ex   de,hl
   ;ld   hl,(_width)
   add   hl,de


IF __CPU_GBZ80__
   ld de,_t2
   ex de,hl
   ld (hl),de
   ex de,hl
ELSE
   ld (_t2),hl
ENDIF

   ; jd = (unsigned int) base + gap;
IF __CPU_GBZ80__
   ld a,(_base)
   ld e,a
   ld a,(_base+1)
   ld d,a
ELSE
   ld de,(_base)
ENDIF
   ex (sp),hl     ; retrieve 'gap'
   add   hl,de
IF __CPU_GBZ80__
   ld de,_jd
   ex de,hl
   ld (hl),de
   ex de,hl
ELSE
   ld (_jd),hl
ENDIF
   pop hl         ; t2
   jr i_8
   
.i_6
IF __CPU_GBZ80__
   ld a,(_i)
   ld e,a
   ld a,(_i+1)
   ld d,a
ELSE
   ld de,(_i)
ENDIF
   pop hl
   push hl
   ;ld   hl,(_width)
   add   hl,de
   ;ld   (_i),hl

   ; for (i = t2 ....
.i_8
IF __CPU_GBZ80__
   ld de,_i
   ex de,hl
   ld (hl),de
   ex de,hl
ELSE
   ld (_i),hl
ENDIF
IF __CPU_GBZ80__
   ld a,(_t1)
   ld e,a
   ld a,(_t1+1)
   ld d,a
ELSE
   ld de,(_t1)
ENDIF
   ex de,hl
   call  l_le
   jr nc,i_3

   ; for (j =  i - t2..
IF __CPU_GBZ80__
   ld a,(_i)
   ld e,a
   ld a,(_i+1)
   ld d,a
ELSE
   ld de,(_i)
ENDIF

IF __CPU_GBZ80__
   ld a,(_t2)
   ld l,a
   ld a,(_t2+1)
   ld h,a
ELSE
   ld hl,(_t2)
ENDIF

.i_11
   ex de,hl    ; same subtraction is used twice in the for loop
   and   a
   sbc   hl,de

IF __CPU_GBZ80__
   ld de,_j
   ex de,hl
   ld (hl),de
   ex de,hl
ELSE
   ld (_j),hl
ENDIF

   ; for ..; j>0; ..
IF __CPU_GBZ80__
   jp c,i_6          ; ********  WARNING, THIS IS AN UNTESTED REPLACEMENT FOR THE MISSING 'S' FLAG ON GAMEBOY
ELSE
   jp m,i_6
ENDIF
   
IF !__CPU_GBZ80__ && !__CPU_INTEL__
   push ix
ENDIF
   
   ; 1st arg:  base+j
IF __CPU_GBZ80__
   ld a,(_base)
   ld e,a
   ld a,(_base+1)
   ld d,a
ELSE
   ld de,(_base)
ENDIF

   ;ld   hl,(_j)
   push hl
   add   hl,de
   ex (sp),hl  ; j <--> base+j
   
   ; 2nd arg: jd+j
IF __CPU_GBZ80__
   ld a,(_jd)
   ld e,a
   ld a,(_jd+1)
   ld d,a
ELSE
   ld de,(_jd)
ENDIF
   add   hl,de
   push  hl

   call l_jpix     ; compare function

   pop bc      ; we're keeping the same args for the next call !
   pop de
   
IF !__CPU_GBZ80__ && !__CPU_INTEL__
   pop ix
ENDIF

   ; if ((*compar)(base+j, jd+j) <=0) break;
   dec hl
IF __CPU_GBZ80__ || __CPU_INTEL__
   ld a,10000000b
   and h
ELSE
   bit 7,h
ENDIF
   jr nz,i_6   ; Negative sign ?   exit loop

   
   pop hl      ; width
   push hl
   
   push de  ; 1st arg:  base+j
   push bc ; 2nd arg: jd+j
   push hl ; width

   call  memswap_callee

   ; for ... j -= gap)
IF __CPU_GBZ80__
   ld a,(_j)
   ld e,a
   ld a,(_j+1)
   ld d,a
ELSE
   ld de,(_j)
ENDIF

IF __CPU_GBZ80__
   ld a,(_gap)
   ld l,a
   ld a,(_gap+1)
   ld h,a
ELSE
   ld hl,(_gap)
ENDIF

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
