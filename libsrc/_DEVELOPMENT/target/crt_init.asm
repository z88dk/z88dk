
; == crt initialization =======

; initialize the heap
   
IF __heap_sz > 14
      
   ld hl,(__heap)
   ld bc,__heap_sz      

   EXTERN asm_heap_init
   call asm_heap_init
   
ENDIF
   
; initialize balloc queue table
   
IF __qtbl_sz > 0
      
   ld l,__qtbl_sz

   EXTERN asm_balloc_init
   call asm_balloc_init
   
ENDIF

; initialize stdio FILE queues

EXTERN asm_mtx_init, l_zeroword_hl

ld c,mtx_plain
ld hl,__stdio_file_list_lock
call asm_mtx_init

ld hl,__stdio_file_list_open
call l_zeroword_hl

ld hl,__stdio_file_list_avail
call l_zeroword_hl
ld (__stdio_file_list_avail+2),hl

; initialize statically allocated FILEs
   
IF __HAVE_FILE_STDIN | __HAVE_FILE_STDOUT | __HAVE_FILE_STDERR
   
   EXTERN asm_p_forward_list_push_front
   
ENDIF
   
IF __HAVE_FILE_STDIN
   
   ld c,mtx_recursive
   ld hl,__FILE_STDIN + 7
   call asm_mtx_init
   
   ld de,__FILE_STDIN - 2
   ld hl,__stdio_file_list_open
   call asm_p_forward_list_push_front
   
ENDIF
   
IF __HAVE_FILE_STDOUT
   
   ld c,mtx_recursive
   ld hl,__FILE_STDOUT + 7
   call asm_mtx_init

   ld de,__FILE_STDOUT - 2
   ld hl,__stdio_file_list_open
   call asm_p_forward_list_push_front

ENDIF
   
IF __HAVE_FILE_STDERR
   
   ld c,mtx_recursive
   ld hl,__FILE_STDERR + 7
   call asm_mtx_init

   ld de,__FILE_STDERR - 2
   ld hl,__stdio_file_list_open
   call asm_p_forward_list_push_front

ENDIF

; crt variables that need initial values

ld a,1
ld (__thrd_id),a

ld hl,0
ld (_errno),hl
ld (__strtok_ptr),hl

inc l
ld (__seed),hl
ld (__seed + 2),hl

; =============================
