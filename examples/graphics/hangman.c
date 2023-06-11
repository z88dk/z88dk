
// HANGMAN - an example on how to port from a BASIC program
// Stefano Bodrato, 2022


// zcc +zx -lndos -create-app -clib=ansi hangman.c
// zcc +zx -lndos -create-app -pragma-redirect:fputc_cons=fputc_cons_generic hangman.c


#include <stdio.h>
#include <string.h>
#include <graphics.h>
//#include <lib3d.h>  // << an alternative way to draw arcs for smile and frown
#include <games.h>




#define WLEN 32

char   a;         //  'again?'
char   g;         //  guess
int    b, n;      //  string length, counter
int    c, d;      //  guess & mistake counts
char   u [WLEN];  //  previous status of the guessed word
char   v [WLEN];  //  guessed word
char   w [WLEN];  //  secret word

int    xr,yr,x0,y0;


// READ/DATA replacement
int g_ptr;
int glw[32]= {120,111,135,-0,   184,111,0,-91, \
              168,111,16,-16,   184,95,16,16,  \
              184,20,68,-0,     184,36,16,-16, \
              204,20,-20,20,    240,20,0,16 };


// Smaller and faster than arc drawing
char smile[]={9,3, 128,128, 65,0 ,62,0};
char frown[]={9,3, 62,0 ,65,0, 128,128};



void print_at(int xx, int yy) {
#ifdef __CONIO_VT100

    // ANSI
    printf("%c[%u;%uH", 27, xx, yy);

#else

    // VT-52
	fputc_cons (27);
	fputc_cons ('Y');
	fputc_cons (xx+32);
	fputc_cons (yy+32);

#endif
}


#ifdef HAVE_XOR

void draw_man(int x) {
//  head
    xorcircle (x,44,8,1);
    xorplot (x+4,42);
    xorplot (x-4,42);
    xorplot (x,45);
//  body
    xorplot (x,53);
    xordrawr (0,20);
    xorplot (x,75);
    xordrawr (0,19);
//  legs
    xorplot (x-15,110);
    xordrawr (15,-15);
    xordrawr (15,15);
//  arms
    xorplot (x-15,59);
    xordrawr (15,15);
    xordrawr (15,-15);
}

#define erase_man draw_man

#else

//  draw man at column x
void draw_man(int x) {
//  head
    circle (x,44,8,1);
    plot (x+4,42);
    plot (x-4,42);
    plot (x,45);
//  body
    plot (x,53);
    drawr (0,20);
    plot (x,75);
    drawr (0,19);
//  legs
    plot (x-15,110);
    drawr (15,-15);
    drawr (15,15);
//  arms
    plot (x-15,59);
    drawr (15,15);
    drawr (15,-15);
}


//  erase man at column x
void erase_man(int x) {
//  head
    uncircle (x,44,8,1);
    unplot (x+4,42);
    unplot (x-4,42);
    unplot (x,45);
//  body
    unplot (x,53);
    undrawr (0,20);
    unplot (x,75);
    undrawr (0,19);
//  legs
    unplot (x-15,110);
    undrawr (15,-15);
    undrawr (15,15);
//  arms
    unplot (x-15,59);
    undrawr (15,15);
    undrawr (15,-15);
}

#endif



//  Hangman game entry
int main() {

// On the ZX Spectrum, we switch to 32 column mode
#if defined(__SPECTRUM__)
    printf("%c%c",1,32);
#endif


  while (1)
  {


//  set up screen
    clg();
    g_ptr=0;

    draw_man(240);
//  mouth
    plot (238,48);
    drawr (4,0);

//  set up word
    print_at (18,0);
    puts_cons ("Enter the secret word");
    print_at (21,1);
    scanf("%s",w);
    print_at (18,0);
    puts_cons ("                     ");


//  word to guess
    b = strlen(w);
    
//  v = word guessed so far
	memset(v,' ',WLEN);
	v[b]='\0';

//  guess & mistake counts
    c = 0;  d = 0;

//  write -'s instead of letters
    for (n=0; n<b; n++) {
      print_at (20,n);
      fputc_cons ('-');
    }

go_guess:
    while (getk() != 0) {};
    print_at (21,0);
    puts_cons ("Guess a letter         ");
    while ((g=getk()) == 0) {};

    print_at (8,c++);
    fputc_cons (g);

    strcpy(u, v);

//  update guessed word
    for (n=0; n<b; n++) {
      if (w[n] == g)
          v[n] = g;
    }

    //print_at (19,0);
	print_at (11,3);
    puts_cons (v);

    if (!strcmp(v, w)) {
    //if (v == w) {
//  word guessed
      goto free_man;
    }

//  Something added? guess was right
    if (strcmp(v, u)) {
    //if (v != u) {
      goto go_guess;
    }

//  draw next part of gallows
    if (d++ == 8) {
//  hanged
      goto hang_man;
    }

// Simulate the READ/DATA structure
    x0 = glw[g_ptr++];
    y0 = glw[g_ptr++];
    xr = glw[g_ptr++];
    yr = glw[g_ptr++];

    plot (x0,y0);
    drawr (xr,yr);
    goto go_guess;


free_man:
//  rub out man
    erase_man(240);
//  mouth
    unplot (238,48);
    undrawr (4,0);

//  redraw man
    draw_man(146);
    //plot (143,47);
//  smile
    //ellipse(146,47,0,180,5,3);
    putsprite(spr_or, 142,47, smile);
    goto game_end;


hang_man:
//  rub out floor
    unplot (255,111);
    undrawr (-48,0);

//  open trapdoor
    undrawr (8,48);

//  rub out mouth
    unplot (238,48);
    undrawr (4,0);

//  move limbs
//  arms
    unplot (255,59);
    undrawr (-15,15);
    undrawr (-15,-15);
    plot (236,95);
    drawr (4,-21);
    drawr (4,21);

//  legs
    unplot (255,110);
    undrawr (-15,-15);
    undrawr (-15,15);
    plot (236,116);
    drawr (4,-21);
    drawr (4,21);

//  frown
    //ellipse(240,49,180,360,5,3);
    putsprite(spr_or, 236,47, frown);


game_end:
//  show the secret word
    print_at (19,0);
    puts_cons (w);

    while (getk() != 0) {};

    print_at (21,0);
    puts_cons ("Do you wish to play gain?");
    a=0;
    while (a!='y') {
        a=getk();
        if (a == 'n')
            return (0);
    }

  }

}

