#include <tvc.h>

extern int  __LIB__ tvc_get_bordercolor();

enum colors tvc_get_border() {

  char c = tvc_get_bordercolor();
  c &= 0x55;
  c >>=1;
  return c;

}
