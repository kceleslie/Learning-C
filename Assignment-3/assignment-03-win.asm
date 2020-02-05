; to compile
; ml64 assignment-03-win.asm /link /subsystem:console /defaultlib:libucrt.lib/defaultlib:kernel32.lib /defaultlib:user32.lib /entry:Start
; This works with sprintf and other depreciated functions
; ml64 assignment-03-win.asm /link /subsystem:console /defaultlib:msvcrt.lib /defaultlib:kernel32.lib /defaultlib:user32.lib /defaultlib:libucrt.lib /defaultlib:legacy_stdio_definitions.lib /entry:Start
;
; Cant seem to get sprintf to work under windows as MS changed it. the "extrn sprintf: PROC" line causes the system to crash for an unknown reason but the call
; works and the string is formatted correctly. 
;includelib msvcrt

extrn ExitProcess: PROC
extrn WriteConsoleA: PROC
extrn GetStdHandle: PROC
extrn strlen: PROC
extrn sprintf: proc
extrn CloseHandle: PROC
extrn ReadConsoleA: PROC
extrn GetLastError: PROC




.data
fname db 'Enter your first name: ', 0
lname db 'Enter your last name: ', 0
ftstring db 'Hello %s %s, hope you are good!', 10, 0
;         db 1024 DUP(1)
finalMessage db 1100 DUP(1)
;Need to allocate 1000 bytes of memory for first and last name to be placed in this string

.code

;------
; Stack
; rsp 		= STD OUTPUT HANDLE
; rsp + 8 	= STD INPUT HANDLE
; rsp + 16	= bytes written
; rsp + 24 	= start of buffer1, fname
; rsp + 524	= start of buffer2, lname
; rsp + 1024 = saved rbp
;-----

Start PROC

push rbp
mov rbp, rsp
and rsp, -16
sub rsp, 400h		; Saving space on the stack, allocating for 3 8 byte variables


; stdOutputHandle = GetStdHandle(-11)
mov ecx, -11		; Getting HANDLE to Std_OUTPUT_HANDLE
call GetStdHandle
mov qword ptr[rsp], rax	; save std output handle

; stdInputHandle = GetStdHandle(-10)
mov ecx, -10		; Getting HANDLE to Std_OUTPUT_HANDLE
call GetStdHandle
mov qword ptr[rsp+8], rax	; save std output handle

;strlen(message) - Get the string length of message, instead of hardcoding. 
lea rcx, fname
call strlen
mov r8, rax

; WriteConsoleA(handle, message, msglen, outputChars, NULL)
mov rcx, qword ptr[rsp]	; std output handle
lea r9, qword ptr[rsp+16]	; save num of bytes written
lea rdx, fname
push 0
call WriteConsoleA
add rsp, 8			; clean up stack
cmp rax, 0
je finished

;----------------
; Getting user input
;----------------
; ReadConsole(inputHandle, storageBuffer, charsToRead, numOfCharsRead, NULL
mov rcx, qword ptr[rsp+8]		;handle
lea rdx, qword ptr[rsp+24]		;buffer
mov r8, 500
lea r9, qword ptr[rsp+16]		;num of chara read
push 0
call ReadConsoleA
add rsp, 8
cmp rax, 0
je finished

; Writing 2nd message

;strlen(message) - Get the string length of message, instead of hardcoding. 
lea rcx, lname
call strlen
mov r8, rax
; WriteConsoleA(handle, message, msglen, outputChars, NULL)
mov rcx, qword ptr[rsp]		; std output handle
lea r9, qword ptr[rsp+16]	; save num of bytes written
lea rdx, lname
push 0
call WriteConsoleA
add rsp, 8			; clean up stack
cmp rax, 0
je finished

;----------------
; Getting user input
;----------------
; ReadConsole(inputHandle, storageBuffer, charsToRead, numOfCharsRead, NULL
mov rcx, qword ptr[rsp+8]		;handle
lea rdx, qword ptr[rsp+524]		;buffer
mov r8, 500
lea r9, qword ptr[rsp+16]		;num of chara read
push 0
call ReadConsoleA
add rsp, 8
cmp rax, 0
je finished

;---------------
; removing \r\n from string
;---------------
;	fName[numOfChars-2] = '\0';
; need to get lenth and use that in the calculation
lea rcx, qword ptr [rsp+24]
call strlen
mov qword ptr[rsp+24+rax-2], 0
lea rcx, qword ptr [rsp+524]
call strlen
mov qword ptr[rsp+524+rax-2], 0

;---------------
; sprintf(finalMessage, "Hello %s %s!\n", fName, lName);
;---------------
lea rcx, finalMessage
lea rdx, ftstring
lea r8, qword ptr[rsp+24]
lea r9, qword ptr[rsp+524]
sub rsp, 32						; for some reason sprintf expects arguments on the stack, as it copies the values from the registers to this space
call sprintf
add rsp, 32

;----------------
; Printing the string
;----------------

;strlen(message) - Get the string length of message, instead of hardcoding. 
lea rcx, finalMessage
call strlen
mov r8, rax
; WriteConsoleA(handle, message, msglen, outputChars, NULL)
mov rcx, qword ptr[rsp]		; std output handle
lea r9, qword ptr[rsp+16]	; save num of bytes written
lea rdx, finalMessage
push 0
call WriteConsoleA
add rsp, 8			; clean up stack

finished: 
; Close both std input and std output handles
mov rcx, qword ptr[rsp]		; top of stack contains handle
call CloseHandle
mov rcx, qword ptr[rsp+8]		; top of stack contains handle
call CloseHandle

add rsp, 400h
mov rsp, rbp
pop rbp
mov rcx, 0
call ExitProcess
Start ENDP
END