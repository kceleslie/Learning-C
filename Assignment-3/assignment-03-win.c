#include <Windows.h>

int main(void)
{
    char fName[500];
    char lName[500];
	char fmessage[] = "Enter your first name: ";
	char lmessage[]  = "Enter your last name: ";
	DWORD charsWritten = 0;

    HANDLE stdInput = GetStdHandle(STD_INPUT_HANDLE);
	HANDLE stdOutput = GetStdHandle(STD_OUTPUT_HANDLE);
	
	if(WriteConsoleA(stdOutput, fmessage, strlen(fmessage), &charsWritten, NULL) == 0)
		return 0;
	if(WriteConsoleA(stdOutput, lmessage, strlen(lmessage), &charsWritten, NULL) == 0)
		return 0;

    CloseHandle(stdInput);
	CloseHandle(stdOutput);
}