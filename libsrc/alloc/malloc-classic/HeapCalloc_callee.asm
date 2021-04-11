; void __CALLEE__ *HeapCalloc_callee(void *heap, unsigned int nobj, unsigned int size)
; 12.2006 aralbrec

SECTION code_clib
PUBLIC HeapCalloc_callee
PUBLIC _HeapCalloc_callee
PUBLIC asm_HeapCalloc

EXTERN l_mult
EXTERN asm_HeapAlloc

.HeapCalloc_callee
._HeapCalloc_callee

   pop af
   pop de
   pop hl
   pop bc
   push af

.asm_HeapCalloc

; Allocate memory from the indicated heap and clear it to zeroes
;
; enter : hl = number of objects
;         de = size of each object
;         bc = & heap pointer
; exit  : hl = address of memory block and carry set if successful
;              else 0 and no carry if failed
; uses  : af, bc, de, hl

.MAHeapCalloc

   push bc
   call l_mult               ; hl = hl*de = total size of request
   ld c,l
   ld b,h
   pop hl
   push bc
   call asm_HeapAlloc
   pop bc
   ret nc                    ; ret if fail
   
   ld a,b
   or c
   jr z, out

   ld (hl),0
   dec bc
   ld a,b
   or c
   jr z, out
      
   push hl                   ; zero memory block
   ld e,l
   ld d,h
   inc de
IF __CPU_INTEL__ || __CPU_GBZ80__
ldir_loop:
   ld a,(hl)
   ld (de),a
   inc hl
   inc de
   dec bc
   ld a,b
   or c
   jp nz,ldir_loop
ELSE
   ldir
ENDIF
   pop hl
   
.out

   scf
   ret