
   ; write to bit device

   IF __sound_bit_method = 1
   
      out (__sound_bit_port),a
   
   ENDIF
   
   IF __sound_bit_method = 2

      out (c),a
   
   ENDIF
   
   IF __sound_bit_method = 3
   
      ld (__sound_bit_port),a
   
   ENDIF
