
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; crt defaults 8085 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; crt configuration

   defc DEF__crt_enable_rst40h         = 0       ;; if non-zero and in some crts with code org = 0, a call to user code to service rst 40 is implemented

   defc DEF__crt_enable_int55          = 0       ;; if non-zero and in some crts with code org = 0, a jump to user code to service the interrupt RST 5.5 is inserted
   defc DEF__crt_enable_int65          = 0       ;; if non-zero and in some crts with code org = 0, a jump to user code to service the interrupt RST 6.5 is inserted
   defc DEF__crt_enable_int75          = 0       ;; if non-zero and in some crts with code org = 0, a jump to user code to service the interrupt RST 7.5 is inserted

;; end crt defaults 8085 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
