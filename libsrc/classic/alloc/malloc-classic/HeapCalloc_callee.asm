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

   ; A return address can't go through AF on these CPUs: the flags byte does not
   ; read back what was pushed, and on the VM1 pop af also switches the data bank.
   IF __CPU_INTEL__ | __CPU_GBZ80__
   pop hl
   pop de
   pop bc
   ex (sp),hl
   ld a,b
   ld b,h
   ld h,a
   ld a,c
   ld c,l
   ld l,a
   ELSE
   pop af
   pop de
   pop hl
   pop bc
   push af
   ENDIF

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
   ld bc,hl
   pop hl
   push bc
   call asm_HeapAlloc
   pop bc
   ret NC                    ; ret if fail

   ld a,b
   or c
   jr Z,out

   ld (hl),0
   dec bc
   ld a,b
   or c
   jr Z,out

   push hl                   ; zero memory block
   ld de,hl
   inc de

IF __CPU_INTEL__ || __CPU_GBZ80__
   dec bc
   inc b
   inc c
.ldir_loop
   ld a,(hl+)
   ld (de+),a
   dec c
   jr NZ,ldir_loop
   dec b
   jr NZ,ldir_loop
ELSE
   ldir
ENDIF

   pop hl

.out

   scf
   ret
