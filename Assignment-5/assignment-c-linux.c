#include <stdio.h>

int main()
{
    unsigned int secondsInput = 0;
    unsigned int hours = 0;
    unsigned int minutes = 0;
    unsigned int seconds = 0;
    printf("Enter the amounf of seconds: ");
    scanf("%ud", &secondsInput);
    hours = secondsInput / 60 / 60;
    seconds = secondsInput - (hours * 60 * 60);
    minutes = seconds  / 60;
    seconds = seconds - (minutes * 60);
    printf("%d seconds is equal to %d hours, %d minutes, and %d seconds\n", secondsInput, hours, minutes, seconds);
    return 0;
}
