/*
	013 - Game of Life
	CPCRSLIB demo
	
	zcc +cpc -lndos -create-app -Cz--audio -lm rs013.c
 */


#include <cpc.h>
#include <stdio.h>
#include <stdlib.h>
#include <graphics.h>


#define ANCHO 20
#define ALTO 20
#define MUERTA 0
#define VIVA 1



//Una célula muerta con exactamente 3 células vecinas vivas "nace" (al turno siguiente estará viva). 
//Una célula viva con 2 ó 3 células vecinas vivas sigue viva, en otro caso muere o permanece muerta (por "soledad" o "superpoblación"). 
unsigned char celulas[400];
unsigned char celulas_tmp[400];

char txt_numb[4];

unsigned char celula_gph[] = {255,255,255,255};	//Dibujo de la célula
unsigned char cursor_gph[] = {0xcc,0xcc,0xcc,0xcc};	//Dibujo del cursor


void dibujar(void){
	unsigned char i,j;
	for (i=0;i<ANCHO;i++)
		for (j=0;j<ALTO;j++) {
			if (celulas[j*ANCHO+i]){
				cpc_PutSp(celula_gph,2,2,cpc_GetScrAddress(2*i,2*j));
			} 
		}
}

unsigned char valida(signed char i, signed char j) {
   /* Controla si la posicion esta fuera del recinto */
	if ((i<0) || (i>=ANCHO) || (j<0) || (j>=ALTO)){
    	return 0;
  	} else return 1;
}


unsigned char vecinas(unsigned char i, unsigned char j) {
	unsigned char x,y;
	unsigned char valor=0;
	unsigned int v0, v1, v2;

	v0=j*ANCHO+i;
	v1=v0-ANCHO;
	v2=v0+ANCHO;
	if (valida(i-1,j))  valor += celulas[v0-1];
	if (valida(i+1,j))  valor += celulas[v0+1];

	if (valida(i-1,j-1))  valor += celulas[v1-1];
	if (valida(i+1,j-1))  valor += celulas[v1+1];	
	if (valida(i,j-1))  valor += celulas[v1];

	if (valida(i-1,j+1))  valor += celulas[v2-1];
	if (valida(i+1,j+1))  valor += celulas[v2+1];	
	if (valida(i,j+1))  valor += celulas[v2];	


	return valor;
}


void ciclo(void){	//Simula una iteración.
	//celulas[] global
	unsigned char i,j,v,c;
	unsigned int v0;
	for (i=0;i<ANCHO;i++){
		for (j=0;j<ALTO;j++) {
			v=vecinas(i,j);
			v0=j*ANCHO+i;
			c=celulas[v0];
			if (c==1){//celula viva
				if (v==2 || v==3) {celulas_tmp[v0]=1; //regla 2
						 } else {
						   	celulas_tmp[v0]=0;
						   }
			} else {// celula muerta	
					if (v==3) {celulas_tmp[v0]=1;
						}		//regla 1
						else {celulas_tmp[v0]=0;
						}
				}
		}
	}
}
			
void iniciarCelulas(void){
int i;

	for (i==0;i<400;i++){
		celulas[i]=0;
		celulas_tmp[i]=0;
	}

}


void introducirCelulas(void){	//Rutina para meter manualmente las células iniciales
	unsigned char i, j, i0, j0;
	iniciarCelulas();	//Se limpian todas.

	i=i0=j=j0=0;
	cpc_PutSpXOR(cursor_gph,2,2,cpc_GetScrAddress(2*i,2*j));
	cpc_ScanKeyboard();	
	while (!cpc_TestKeyF(5)){	// Repeat until ESC pressed
		cpc_ScanKeyboard();		// Scans whole keyboard
		if (cpc_TestKeyF(0) && i<20) i++; // right move key
		if (cpc_TestKeyF(1) && i>0) i--;  // left move
		if (cpc_TestKeyF(2) && j<20) j++; // down move key
		if (cpc_TestKeyF(3) && j>0) j--;  // up move	
		if (cpc_TestKeyF(4) ) {	// select		
			if (celulas[j*20+i]==0){
				celulas[j*20+i]=1;
				cpc_PutSpXOR(celula_gph,2,2,cpc_GetScrAddress(2*i,2*j));	
			} else {
				celulas[j*20+i]=0;
				cpc_PutSpXOR(celula_gph,2,2,cpc_GetScrAddress(2*i,2*j));	
			}	
		};  	
		
		#asm
		ld b,20
		.ko
		halt
		djnz ko
		#endasm
		
		if (i0!=i || j0!=j) {
				cpc_PutSpXOR(cursor_gph,2,2,cpc_GetScrAddress(2*i0,2*j0));
				i0=i;
				j0=j;
				cpc_PutSpXOR(cursor_gph,2,2,cpc_GetScrAddress(2*i,2*j));
		}
		
	}
}


void swap(void){
/*	int i;
	for (i=0;i<400;i++){
		celulas[i]=celulas_tmp[i];
	} */
	
	#asm
	ld bc,400
	ld hl,_celulas_tmp
	ld de,_celulas
	ldir
	
	
	
	#endasm
}	
void clrCelulasTmp(void){
/*	int i;
	for (i=0;i<400;i++){
		celulas_tmp[i]=0;
	} */
	
	#asm
	
	
	xor a
	ld bc,400
	ld hl,_celulas_tmp
	ld de,_celulas_tmp+1
	ld (hl),a
	ldir
	
	#endasm
	
}	
	
main(){
	unsigned int ite=0;
	unsigned char cite[7];
	
	while(!cpc_TestKey(5)){
		cpc_ClrScr();	
			
		draw(348,0,348,40);	
		cpc_DisableFirmware();
		cpc_SetColour(16,20); //background
		cpc_SetColour(0,20); //border
		cpc_SetColour(1,10); //
		
		cpc_SetMode(0);
		cpc_SetInkGphStr(0,0);
		cpc_SetInkGphStr(2,2);
		cpc_SetInkGphStr(1,8);
		
		cpc_PrintGphStrXY2X("GAME;OF;LIFE",50,6);
		cpc_PrintGphStrXY("ARTABURU;2009",49,24);
		cpc_AssignKey(0,0x4002);		// key "1" assigned to 0
		cpc_AssignKey(1,0x4101);		// key "2"
		cpc_AssignKey(2,0x4004);		// key "3"
		cpc_AssignKey(3,0x4001);		// key "4"
		cpc_AssignKey(4,0x4580);		// key "space"
		cpc_AssignKey(5,0x4804);		// key "ESC"
		
		//iniciarCelulas();
		cpc_SetInkGphStr(0,0);
		cpc_SetInkGphStr(2,10);
		cpc_SetInkGphStr(1,32);
		cpc_PrintGphStrXY("ENTER;CELLS;USING;CURSOR;KEYS",9,62);
		cpc_PrintGphStrXY("AND;SPACE;;ESC;TO;FINISH",9,70);
		introducirCelulas();
		cpc_PrintGphStrXY("ITERATION;;;;;;;;;;;;;;;;;;;;",9,62);
			itoa(ite,txt_numb,10);
		cpc_PrintGphStrXY(txt_numb,9+18,62);
		
		cpc_PrintGphStrXY(";;;;;;;;;;;;;;;;;;;;;;;;",9,70);	
		while(!cpc_TestKey(5)){
			ite++;
			dibujar();
			clrCelulasTmp();
			ciclo();
			swap();
			itoa(ite,txt_numb,10);
			cpc_PrintGphStrXY(txt_numb,9+18,62);
			cpc_PutSp((char *) 0x8000,42,42,0xc000);
		}
		clrCelulasTmp();
		swap();
	}
	return 0;
}	


