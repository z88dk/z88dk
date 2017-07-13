   IF (__crt_org_vector_table > 0)

      ; copy interrupt vector table to final destination

      EXTERN __interrupt_vectors_head
      EXTERN __interrupt_vectors_size

      ld hl,__interrupt_vectors_head
      ld de,__crt_org_vector_table
      ld bc,__interrupt_vectors_size

      EXTERN asm_memcpy
      call   asm_memcpy
   
   ENDIF

   IF (__crt_org_vector_table != 0)
   
      IF (__crt_org_vector_table < 0)
      
         ld a,-__crt_org_vector_table/256
      
      ELSE
      
         ld a,__crt_org_vector_table/256
         
      ENDIF
      
      ld i,a

      IF (__Z180)
      
        ; Set the z180 internal interrupt vector low byte  
            
        ld a,__IO_VECTOR_BASE
        out0 (IL),a
        
      ENDIF
   
   ENDIF
   
   IF (__crt_interrupt_mode >= 0) && (__crt_interrupt_mode <= 2)

      ; set interrupt mode

      im __crt_interrupt_mode
      
   ENDIF
