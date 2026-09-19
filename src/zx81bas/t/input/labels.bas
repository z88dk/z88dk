#ASM

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
	ld bc, @start
	ret
	
start_address:
	ld bc, &show_bc
	ret
	
#ENDASM

@start:
	PRINT USR &line_number, USR &start_address
	PRINT USR &move_message
	
@message_target:
	PRINT "12345" ' replaced by message
	PRINT USR &show_bc
	
	POKEW &set_bc+1,12345
	PRINT USR &set_bc

	PRINT &value1, &value2
