// memstream test program from C technical report

// zcc +cpm -vn -O3 -clib=new open_memstream.c -o openmem -create-app
// zcc +cpm -vn -SO3 -clib=sdcc_iy --max-allocs-per-node200000 open_memstream.c -o openmem -create-app

// zcc +zx -vn -O3 -clib=new open_memstream.c -o openmem -create-app
// zcc +zx -vn -SO3 -clib=sdcc_iy --max-allocs-per-node200000 open_memstream.c -o openmem -create-app

#include <stdio.h>
#include <stdlib.h>

int main(void)
{
   FILE *stream;
   char *buf;
   size_t len;

   stream = open_memstream(&buf, &len);

   if (stream == NULL)
      perror("open_memstream");
   else
   {
      fprintf(stream, "hello my world");
      fflush(stream);
      
      printf("buf=%s, len=%zu\n", buf, len);
      
      fseek(stream, 0, SEEK_SET);
      fprintf(stream, "good-bye cruel world");
      
      fclose(stream);
      printf("buf=%s, len=%zu\n", buf, len);
      
      free(buf);
   }

   return 0;
}
