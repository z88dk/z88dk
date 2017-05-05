; 1024 bytes of scratch memory before the program at address 0x5e24

PUBLIC _TEMPMEM
defc   _TEMPMEM = 0x5e24

SECTION code_user

; sp1 will call asm_malloc and asm_free as needed to create and delete sprites
; hijack the library's malloc and free and provide our own that uses the block memory allocator instead

PUBLIC asm_malloc

EXTERN asm_balloc_alloc

asm_malloc:

   ; LIBRARY REQUIREMENT:
	
   ; Allocate memory from the thread's default heap
   ;
   ; enter : hl = size
   ;
   ; exit  : success
   ;
   ;            hl = address of allocated memory, 0 if size == 0
   ;            carry reset
   ;
   ;         fail on insufficient memory
   ;
   ;            hl = 0
   ;            carry set, errno = ENOMEM
   ;
   ;         fail on lock acquisition
   ;
   ;            hl = 0
   ;            carry set, errno = ENOLCK
   ;
   ; uses  : af, bc, de, hl

	; we have only one queue with one size so that's what we use
	
	ld hl,0                     ; queue #0
	jp asm_balloc_alloc         ; agrees with the library's requirements above


PUBLIC asm_free

EXTERN asm_balloc_free

asm_free:

   ; LIBRARY REQUIREMENT:

   ; Return the memory block to the thread's default heap
   ;
   ; enter : hl = void *p
   ;
   ; exit  : success
   ;
   ;            carry reset
   ;
   ;         fail on lock acquisition
   ;
   ;            de = void *p
   ;            carry set, errno = ENOLCK
   ;
   ; uses  : af, de, hl

   push bc
	
	call asm_balloc_free        ; agrees with lib req but the lib does not allow bc to change
	
	pop bc
	ret
