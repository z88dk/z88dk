
; == crt initialization =======

; initialize the heap
   
IF __heap_sz > 14
      
   ld hl,__heap
   ld bc,__heap_sz      

   LIB asm_heap_init
   call asm_heap_init
   
ENDIF
   
; initialize balloc queue table
   
IF __qtbl_sz > 0
      
   ld l,__qtbl_sz

   LIB asm_balloc_init
   call asm_balloc_init
   
ENDIF
   
; initialize statically allocated FILEs
   
IF __FILE_STDIN | __FILE_STDOUT | __FILE_STDERR
   
   LIB asm_mtx_init
   ld c,mtx_recursive
   
ENDIF
   
IF __FILE_STDIN
      
   ld hl,__FILE_STDIN + 7
   call asm_mtx_init
   
ENDIF
   
IF __FILE_STDOUT
   
   ld hl,__FILE_STDOUT + 7
   call asm_mtx_init
   
ENDIF
   
IF __FILE_STDERR
   
   ld hl,__FILE_STDERR + 7
   call asm_mtx_init
   
ENDIF

; crt variables that need initial values

ld a,1
ld (__thrd_id),a

ld hl,0
ld (_errno),hl
ld (__strtok_ptr),hl

inc hl
ld (__seed),hl
ld (__seed + 2),hl

; =============================
