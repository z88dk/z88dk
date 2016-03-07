; char __CALEE__ *strncat_callee(char *dst, char *src, uint n)
; copy src to dst but no more than n chars, add '\0'
; 04.2001 dom, 12.2006 aralbrec

SECTION code_clib
PUBLIC strncat_callee
PUBLIC _strncat_callee
PUBLIC ASMDISP_STRNCAT_CALLEE

EXTERN  rcmx_cpir

.strncat_callee
._strncat_callee

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   ; enter : de = char *src
   ;         hl = char *dst
   ;         bc = uint n
   ; exit  : hl = char *dst
   ; uses  : af, bc, de, hl

.asmentry

   push hl

   ld a,b
   or c                      ; if n=0 don't do anything
   jr z, exit
   
   ; first find the end of string dst
   
   xor a
   push bc
   cpir
   pop bc
   dec hl
      
   ; now append src to dst but no more than n chars
   
   ex de,hl

.loop

   ld a,(hl)
   or a
   jr z, done
   ldi
   jp pe, loop

   xor a

.done

   ld (de),a

.exit

   pop hl
   ret

DEFC ASMDISP_STRNCAT_CALLEE = # asmentry - strncat_callee
