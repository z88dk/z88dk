/*
	007 - PUcrunch decompression
	CPCRSLIB demo
	
	zcc +cpc -lndos -create-app -Cz--audio -lm rs007.c
 */
 
#include <cpc.h>
extern unsigned char binary_data[];
#asm
._binary_data
   BINARY "tonteria.pu"
#endasm

main(){
	cpc_SetModo(1);
	// cpc_Uncrunch(origen, destino);
	cpc_Uncrunch(binary_data,0xc000);
	
	while (1) {}
}

