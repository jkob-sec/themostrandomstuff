#include <Sddl.h>
#include <intrin.h>
#include <stdio.h>
#include <Windoows.h>

// Stolen from GH - timb3r
LONG WINAPI HandleExceptions(EXCEPTION_POINTERS* ExceptionInfo)
{
    if (ExceptionInfo->ExceptionRecord->ExceptionCode == EXCEPTION_ACCESS_VIOLATION)
    {
        printf("EXCEPTION_ACCESS_VIOLATION occured at: %p\n", ExceptionInfo->ContextRecord->Rip);
        ExitProcess(-1);
    }
    return EXCEPTION_CONTINUE_SEARCH; // Pass to the next handler
}

int main()
{
    LPVOID pHandle = AddVectoredExceptionHandler(1ul, HandleExceptions);
    if (!pHandle)
        return -1;

    char* buffer = NULL;

    strcpy(buffer, "This is a test string.\n");
    printf("%s\n", buffer);

    delete []buffer;

    RemoveVectoredContinueHandler(pHandle);

    return 0;
}

