/*
	010 - Sprites
	CPCRSLIB demo
	
	zcc +cpc -lndos -create-app -Cz--audio rs010.c
 */

 #include <cpc.h>

extern unsigned char sprite[];

#asm
._sprite
defb $00,$60,$00
defb $00,$F0,$00
defb $10,$D0,$C0
defb $10,$F0,$E0
defb $10,$F0,$E0
defb $22,$E4,$C0
defb $33,$66,$00
defb $33,$77,$00
defb $33,$77,$00
defb $33,$CC,$00
defb $11,$EE,$00
defb $00,$FF,$00
defb $1F,$33,$00
defb $0D,$03,$0E
defb $0E,$0B,$0D
defb $05,$09,$0A
#endasm

main(){
    unsigned char buffer[16*3];	
	cpc_SetMode(1); //rutina hardware, se restaura la situación anterior al terminar la ejecución del programa
    cpc_PrintGphStrXYM1("1;PUTS;A;SPRITE;IN;THE;SCREEN",0,8*23); 
    cpc_PrintGphStrXYM1("PRESS;ANY;KEY",0,8*24); 
    while (!cpc_AnyKeyPressed()){}
	cpc_PutSp(sprite,16,3,0xc19b);
	// Captura de la pantalla el area indicada y la guarda en memoria.
    cpc_PrintGphStrXYM1("2;CAPTURES;A;SCREEN;AREA;;;;;",0,8*23); 
    cpc_PrintGphStrXYM1("PRESS;ANY;KEY",0,8*24); 
    while (!cpc_AnyKeyPressed()){}
	cpc_GetSp(buffer,16,3,0xc19c);
    cpc_PrintGphStrXYM1("3;PRINTS;CAPTURED;AREA",0,8*23); 
    cpc_PrintGphStrXYM1("PRESS;ANY;KEY",0,8*24); 
    while (!cpc_AnyKeyPressed()){}	
	// En este ejemplo, imprime en &c19f el area capturada .    
	cpc_PutSp(buffer,16,3,0xc19f);
	// Imprime el Sprite en modo XOR en la coordenada (x,y)=(100,50)
    cpc_PrintGphStrXYM1("4;PUTS;A SPRITE;IN;XOR;MODE",0,8*23); 
    cpc_PrintGphStrXYM1("PRESS;ANY;KEY",0,8*24); 
    while (!cpc_AnyKeyPressed()){}		
    cpc_PutSpXOR(sprite,16,3,cpc_GetScrAddress(100,50));	
    cpc_PrintGphStrXYM1("5;SPRITE;PRINTED;AGAIN;IN;XOR;MODE",0,8*23); 
    cpc_PrintGphStrXYM1("PRESS;ANY;KEY",0,8*24);  
    while (!cpc_AnyKeyPressed()){}	    
    cpc_PutSpXOR(sprite,16,3,cpc_GetScrAddress(100,50));	
    
    cpc_PrintGphStrXYM1(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;",0,8*23); 
    cpc_PrintGphStrXYM1("THE;END;;;;;;",0,8*24);  
    while(1);
}
