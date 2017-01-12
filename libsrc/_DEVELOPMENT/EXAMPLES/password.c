
// zcc +cpm -vn -startup=4 -O3 -clib=new password.c -o password -create-app
// zcc +cpm -vn -startup=4 -SO3 -clib=sdcc_iy --max-allocs-per-node200000 password.c -o password -create-app

// zcc +zx -vn -startup=8 -O3 -clib=new password.c -o password -create-app
// zcc +zx -vn -startup=8 -clib=sdcc_iy --max-allocs-per-node200000 password.c -o password -create-app

#include <stdio.h>
#include <stropts.h>
#include <string.h>
#include <adt.h>

#ifdef __SPECTRUM
#include <arch/zx.h>
#endif

b_array_t edit_buffer;

char username[20];
char password[20];

main()
{

#ifdef __SPECTRUM

   zx_border(INK_WHITE);
   ioctl(1, IOCTL_OTERM_CLS);

#endif

   printf("USERNAME + PASSWORD QUERY\n");
   printf("username pushed into edit buffer\n");
      
   // gather details about the input terminal's buffer
   
   ioctl(0, IOCTL_ITERM_GET_EDITBUF, &edit_buffer);
   
   while(1)
   {
      printf("\n=====\n\nUsername: ");

      // push last username into edit buffer

      fflush(stdin);
      
      edit_buffer.size = strlen(username);
      strcpy(edit_buffer.data, username);
      ioctl(0, IOCTL_ITERM_SET_EDITBUF, &edit_buffer);
      
      // read username
      
      scanf("%19[^\n]", username);
      
      // read password
      
      printf("Password: ");
      
      ioctl(0, IOCTL_ITERM_PASS, 1);
      
      fflush(stdin);
      scanf("%19[^\n]", password);
      
      ioctl(0, IOCTL_ITERM_PASS, 0);
      
      // echo
      
      printf("\n\"%s\"\n", username);
      printf("\"%s\"\n", password);
   }
}
