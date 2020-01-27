#include <stdio.h>
#include <Windows.h>

#define PI 3.14

int main()
{
    float userNumber;
	float result;
	HANDLE stdInput, stdOutput;
	char outputmsg[] = "Enter the radius of your circle: ";
	char resultmsg[500];
	char inputBuffer[100];
	DWORD charsWritten = 0;
	
	stdInput = GetStdHandle(STD_INPUT_HANDLE);
	stdOutput = GetStdHandle(STD_OUTPUT_HANDLE);
	
	//Print to the users screen
	if(WriteConsole(stdOutput, outputmsg, strlen(outputmsg), &charsWritten, NULL) == 0)
	    return 0;
	if(ReadConsole(stdInput, inputBuffer, 95, &charsWritten, NULL) == 0)
	    return 0;
	//Convert input into float
	userNumber = atof(inputBuffer);
	result = userNumber * userNumber * PI;
	
	//format the string to include the result
	sprintf_s(resultmsg, 500, "The area of your circle is %f", result);
	
	if(WriteConsole(stdOutput, resultmsg, strlen(resultmsg), &charsWritten, NULL) == 0)
	    return 0;
	
	CloseHandle(stdInput);
	CloseHandle(stdOutput);
	
	return 0;
}