

all:	3dcity.sms


3dcity.sms: 
	zcc +sms main.c -vn @zproject.lst -create-app -Cl-v -pragma-include:zpragma.inc -o 3dcity -m

clean:
	$(RM) */*.o
	$(RM) *.o
	$(RM) 3dcity 3dcity.sms 3dcity.map
