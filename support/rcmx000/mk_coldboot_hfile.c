
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
  int i, num_to_read;

  unsigned char ch;
  unsigned char *chs;

  FILE *coldboot;

  coldboot=fopen(argv[1], "rb");
  
  if (coldboot==NULL)
    {
      fprintf(stderr, "Could not open %s\n", argv[1]);
      exit(1);
    }
  
  num_to_read=0;

  while (1)
    {
      fread(&ch, 1, 1, coldboot);
      if (feof(coldboot)) break;
      num_to_read++;
    }

  i=0;

  fseek(coldboot, 0, SEEK_SET);

  chs=(char*)malloc(num_to_read);

  while (1)
    {
      fread(&chs[i], 1, 1, coldboot);

      if (feof(coldboot)) break;

      i++;
    }


  printf("#ifndef __BOOTBYTES__H\n");
  printf("#define __BOOTBYTES__H\n\n");

  printf("static const int s_num_bytes = %d;\n", num_to_read);

  printf("static const unsigned char s_lodfile[] = {\n");

  for (i=0;i<num_to_read;i++)
    {
      if (i%16==0) printf("    ");

      printf("0x%.2x", chs[i]);

      if (i!=num_to_read-1)
	{
	  printf(",");
	}
      
      if (i%16==15 || i==num_to_read-1)
	{
	  printf("\n");
	}
      else
	{
	  printf(" ");
	}
    }

  printf("};\n\n");
  
  printf("#endif\n");
  
  free(chs);

  return 0;
}
