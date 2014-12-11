
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; unimplemented
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   ; system()
   
   PUBLIC __ch_system
   
   EXTERN error_zc
   
   defc __ch_system = error_zc
   
   ; threads
   ; these functions are preliminary only
   
   PUBLIC __thread_context_switch
   PUBLIC __thread_block_timeout
   PUBLIC __thread_unblock

   EXTERN l_ret

   defc __thread_context_switch = l_ret
   defc __thread_block_timeout  = l_ret
   defc __thread_unblock        = l_ret
