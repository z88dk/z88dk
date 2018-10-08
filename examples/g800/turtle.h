#ifndef _TURTLE_H
#define _TURTLE_H
// turtle graphics library

#include <graphics.h>
#include <math.h>

extern float turtle_x,turtle_y;
extern float turtle_r;
extern int turtle_mode;

void forward(int);
void backword(int);
void setpos(float,float);
void left(float);
void right(float);
void home();
void setposition(float , float );
void position(float* , float* );
float towards(float , float );
float heading();
void penup();
void pendown();

#endif
