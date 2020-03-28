#include "turtle.h"

float turtle_x=0,turtle_y=0;
float turtle_r=0;
int turtle_mode=1;

void forward(int d){
    int x0=(int)turtle_x;
    int y0=(int)turtle_y;

    turtle_x += d*cos(turtle_r/180.0*M_PI);
    turtle_y += d*sin(turtle_r/180.0*M_PI);

    if(turtle_mode==1){
    draw(x0,y0,(int)turtle_x,(int)turtle_y);
    }
}

void backword(int d){
    int x0=(int)turtle_x;
    int y0=(int)turtle_y;
    turtle_x -= d*cos(turtle_r/180.0*M_PI);
    turtle_y -= d*sin(turtle_r/180.0*M_PI);

    if(turtle_mode==1){
    draw(x0,y0, (int)turtle_x,(int)turtle_y);
    }
}

void setpos(float x_,float y_){
    turtle_x=x_;
    turtle_y=y_;
}

void left(float degree){
    turtle_r -= degree;
}
void right(float degree){
    turtle_r += degree;
}

void home(){
    turtle_x=getmaxx()/2.0;
    turtle_y=getmaxy()/2.0;

    turtle_r=0.0;
}

void setposition(float x_, float y_){
    turtle_x = x_;
    turtle_y = y_;
}

void position(float* x_, float* y_){
    *x_=turtle_x;
    *y_=turtle_y;
}
float towards(float x_, float y_){
    turtle_r = (atan2(y_-turtle_y, x_-turtle_x) /M_PI*180.0);
    return turtle_r;
}

float heading(){
    return turtle_r;
}

void penup(){
    turtle_mode=0;
}
void pendown(){
    turtle_mode=1;
}
