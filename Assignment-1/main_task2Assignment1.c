#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define	MAX_LEN 34			/* maximal input string size */
					/* enough to get 32-bit string + '\n' + null terminator */
extern int convertor(char* buf);

int main(int argc, char** argv)
{
  char buf[MAX_LEN ];
  char *str1=buf;
  char str2[]="q\n";
  char str3[]="q";
  while (1)
  {
    fgets(buf, MAX_LEN, stdin);		/* get user input string */ 
    if(strcmp(str1,str2)==0 || strcmp(str1,str3)==0)
    {
      exit(0);
    }
    convertor(buf);			/* call your assembly function */
  }
  
  

  return 0;
}
