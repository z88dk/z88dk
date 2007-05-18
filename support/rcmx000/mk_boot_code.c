#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int debug_file=0;
static int debug_parse=0;

static int debug_lookup=0;

static int debug_out=0;

/** List of labels to look out for and store in our table */

static const char* s_labels[] = {
  "__PATCH_BAUDRATE",
  "__PREFIX",
  "__POSTFIX",
  "__START_PROG",
  "__END_PROG", 
  ""};

static int *s_values;

static FILE* openfile(const char* str, const char* mode)
{
  FILE *retval;
  
  if (debug_file) fprintf(stderr, "Attempt to open file: ``%s'' with mode ``%s''\n", str, mode);

  retval=fopen(str, mode);

  if (retval==NULL)
    {
      fprintf(stderr, "File: ``%s'' could not be opened\n", str);
      exit(1);
    }
  return retval;
  
}

static int get_hex(const char* pek)
{
  int retval;
  const char* peki=pek;
  
  /** state=0 (init) state=1 found '=' state=2 reading_hex */
  
  int state=0;
  
  while (peki-pek<1024)
    {
      switch(state)
	{
	case 0:
	  {
	    if (*peki=='=') state=1;
	    break;
	  }
	case 1:
	  {
	    if (*peki!=' ') state=2;
	    break;
	  }
	case 2:
	  {
	    if (debug_parse) fprintf(stderr, "Reading hex: %s", peki);

	    sscanf(peki, "%x", &retval);

	    if (debug_parse) fprintf(stderr, "value: %d (dec) %x (hex)\n\n", retval, retval);
	    return retval;

	    break;
	  }
	default:
	  {
	    fprintf(stderr, "Parse error in sym file\n");
	    exit(1);
	  }
	}
      peki++;
    }
  return retval;
}

/** Called once by main to malloc */
static int check_value_size()
{
  int val=0;

  while (s_labels[val][0]!='\0')
    {
      val++;
    }

  return val;
  
}

static int lookup(const char* labelstr)
{
  int retval=0;

  if (debug_lookup)
    {
      fprintf(stderr, "Looking up: ``%s''\n", labelstr);
    }
  
  while (s_labels[retval][0]!='\0')
    {
      int l1=strlen(s_labels[retval]);
      int l2=strlen(labelstr);
      
      if (l1==l2)
	{
	  if (0==strncmp(labelstr, s_labels[retval], l1))
	    {
	      if (debug_lookup)
		{
		  fprintf(stderr, "Found ix: %d, value=%.4x\n", retval, s_values[retval]);
		}
	      return retval;
	    }
	}
      
      retval++;
    }

  if (debug_lookup)
    {
      fprintf(stderr, "Label: ``%s'' not found, returning -1\n", labelstr);
    }
  return -1;  
}


static void read_symfile(FILE* symfile, int* values)
{
  char buf[1024];
  char label[1024];
   
  int i;
  
  for (i=0;i<10;i++)
    {
      fgets(buf, 1024, symfile);
    }

  while (!feof(symfile))
    {
      int ix;

      char *pek;

      fgets(buf, 1024, symfile);

      pek=buf;
      
      while (*pek!='\n') pek++;

      if (debug_file) fprintf(stderr, "scanned one line in symfile: <<<%s>>>\n", buf);
      
      {
	/* Lookup */
	int peki;

	label[0]='\0';
	
	ix=-1;

	for (peki=0;;peki++)
	  {
	    if ( (buf[peki])==' ' ||
		 (buf[peki])=='\n' ||
		 (buf[peki])=='\t' ||
		 (buf[peki])=='\r') 
	      {
		label[peki]='\0';
		
		/** Now we are ready to call lookup routine */
		ix=lookup(label);
		break;
	      }

	    label[peki]=buf[peki];
		

	  }
      }

      if (ix==-1) continue;

      values[ix]=get_hex(buf);
    }
}

static void usage(const char* name)
{
  fprintf(stderr, "Usage: %s [-r] <symfile> <binfile> <loadfile (out)>\n", name);
  exit(1);
}


int main(int argc, char* argv[])
{
  FILE* symfile;  /** File with sym pointers to program start/end */
  FILE* binfile;  /** Binary file with the i/o in three bytes and
		      code in normal way */
  
  FILE* loadfile; /** This contains a format suitable for feeding
		   *  the cold boot feature of rcm2/3000
		   */
  
  int start_prog_ix=-1, prefix_ix=-1, postfix_ix=-1, end_prog_ix=-1;
  int start_prog, prefix, postfix, end_prog;
  
  int i;
  unsigned char byte, value;
  
  int do_raw=0;

  s_values=(int*)malloc(sizeof(int) * check_value_size());
  
  if (argc!=4 && argc!=5)
    {
      usage(argv[0]);
    } 

  if (argc==4)
    {
      symfile=openfile(argv[1], "r");
      binfile=openfile(argv[2], "rb");
      loadfile=openfile(argv[3], "wb");
    }

  if (argc==5)
    {
      if (0==strncmp(argv[1], "-r", 2))
	{
	  do_raw=1;
	}
      else
	{
	  usage(argv[0]);
	}
      symfile=openfile(argv[2], "r");
      binfile=openfile(argv[3], "rb");
      loadfile=openfile(argv[4], "wb");
    }

  read_symfile(symfile, s_values);

  start_prog_ix=lookup("__START_PROG");
  prefix_ix=lookup("__PREFIX");
  postfix_ix=lookup("__POSTFIX");
  end_prog_ix=lookup("__END_PROG");

  if (start_prog_ix==-1 || prefix_ix==-1 || postfix_ix==-1 || end_prog_ix==-1)
    {
      fprintf(stderr, "symbol file does not contain correct labels\n");
      fprintf(stderr, "Labels needed: __PREFIX, __POSTFIX, __START_PROG and __END_PROG\n");
      exit(1);
    }

  start_prog = s_values[start_prog_ix];
  prefix     = s_values[prefix_ix];
  postfix    = s_values[postfix_ix];
  end_prog   = s_values[end_prog_ix];
    
  if (debug_parse) fprintf(stderr, "Start: %d, End: %d\n", start_prog, end_prog);

  
  /** First send the io-bytes we need to make target work at all... */
  
  fseek(binfile, prefix, SEEK_SET);
  
  /** Bypass beginning bytes */
  for (i=0;i<postfix-prefix;i++)
    {
      fread(&byte, 1, 1, binfile);
      fwrite(&byte, 1, 1, loadfile);
    }
  
  /** Now we send the bootstrap.asm beginning from address 0 */
  
  fseek(binfile, 0, SEEK_SET);  
  
  if (do_raw)
    {
      i=0;

      /**
       *  This will make a .LOD file to load all data from the .bin file into
       *  the target's memory in a very inefficient manner (2400 baud and 
       *  three bytes per byte :-( and then start
       *  executing and yes this means that the magic I/O bytes 
       *  themselves will be lying there as dead meat, but at this stage
       *  we want to make things easy and keep a flat memory model!!!
       */

      while (1)
	{
	  /** First read to check eof */
	  fread(&value, 1, 1, binfile);
	  if (feof(binfile)) break;

	  /** After that, send two bytes with the address */
	  byte=i/256;
	  if (debug_out) fprintf(stderr, "byte(hi)=%d\n", byte);
	  fwrite(&byte, 1, 1, loadfile);
	  
	  byte=i&255;
	  if (debug_out) fprintf(stderr, "byte(lo)=%d\n", byte);
	  fwrite(&byte, 1, 1, loadfile);
	  
	  /** Then the data for this byte */
	  if (debug_out) fprintf(stderr, "value=%.2x\n", value);
	  fwrite(&value, 1, 1, loadfile);

	  i++;
	}
    }
  else
    {
      for (i=0;i<prefix-start_prog;i++)
	{
	  /** First send two bytes with the address */
	  byte=i/256;
	  if (debug_out) fprintf(stderr, "byte(hi)=%d\n", byte);
	  fwrite(&byte, 1, 1, loadfile);
	  
	  byte=i&255;
	  if (debug_out) fprintf(stderr, "byte(lo)=%d\n", byte);
	  fwrite(&byte, 1, 1, loadfile);
	  
	  /** Then the data for this byte */
	  fread(&byte, 1, 1, binfile);
	  fwrite(&byte, 1, 1, loadfile);
	}
    }
  
  fseek(binfile, postfix, SEEK_SET);
  
  /**
   *  After sending these three bytes the target starts running
   *  the loaded code
   */
  for (i=0;i<end_prog-postfix;i++)
    {
      fread(&byte, 1, 1, binfile);
      fwrite(&byte, 1, 1, loadfile);
    }
  
  fclose(symfile);
  fclose(binfile);
  fclose(loadfile);
  
  free(s_values);
  
  return 0;
}
