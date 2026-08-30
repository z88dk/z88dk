
; void *obstack_copy(struct obstack *ob, void *address, size_t size)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC obstack_copy

EXTERN asm_obstack_copy

obstack_copy:

   ; A return address can't go through AF on these CPUs: the flags byte does not
   ; read back what was pushed, and on the VM1 pop af also switches the data bank.
   IF __CPU_INTEL__ | __CPU_GBZ80__
   ld hl,2
   add hl,sp
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   ld hl,6
   add hl,sp
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   ELSE
   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   ENDIF

   jp asm_obstack_copy

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _obstack_copy
defc _obstack_copy = obstack_copy
ENDIF

