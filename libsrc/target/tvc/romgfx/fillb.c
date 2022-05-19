/*
 *
 *  Videoton TV Computer C stub
 *  Sandor Vass - 2022
 *
 *  Fills a box with the current pen settings. In 2c mode the X virtual coordinates are 
 *  2 times the physical, 4c mode it is 4x, 16c mode it is 8x. The Y virtual coordinates
 *  are always 4x the physical. 
 *
 */

 #include <graphics.h>
 #include <tvc.h>

#define min(a,b)    (a<b) ? a : b
#define max(a,b)    (a>b) ? a : b

 
int get_step() {
    enum video_mode vmode = tvc_get_vmode();
    if(vmode == VMODE_16C)
        return 8;
    else if(vmode == VMODE_4C)
        return 4;
    else
        return 2;
}

void __LIB__ fillb(int tlx, int tly, int width, int height) __smallc {
    tlx = max(tlx, 0);
    tly = max(tly, 0);
    int endx = min(getmaxx(), tlx+width);
    int endy = min(getmaxy(), tly+height);
    int stepx = get_step();
    if(width<height) {
        for(int x=tlx; x<endx; x+=stepx) {
            draw(x, tly, x, endy);
        }
        draw(endx,tly,endx,endy);
    } else {
        for(int y=tly; y<endy; y+=4) {
            draw(tlx, y, endx, y);
        }
        draw(tlx,endy,endx,endy);
    }
}
