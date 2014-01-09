
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CRT USER DEFINES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; defc __EXITSTACK_SZ       = 32  ;; less than 255
;; defc __QUICK_EXITSTACK_SZ = 32  ;; less than 255


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CRT HOST VARIABLES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

defvars __crt_vars_host
{

   ;;;;;;;;;;;;;;;;;;
   ;; host jump table
   ;;;;;;;;;;;;;;;;;;
   
   ; int system(char *s)
   ;
   ; enter : hl = char *s
   ;
   ; exit  : if s == 0
   ;
   ;           carry reset
   ;           hl = non-zero
   ;
   ;         else
   ;
   ;           hl = result
   ;
   ; uses  : all
   
   __ch_system        ds.b  1      ;; 195 = JP
                      ds.w  1      ;; address of system function
                                   ;; (default = error_zc)
   __END_CRT_VARS_HOST
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CRT PER PROCESS VARIABLES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

defvars __crt_vars_process
{
   __sp               ds.w  1      ;; stack address prior to calling main()

   __exit_stack       ds.b  1      ;; number of registered exit functions
                      ds.w  __EXITSTACK_SZ
                      
   __quickexit_stack  ds.b  1      ;; number of registered quick exit functions
                      ds.w  __QUICK_EXITSTACK_SZ
   
   ;;;;;;;;;;;;;;;;;;;;;
   ;; process jump table
   ;;;;;;;;;;;;;;;;;;;;;
   
   __END_CRT_VARS_PROCESS
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CRT PER THREAD VARIABLES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

defvars __crt_vars_thread
{
   __thrd_id          ds.b  1      ;; thread id of current thread

   _errno             ds.w  1
   __heap             ds.w  1      ;; current malloc heap
   __qtbl             ds.w  1      ;; current balloc table
   __seed             ds.l  1      ;; initialize to $00010001
   __strtok_ptr       ds.w  1
   
   ;;;;;;;;;;;;;;;;;;;;;;;
   ;; thread local storage
   ;;;;;;;;;;;;;;;;;;;;;;;
   
   ;;;;;;;;;;;;;;;;;;;;
   ;; thread jump table
   ;;;;;;;;;;;;;;;;;;;;
   
   ; library memory deallocator
   ;
   ; enter : hl = address of memory to free
   ;
   ; exit  : none
   ;
   ; uses  : af, bc, de, hl
   
   __ct_free          ds.b  1      ;; 195 = JP
                      ds.w  1      ;; address of free compatible function
                                   ;; (default = free)
   ; library memory allocator
   ;
   ; enter : hl = request size in bytes
   ;
   ; exit  : success
   ;
   ;           carry reset
   ;           hl = ptr to allocated memory
   ;
   ;         fail
   ;
   ;           carry set, errno = ENOMEM
   ;           hl = 0
   ;
   ; uses  : af, bc, de, hl
                      
   __ct_malloc        ds.b  1      ;; 195 = JP
                      ds.w  1      ;; address of malloc compatible function
                                   ;; (default = malloc)

   __END_CRT_VARS_THREAD
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CRT LOCALE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

defvars __crt_locale
{
   ;;;;;;;;;;;;;;;;;;;;
   ;; locale jump table
   ;;;;;;;;;;;;;;;;;;;;
   
   ; char comparison
   ;
   ; enter : b = char
   ;         c = char
   ;
   ; exit  : a = effective b - c, with flags set
   ;
   ; uses  : af, bc, de, hl
   
   __lc_char_cmp_bc   db.1         ;; 195 = JP
                      dw.1         ;; function address
                                   ;; (default = __lc_char_cmp_bc_default)
   ; char to ordinal mapping
   ;
   ; enter : a = char
   ;
   ; exit  : a = ordinal
   ;
   ; uses  : af, bc, de, hl
   
   __lc_char_ordinal  db.1         ;; 195 = JP
                      dw.1         ;; function address
                                   ;; (default = __lc_char_ordinal_default)
   __END_CRT_LOCALE
}
