
   ; initialize the heap
   
   IF __heap_sz
   
      LIB asm_heap_init
      
      ld hl,__heap
      ld bc,__heap_sz
      
      call asm_heap_init
   
   ENDIF
   
   ; initialize balloc queue table
   
   IF __qtbl_sz
   
      LIB asm_balloc_init
      
      ld l,__qtbl_sz
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
