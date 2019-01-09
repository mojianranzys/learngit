#include<stdio.h>
#include<stdlib.h>
#include<string.h>
int main()
{
    FILE* fp;
    char read[12]={'\0'};
    char str[]="hello world!";
    char *p;
    p =&str[0];
    int i,n=0;
    fp=fopen("hellodna.txt","rt");
    if(!fp)
   {
        printf("failed open file");
        exit(-1);
    }
    fread(read,1,sizeof(read),fp);
    {
        while(!feof(fp))
        {
            for(i=0;i<=sizeof(fp);i++)
            {
                if(read[i]== *p)
                {
                    p++;
                }
                    if(*p=&str[11])
                   {
                       n++;
                       p =&str[0]
                    }
                else
                  {
                   p =&str[0] 
                   }
            }
        }
    }
   printf("%d/n",n);
   fclose(fp);
   return 0;
}
 