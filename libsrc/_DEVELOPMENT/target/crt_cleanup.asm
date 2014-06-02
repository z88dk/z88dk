
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; crt cleanup ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   IF __crt_cfg_fopen_max < 128

      push hl                       ; save exit status

      ; stop multi-threading

      ; close open files
      ; what about files that are locked?

      EXTERN asm_p_forward_list_front, l_jpix

      ld hl,__stdio_file_list_open

   __close_loop:

      call asm_p_forward_list_front
      jr c, __close_done

      push hl
      pop ix

      ld a,(ix+3)
      and $07
      jr nz, __close_loop           ; do not bother with memstreams

      push hl
   
      ld a,STDIO_MSG_CLOS
      call l_jpix
   
      pop hl
      jr __close_loop

   __close_done:

      pop hl                        ; restore exit status

   ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
