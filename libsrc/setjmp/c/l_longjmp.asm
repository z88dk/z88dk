
; djm 28/2/2000

; void l_longjmp(jmp_buf *env, int val)

SECTION code_clib
SECTION code_setjmp

PUBLIC l_longjmp
PUBLIC _l_longjmp

l_longjmp:
_l_longjmp:

   pop de
   pop hl
   pop bc

   ; bc = val
   ; hl = jmp_buf *
   
   ld a,b
   or c
   jr nz, val_ok
   
   inc c                       ; not allowed to return 0

val_ok:
IF !__CPU_INTEL__ && !__CPU_GBZ80__

   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = ix
   inc hl
   
   push de
 IFDEF __SDCC_IX
   pop ix
 ELSE
   pop iy
 ENDIF
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   
   push de
 IFDEF __SDCC_IX
   pop iy
 ELSE
   pop ix
 ENDIF
ELSE
   inc hl
   inc hl
   inc hl
   inc hl
ENDIF

   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = sp
   inc hl

   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = pc
   
   ex de,hl
   ld sp,hl
   
   push de                     ; push return address
   
   ld l,c
   ld h,b                      ; hl = val
   
   ret
