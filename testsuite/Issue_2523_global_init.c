#define KW_READ 2


enum Ftype {
  FTYPE_UNDEF,
  FTYPE_SYS,
  FTYPE_SPECIAL,
  FTYPE_USER
};


char buf[256];

char *p = (char *)(buf+1);  // BAD
char *q = (char *)buf+1;    // OK
char *s = ((char *)buf+1);  //BAD

int c = ((1) +(1023));

int d = (( FTYPE_SYS )*1024 + ( 0 ));

struct s_keywords {
  char  *key;
  int  ftype;
  char   i;
};



struct s_keywords funcs[] = {
  { "read",      (( FTYPE_SYS )*1024 + ( 3 )) ,               KW_READ     },
};
