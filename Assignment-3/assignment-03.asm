section .data
    fNameMsg DB 'Enter your first name: ', 0x00
    fNameScanf DB '%s', 0x00
    lNameMsg DB 'Enter your last name: ', 0x00
    nameMsg  DB 'Hello %s %s!', 0xA, 0x00
	
section .text
global _start
extern printf, scanf, puts, exit

_start: 

    push ebp
    mov ebp, esp
    ;making room on the stack for local variables
    sub esp, 0x3Ec ;500 for each variable
    ;lea eax, [ebp+0x3eC]   ; first variable
    push fNameMsg
    call  puts
    lea ebx, [ebp-0x3ec]
    push ebx
    push fNameScanf
    call scanf
    add esp, 0x8 ; clean up stack for scanf
    push lNameMsg
    call puts
    lea ebx, [ebp-0x1f8]
    push ebx
    push fNameScanf
    call scanf
    add esp, 0x8

    ;displaying the results
    lea ebx, [ebp-0x1f8]
    push ebx
    lea ebx, [ebp-0x3ec]
    push ebx
    push nameMsg
    call printf
    add esp, 0xc

    add	esp, 0x8
    mov	esp, ebp
    pop	ebp
    push 0
    call exit
