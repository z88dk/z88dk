
;	Trace function for REX6000 emulator
;
;	written by Daniel Schmidt

		PUBLIC	DsTrace
      PUBLIC   _DsTrace

.DsTrace
._DsTrace
	ld	d,a		;we need to reverse the param order first
	ld 	b,d
 	ld 	ix,2
 	add 	ix,sp
.trace_1
 	ld 	l,(ix+0)
        ld 	h,(ix+1)
 	push 	hl
 	inc 	ix
 	inc 	ix
	djnz    trace_1
	call	trace_3		;the emulator needs this dummy call in
				;order to recognize the trace statement
	ld 	b,d
.trace_2
 	pop 	ix
 	djnz trace_2
 	ret
 	
.trace_3
	ld	a,0
	out	($fe),a
	ret


