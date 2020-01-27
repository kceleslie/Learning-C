#include <stdio.h>

#define PI 3.14

int main(int argc, char *argv[])
{
    float radius = 0;
    printf("Enter the radius of your circle: ");
    scanf("%f", &radius);
    printf("The area of your circle is %f\n", radius * radius * PI);

    return 0;
}
