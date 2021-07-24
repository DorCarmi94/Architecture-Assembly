#include <stdio.h>
extern void assFunc(int x, int y);
char c_checkValidity(int x, int y)
{
    if(x>=y)
    {
        return 1;
    }
    else
    {
        return 0;
    }
    
}
int main(int argc, char** argv)
{
    int x,y;
    printf("Enter x: \n");
    scanf("%d",&x);
    printf("Enter y: \n");
    scanf("%d",&y);
    printf("The numbers entered: x={%d}, y={%d}\n",x,y);
    printf("The z answer is:\n");
    assFunc(x,y);
    printf("\n");
    
    return 0;
}