/***************************************************************************/
/*                                                                         */
/*  3D Rotating Cube. Created for Amiga and PC by Stefan Henrikson 1993.   */
/*                                                                         */
/*  Modified for Z88 BASIC 1993, SmallC+ Z88 1998 by Dennis Groning.       */
/*                                                                         */
/***************************************************************************/

#include <stdio.h>
#include <math.h>
#include <graphics.h>
#include <stdlib.h>

#define MAX_X   256.0
#define MAX_Y    64.0
#define NODES     8
#define SIZE     24.0

/* djm speed ups */

#define MAX_X2  128.0
#define MAX_Y2   32.0

static int draw2(int,int,int,int);
int draw2(int x1,int y1, int x2, int y2 )
{
#if 0
    printf("(%d,%d)->(%d,%d) ",x1,y1,x2,y2);
#endif
}

struct window win;    /* Window structure */

main()
{
        double x[NODES], y[NODES], z[NODES];
        double vx, vy, vz;
        double xg[NODES], yg[NODES], zg[NODES];
        double mx, my, halfangle;
        double cx,cy,cz,sx,sy,sz;
        double t1,t2,t3;
        int node;

        vx=0; vy=0; vz=0;
/* Next line not needed */
/*        mx=MAX_X2; my=MAX_Y2; */

    win->graph=1;
    win->width=255;
    win->number='4';

        /* Open map with width 256 on window #4 */
    //window(win);


        x[0]=-SIZE; y[0]=-SIZE; z[0]=-SIZE;
        x[1]=-SIZE; y[1]= SIZE; z[1]=-SIZE;
        x[2]= SIZE; y[2]= SIZE; z[2]=-SIZE;
        x[3]= SIZE; y[3]=-SIZE; z[3]=-SIZE;
        x[4]=-SIZE; y[4]=-SIZE; z[4]= SIZE; 
        x[5]=-SIZE; y[5]= SIZE; z[5]= SIZE; 
        x[6]= SIZE; y[6]= SIZE; z[6]= SIZE; 
        x[7]= SIZE; y[7]=-SIZE; z[7]= SIZE; 

	printf("Initialising nodes\n");
        for(node=0;node!=NODES;node++) {
	    printf("(%f %f %f) ",x[node],y[node],z[node]);

                xg[node]=x[node];
                yg[node]=y[node];
                zg[node]=z[node];
        }
#ifdef CPM
#define getk() 0
#endif
        while(getk()==0) {
                cx=cos(vx); cy=cos(vy); sx=sin(vx); sy=sin(vy);
                cz=cos(vz); sz=sin(vz);
                mx=(MAX_X2-SIZE*1.8)*cos(vx)+MAX_X2;
                my=(MAX_Y2-SIZE*1.8)*sin(vy)+MAX_Y2;
                for(node=0;node!=NODES;node++) {

                        t1=yg[node]*cx-zg[node]*sx;
                        t2=yg[node]*sx+zg[node]*cx;
                        t3=xg[node]*cy;
			printf("%f %f %f ",t1,t2,t3);
                        x[node] = (t3 + t2*sy)*cz;
                        x[node] = x[node] - t1*sz;

                        y[node] = (t3 + t2*sy)*sz;
                        y[node] = y[node] + t1*cz;

                        z[node]=-xg[node]*sy+t2*cy;
			printf("(%f %f %f)\n",x[node],y[node],z[node]);

                }
                vx+=0.003; vy+=0.005; vz+=0.002;
		printf("%f %f %f %f %f\n",x[0],y[0],z[0],mx,my);
                //clg();
                draw2(x[0]+mx,y[0]+my,x[1]+mx,y[1]+my);
                draw2(x[1]+mx,y[1]+my,x[2]+mx,y[2]+my);
                draw2(x[2]+mx,y[2]+my,x[3]+mx,y[3]+my);
                draw2(x[3]+mx,y[3]+my,x[0]+mx,y[0]+my);
                draw2(x[4]+mx,y[4]+my,x[5]+mx,y[5]+my);
                draw2(x[5]+mx,y[5]+my,x[6]+mx,y[6]+my);
                draw2(x[6]+mx,y[6]+my,x[7]+mx,y[7]+my);
                draw2(x[7]+mx,y[7]+my,x[4]+mx,y[4]+my);
                draw2(x[0]+mx,y[0]+my,x[4]+mx,y[4]+my);
                draw2(x[3]+mx,y[3]+my,x[7]+mx,y[7]+my);
                draw2(x[2]+mx,y[2]+my,x[6]+mx,y[6]+my);
                draw2(x[1]+mx,y[1]+my,x[5]+mx,y[5]+my);
		printf("\n");
        }
        //closegfx(win);
}
