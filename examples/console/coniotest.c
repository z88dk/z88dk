/*
	Z88DK example for conio library

	
	$Id: coniotest.c $
	
	zcc +<target> -lndos -create-app -pragma-need=ansiterminal coniotest.c
  zcc +<target> -lndos -create-app -pragma-need=ansiterminal -pragma-define:ansicolumns=32 coniotest.c

*/

#include <conio.h>

void main()
{
	int i,j,k;
	int x,y;
	int xs,ys;
	int p,q;
	char ch;
	
	screensize(&xs,&ys);
	x=--xs; y=--ys;
	
	putch (12);
	
	p=0; q=0;

	
	ch='?';
	
	for (i = 0; i <= ys/2; ++i) {
		for (j = 0; j < x; ++j) {
			vtrendition(40+(j&7));
			gotoxy(p++,q);
			putch (ch);
			for (k = 0; k < 500; ++k);
		}
		ch++;
	    --x;
		for (j = 0; j < y; ++j) {
			vtrendition(30+(j&7));
			gotoxy(p,q++);
			putch (ch);
			for (k = 0; k < 500; ++k);
		}
		ch++;
	    --y;
		for (j = 0; j < x; ++j) {
			vtrendition(40+(j&7));
			gotoxy(p--,q);
			putch (ch);
			//vpoke(--ad, ch);
			for (k = 0; k < 500; ++k);
		}
		ch++;
	    --x;
		for (j = 0; j < y; ++j) {
			vtrendition(30+(j&7));
			gotoxy(p,q--);
			putch (ch);
			//vpoke(ad -= 32, ch);
			for (k = 0; k < 500; ++k);
		}
	    --y;
		ch++;
	}
}

