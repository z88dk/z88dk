#include <tvc.h>

extern int  __LIB__ tvc_get_bordercolor();

enum colors tvc_get_border() {

  int c = tvc_get_bordercolor();
  c &= 0xAA;
  c >>=1;
  return c;

}
