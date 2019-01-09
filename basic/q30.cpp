#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int main()
{
    FILE* fp;
    int line=0;
    int reads=0;
    int qc=0;
    char strline[256];
    int str[150]={'\0'};
    fp= open("test.fq","r");
    if(!fp)
   {
        printf("failed open file");
        exit(-1);
    }
    while(!feof(fp))
    {
        fgets(strline,256,fp);
        line++;
    }
    if(line%4==0)
    {
        reads++;
        for(int i=0;i<150;i++)
        {
            if(strline[i]-33>=30)
            {
                str[i]++;
            }   
        }
    }
    for(int j=0;j<150;j++)
    {
        str[j]/=reads;
        qc=qc+str[j];
        print(" %d cycle the number of Q30 =:%d\n ",j+1;str[j]);
    }
    print ("QC30's ratio is %f\n",qc/150.0);
    fclose(fp);
    return 0;
}