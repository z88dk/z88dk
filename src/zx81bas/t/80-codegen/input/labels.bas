#ASM
start_asm:

; make value1 and value2 survive to map file
	public value1, value2

value1 = 12
value2 equ 13

show_bc:
	ret
	
.set_bc
	ld bc, 0
	ret

message:	DEFM "HELLO"

move_message:
	ld hl, message
	ld de, &message_target+6
	ld bc, 5
	ldir
	ret
	
line_number:
	ld bc, @start		; line 10
	ret
	
start_address:
	ld bc, &show_bc		; 16514
	ret

end_asm:	
#ENDASM

@start:									' line 10
	PRINT 16509+5+&end_asm-&start_asm+1, &start	' show @start address
	PRINT "10", USR &line_number		' show 10
	PRINT "16514", USR &start_address	' show 16514
	LET A=USR &move_message				' replace "12345" by "HELLO"
	PRINT "HELLO",						' show HELLO
@message_target:
	PRINT "12345" 						' show HELLO
	PRINT "16514", USR &show_bc			' show 16514
	
	POKEW &set_bc+1,12345
	PRINT "12345", USR &set_bc			' change BC to 12345

	PRINT "12", &value1
	PRINT "13", &value2

#AUTOSTART = 1
