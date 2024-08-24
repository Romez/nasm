global _start

extern printf

section .bss
    filename resq 1

section .data
    stdout equ 1

    sys_read_file equ 0
    sys_write_file equ 1
    sys_open_file equ 2
    sys_close_file equ 3
    sys_exit equ 60

    file_path_str db 'File path: %s', 10, 0
    error_msg db 'Error opening file!', 10, 0

    buffer_size equ 1024
    buffer times buffer_size db 0

section .text
%macro Exit 1
    mov rax, sys_exit
    mov rdi, %1
    syscall
%endmacro

%macro Print 2
    mov rsi, %1
    mov rdx, %2
    mov rax, sys_write_file
    mov rdi, stdout
    syscall
%endmacro

_start:
    ; store filename
    mov rax, [rsp + 16]
    mov [filename], rax

    mov rdi, file_path_str
    mov rsi, [filename]
    call printf

    ; open file
    mov rax, sys_open_file
    mov rdi, [filename]
    mov rsi, 0
    mov rdx, 0
    syscall

    test rax, rax
    js file_open_error

    ; file descriptor
    mov r12, rax

read_file:
    ; read file
    mov rax, sys_read_file
    mov rdi, r12
    mov rsi, buffer
    mov rdx, buffer_size
    syscall

    test rax, rax ; number of read bytes
    jz close_file

    Print buffer, rax

    jmp read_file

close_file:
    mov rax, sys_close_file
    mov rdi, r12
    syscall

    Exit 0

file_open_error:
    mov rdi, error_msg
    call printf

    Exit 1

; nasm -g -f elf64 hello.asm
; ld-o hello hello.o
; ld --dynamic-linker=/lib64/ld-linux-x86-64.so.2 -lc mycat.o -o mycat
; gcc readfile_example.o -o readfile_example

; gdbgui --args ./mycat a

; rdi: First argument
; rsi: Second argument
; rdx: Third argument
; rcx: Fourth argument
; r8: Fifth argument
; r9: Sixth argument