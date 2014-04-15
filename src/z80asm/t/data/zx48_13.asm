;#end                            ; generic cross-assembler directive 

; Acknowledgements
; -----------------
; Sean Irvine               for default list of section headings
; Dr. Ian Logan             for labels and functional disassembly.
; Dr. Frank O'Hara          for labels and functional disassembly.
;
; Credits
; -------
; Alex Pallero Gonzales     for corrections.
; Mike Dailly               for comments.
; Alvin Albrecht            for comments.
; Andy Styles               for full relocatability implementation and testing.                    testing.
; Andrew Owen               for ZASM compatibility and format improvements.

;   For other assemblers you may have to add directives like these near the 
;   beginning - see accompanying documentation.
;   ZASM (MacOs) cross-assembler directives. (uncomment by removing ';' )
;   #target rom           ; declare target file format as binary.
;   #code   0,$4000       ; declare code segment.
;   Also see notes at Address Labels 0609 and 1CA5 if your assembler has 
;   trouble with expressions.
;
;   Note. The Sinclair Interface 1 ROM written by Dr. Ian Logan and Martin 
;   Brennan calls numerous routines in this ROM.  
;   Non-standard entry points have a label beginning with X.
