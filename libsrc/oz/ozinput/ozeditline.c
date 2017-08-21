#include <string.h>
#include <oz.h>

static byte x,y,pos,x0;
static char *s;
static byte height;

static void xorcursor()
{
    _ozvline(x,y,height,XOR);
    if(x>x0) _ozvline(x-1,y,height,XOR);
     else _ozvline(x+1,y,height,XOR);
}

static void setcursor(void)
{
     static byte c;
     c=s[pos];
     s[pos]=0;
     x=ozputs(x0,-1,s);
     s[pos]=c;
}

static void movecursor(void)
{
     xorcursor();
     setcursor();
     xorcursor();
}

//extern int __LIB__ ozeditline(byte _x0,byte y0,char *s0,byte slen,byte xlen)
//int ozeditline(byte _x0,byte y0,char *s0,byte slen,byte xlen)
int ozeditline(int _x0,int y0,char *s0,int slen,int xlen)
{
    static char c;
    static byte l1,l2;
    static unsigned k;
    static byte i;
    register char *p;
    switch(ozgetfont())
    {
        case FONT_PC_NORMAL:
        case FONT_OZ_NORMAL:
            height=8;
            break;
        default:
            height=13;
            break;
    }
    x=x0=_x0;
    y=y0;
    if((int)x0+(int)xlen>239 || (int)y+(int)height>79)
        return OZEDITLINE_ERROR;
    xlen--;
    s=s0;
    pos=strlen(s0);
    if(pos>=slen) return OZEDITLINE_ERROR;
    ozputs(x0,y,s);
    setcursor();
    xorcursor();
    while(1)
        switch(k=getch())
        {
            case KEY_MAIN:
            case KEY_SCHEDULE:
            case KEY_MEMO:
            case KEY_TELEPHONE:
            case KEY_POWER:
            case KEY_MYPROGRAMS:
                ozexitto(k);
            case KEY_BACKLIGHT:
                oztogglelight();
                break;
            case KEY_LEFT:
              if(pos>0)
              {
                 pos--;
                 movecursor();
              }
              break;
            case KEY_RIGHT:
              if(s[pos])
              {
                 pos++;
                 movecursor();
              }
              break;
            case KEY_LOWER_ESC:
            case KEY_UPPER_ESC:
            case 27:
              xorcursor();
              return OZEDITLINE_CANCEL;
            case KEY_LOWER_ENTER:
            case KEY_UPPER_ENTER:
            case '\r':
            case '\n':
                 xorcursor();
                 return strlen(s);
            case KEY_BACKSPACE:
            case KEY_BACKSPACE_16K:
              if(pos>0)
              {
                 pos--;
                 p=s+pos;
                 c=*p;
                 while(*p)
                 {
                    *p=p[1];
                    p++;
                 }
                 xorcursor();
                 l1=ozputs(x0,y,s);
                 l2=ozputch(l1,-1,c);
                 for(i=l1;i<l2;i++)
                 {
                    _ozvline(i,y,height,WHITE);
                 }
                 ozputs(x0,y,s);
                 setcursor();
                 xorcursor();
               }
               break;
            default:
               if(k<127 && ozputch(0,-1,k)+ozputs(0,-1,s) < xlen
                 && (l1=1+strlen(s)) < slen)
               {
                 xorcursor();
                 for(i=l1;i>pos;i--)
                    s[i]=s[i-1];
                 if(s[pos]==0) s[pos+1]=0;
                 s[pos]=k;
                 pos++;
                 ozputs(x0,y,s);
                 setcursor();
                 xorcursor();
               }
               break;
          }
}

#if 0
main()
{
    static char s[26];
    s[0]=0;
    ozeditline(0,0,s,26,100);
    ozputs(10,10,s);
    ozgetch();
}
#endif
