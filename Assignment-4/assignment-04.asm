section .bss
 numberEntered resd 1

section .data
 enterMessage  db 'Enter the radius of your circle: ', 0x00
 scanfFormat   db '%f', 0x00
 resultMessage db 'The area of your circle is %f', 0xA, 0x00
 fsPI	       dd 3.14

section .text
extern printf, scanf, exit
global _start

_start: 

    mov rdi, enterMessage
    call printf
    mov rdi, scanfFormat
    mov rsi, numberEntered
    call scanf
    mov rdi, resultMessage
    movss xmm0, dword [numberEntered]
    movss xmm1, dword [fsPI]
    ;multiple xmm0 with xmm0 then * PI
    mulss xmm0, xmm0
    mulss xmm0, xmm1
    movss dword [numberEntered], xmm0
    cvtss2sd xmm0, xmm0
    mov esi, dword [numberEntered]
    call printf
    mov rdi, 0
    call exit
