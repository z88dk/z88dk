/* 
 *	A Simple 3 Rotor Enigma Simulation
 *
 *	11/9/98 djm - Converted to z88dk 
 *	27/1/02 djm - Added support for argc/argv for CPM
 */

#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>


/* Rotor Wirings */

const unsigned char rotor[] =
    "EKMFLGDQVZNTOWYHXUSPAIBRCJAJDKSIRUXBLHWTMCQGZNPYFVOEBDFHJLCPRTXVZNYEIWGAKMUSQOESOVPZJAYQUIRHXLNFTGKDCMWBVZBRGITYUPSDNHLXAWMJQOFECK";

const unsigned char ref[] = "YRUHQSLDPXNGOKMIEBFZCWVJAT";

const unsigned char notch[] = "QEVJZ";
unsigned int flag = 0;

/*Encryption parameters */

const unsigned char order[3] = { 3, 1, 2 };
const unsigned char rings[3] = { 'W', 'X', 'T' };
unsigned char pos[3];
const unsigned char plug[] = "AMTE";

#ifdef CPM
//#define ARGC
#endif
#ifdef Z88_SHELL
#define ARGC
#endif

#ifdef ARGC
int main(int argc, char *argv[])
#else
int main()
#endif
{
    unsigned int i, j, n = 0;
    int ch;
#ifdef ARGC
    int len, posn;


    if (argc != 2) {
	puts("Usage: enigma [text to be encoded]");
	exit(1);
    }

    len = strlen(argv[1]);
    posn = -1;
#else
    puts("Enter text to be (de)coded, finish with a .");
#endif
    pos[0] = 'A';
    pos[1] = 'W';
    pos[2] = 'E';

#ifdef ARGC
    while (posn++ < len) {
	ch = toupper(*(argv[1] + posn));
#else
    for (;;) {
	ch = getchar();
	ch = toupper(ch);
#endif
	if (ch == '.')
	    exit(0);
	if (isalpha(ch) == 0)
	    continue;


	/* Step up first rotor */
	pos[0]++;
	if (pos[0] > 'Z')
	    pos[0] -= 26;

	/* Check if second rotor reached notch last time */
	if (flag) {
	    /* Step up second and third rotors */
	    pos[1]++;
	    if (pos[1] > 'Z')
		pos[1] -= 26;
	    pos[2]++;
	    if (pos[2] > 'Z')
		pos[2] -= 26;
	    flag = 0;
	}

/* Step up seconond rotor if first rotor reached notch */
	if (pos[0] == notch[order[0] - 1]) {
	    pos[1]++;
	    if (pos[1] > 'Z')
		pos[1] -= 26;
	    if (pos[1] == notch[order[1] - 1])
		flag = 1;
	}

/*Swap pairs of letters on plugboard */

	for (i = 0; plug[i]; i += 2) {
	    if (ch == plug[i])
		ch = plug[i + 1];
	    else if (ch == plug[i + 1])
		ch = plug[i];
	}

/* Rotors (forward) */

	for (i = 0; i < 3; i++) {
	    ch += pos[i] - 'A';
	    if (ch > 'Z')
		ch -= 26;

	    ch -= rings[i] - 'A';
	    if (ch < 'A')
		ch += 26;

	    ch = rotor[((order[i] - 1) * 26) + ch - 'A'];

	    ch += rings[i] - 'A';
	    if (ch > 'Z')
		ch -= 26;

	    ch -= pos[i] - 'A';
	    if (ch < 'A')
		ch += 26;
	}

/* Reflecting rotor */
	ch = ref[ch - 'A'];

/*Rotors (Reverse) */

	for (i = 3; i; i--) {
	    ch += pos[i - 1] - 'A';
	    if (ch > 'Z')
		ch -= 26;

	    ch -= rings[i - 1] - 'A';
	    if (ch < 'A')
		ch += 26;

	    for (j = 0; j < 26; j++)
		if (rotor[(26 * (order[i - 1] - 1)) + j] == ch)
		    break;

	    ch = j + 'A';

	    ch += rings[i - 1] - 'A';
	    if (ch > 'Z')
		ch -= 26;

	    ch -= pos[i - 1] - 'A';
	    if (ch < 'A')
		ch += 26;
	}

/* Plugboard */

	for (i = 0; plug[i]; i += 2) {
	    if (ch == plug[i])
		ch = plug[i + 1];
	    else if (ch == plug[i + 1])
		ch = plug[i];
	}

	n++;
	putchar(ch);
	if (n % 5 == 0)
	    if (n % 55 == 0)
		putchar('\n');
	    else
		putchar(' ');
    }
}
