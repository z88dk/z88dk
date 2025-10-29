
; djm 28/2/2000

; int l_setjmp(jmp_buf *env)

SECTION code_clib
SECTION code_setjmp

PUBLIC l_setjmp
PUBLIC _l_setjmp

EXTERN error_znc

l_setjmp:
_l_setjmp:

   pop bc
   pop hl
   
   push hl
   push bc

IF !__CPU_INTEL__ && !__CPU_GBZ80__ 
   ; hl = jmp_buf *env
   ; bc = return address
 IFDEF __SDCC_IX
   push ix
 ELSE
   push iy
 ENDIF
   pop de
   
   ld (hl),e
   inc hl
   ld (hl),d
   inc hl

 IFDEF __SDCC_IX
   push iy
 ELSE
   push ix
 ENDIF
   pop de
   
   ld (hl),e
   inc hl
   ld (hl),d
ELSE
   inc hl
   inc hl
   inc hl
ENDIF
   inc hl

IF __CPU_GBZ80__
   ld a,l
   ld l,e
   ld e,a
   ld a,h
   ld h,d
   ld d,a
   ld  hl,sp+2
ELSE
   ex de,hl
   
   ld hl,2
   add hl,sp
ENDIF
   
   ex de,hl
   
   ld (hl),e        ;SP
   inc hl
   ld (hl),d
   inc hl

   ld (hl),c        ;PC
   inc hl
   ld (hl),b
   ld hl,0	;Have to return 0
IF __CPU_GBZ80__
   ld d,h
   ld e,l
ENDIF
   and a
   ret