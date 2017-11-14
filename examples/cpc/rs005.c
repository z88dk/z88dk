/*
	005 - Text
	CPCRSLIB demo
	
	zcc +cpc -lndos -create-app -Cz--audio rs005.c
 */

 #include <cpc.h>




main(){



	cpc_SetBorder(0);
	cpc_SetInk(0,0);
	cpc_SetModo(0);	//Set mode 0 using firmware
		
	//cpc_DisableFirmware();
	
	cpc_SetInkGphStr(0,0);
	cpc_SetInkGphStr(2,2);
	cpc_SetInkGphStr(1,8);

	//Printing text without firmware
	cpc_PrintGphStr("ABCDEFGHIJKLMN=OPQRSTUVWXYZ>",0xc000);	//10,80 are the coordinates where  write
	
	
	cpc_SetInkGphStr(0,8);
	cpc_SetInkGphStr(2,2);
	cpc_SetInkGphStr(1,0);

	//Printing text without firmware
	cpc_PrintGphStr2X("ABCDEFGHIJKLMN=OPQRSTUVWXYZ>",0xc190);	//10,80 are the coordinates where  write	
	
	cpc_SetInkGphStr(0,0);
	cpc_SetInkGphStr(2,10);
	cpc_SetInkGphStr(1,32);
	
	cpc_PrintGphStrXY("0123456789<:!;",20,110);	
	cpc_SetInkGphStr(0,32);
	cpc_SetInkGphStr(2,10);
	cpc_SetInkGphStr(1,0);
	
	cpc_PrintGphStrXY2X("0123456789<:!;",20,119);		
	
	cpc_SetInkGphStr(0,130);
	cpc_SetInkGphStr(2,10);
	cpc_SetInkGphStr(1,128);
	
	
	
											//gráfica donde escribir mediante coordenadas gráficas			
	//Caracteres soportados: dígitos. Letras mayúsculas. 
	//"<" = "."
	//";" = " "
	//":" = ":"
	//"=" = "Ñ"
	//y hay algunos caracteres más libres que se pueden redefinir, actualmente son " "

	//cpc_SetInkGphStr(0,32);


	//cpc_SetInkGphStr(3,32);	
	cpc_PrintGphStrXY("PRESS;ANY;KEY",10,140);		
	
	cpc_SetInkGphStr(0,128);
	cpc_SetInkGphStr(2,130);
	cpc_SetInkGphStr(1,10);
	
	
	
											//gráfica donde escribir mediante coordenadas gráficas			
	//Caracteres soportados: dígitos. Letras mayúsculas. 
	//"<" = "."
	//";" = " "
	//":" = ":"
	//"=" = "Ñ"
	//y hay algunos caracteres más libres que se pueden redefinir, actualmente son " "
	
	
	while (!cpc_AnyKeyPressed()){}
	
	//Mode 1
	cpc_SetModo(1);		
	//cpc_SetInkGphStrM1(2,32);			
	cpc_PrintGphStrM1("ABCDEFGHIJKLMN=OPQRSTUVWXYZ>",0xc000);	//0xc190 is screen address where write
	cpc_PrintGphStrM12X("ABCDEFGHIJKLMN=OPQRSTUVWXYZ>",0xc190);	//0xc190 is screen address where write	
	//cpc_SetInkGphStrM1(2,10);
	cpc_PrintGphStrXYM1("0123456789<:!;",20,100);	
	cpc_PrintGphStrXYM12X("0123456789<:!;",20,109);		
	
	cpc_PrintGphStrXYM12X("PRESS;ANY;KEY",10,149);	
	while (!cpc_AnyKeyPressed()){}
	//cpc_EnableFirmware();
	return 0;

	
}		
