
char buf[256];

char *p = (char *)(buf+1);  // BAD
char *q = (char *)buf+1;    // OK
char *s = ((char *)buf+1);  //BAD
