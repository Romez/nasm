global int_to_str
global str_to_int
global strlen
global print_number
global print_char
global strcmp

SECTION .bss
    char_ptr resb 1

SECTION .text
    sys_mmap equ 9
    stdout equ 1
    sys_write equ 1

; param 1 rdi
; ret rax, rdx
int_to_str:
    push rbp
    mov rbp, rsp

    ; local vars
    sub rsp, 24
    mov qword [rbp - 8],  0  ; num len
    mov qword [rbp - 16], 0  ; mem ptr
    mov qword [rbp - 24], 0  ; is neg

    mov rcx, 10 ; base 10

    mov rax, rdi
    ;; if neg
    test rax, rax
    jns .push_loop

    ; handler neg value
    neg rax
    mov qword [rbp - 24], 1
    
    ; push digits to stack
    .push_loop:

    xor rdx, rdx
    div rcx

    add rdx, 0x30
    push rdx

    inc qword [rbp - 8]

    cmp rax, 0
    jne .push_loop

    ; add "-" if neg
    cmp qword [rbp - 24], 1
    jne .allocate_mem
    push "-"
    inc qword [rbp - 8]

.allocate_mem:
    ; Allocate memory using mmap
    mov rax, sys_mmap         ; syscall number for mmap
    xor rdi, rdi              ; addr = NULL (let the kernel choose the address)
    mov rsi, qword [rbp - 8]  ; length = n bytes
    mov rdx, 3                ; protection = PROT_READ | PROT_WRITE
    mov r10, 34               ; flags = MAP_PRIVATE | MAP_ANONYMOUS
    xor r8, r8                ; fd = -1 (no file descriptor)
    xor r9, r9                ; offset = 0
    syscall

    ; Check if allocation was successful
    test rax, rax
    js .allocation_failed      ; Jump if the return value is negative (error)
    mov qword [rbp - 16], rax  ; Store the pointer to the allocated memory

    ; pop chars to mem
    mov rcx, 0
    .pop_loop:
    pop rax

    mov rdx, qword [rbp - 16]
    mov [rdx + rcx], rax
    inc rcx

    cmp rcx, qword [rbp - 8]
    jne .pop_loop

    mov rax, qword [rbp - 16]
    mov rdx, qword [rbp - 8]
.exit:
    mov rsp, rbp
    pop rbp
    ret

.allocation_failed:
    mov rax, 1
    call exit

;; param 1 ; rdi ; string ptr 
strlen:
    mov rcx, -1
.count:
    inc rcx
    cmp byte [rdi + rcx], 0
    jnz .count
    
    mov rax, rcx
    ret

exit:
    mov rdi, rax
    mov rax, 60
    syscall
; ~ strlen ~

; param 1 - stack - integer (signed 32-bit) rbp + 16
; save rbp, rbx, forbid r8-r15
; callee balances the stack
; store the digits in the stack, print using single `syscall`
print_number:
    push rbp
    mov rbp, rsp
    ; ---
   
    push rbx
    
    mov rcx, 0
    mov rbx, 10
    
    ; mov rax, qword [rbp + 16]
    mov rax, rdi
    
    test rax, rax
    jns .loop
    neg rax
    
.loop:
    xor rdx, rdx
    div rbx
    
    inc rcx
    
    add rdx, '0'
    sub rsp, 1
    mov byte [rsp], dl
    ; push rdx
    
    cmp rax, 0
    jne .loop
    
    ; ----- end loop
    
    ; check neg
    test rdi, rdi 
    jns .print_num
    sub rsp, 1
    mov byte [rsp], '-'
    inc rcx
    
; start print
.print_num:
    mov rbx, rcx

    mov rsi, rsp
    mov rdx, rbx
    mov rdi, stdout
    mov rax, sys_write
    syscall
    ; end print
    
    add rsp, rbx
 
.exit:
    ; ----- epilogue
    pop rbx
    
    mov rsp, rbp
    pop rbp
    
    ret

; param 1 dil ; char
print_char:
    mov byte [char_ptr], dil

    mov rdx, 1 ; len
    mov rsi, char_ptr ; prt
    mov rdi, stdout
    mov rax, sys_write
    syscall

    ret

; param 1 ; rdi ; ptr to str
str_to_int:
    push rbp
    mov rbp, rsp
    ; -- prolog --

    mov rax, 0 ; acc
    mov rcx, 0
    mov r8, 10

    cmp byte [rdi], '-'
    jne .loop
    inc rcx

.loop:
    movzx rsi, byte [rdi + rcx]
    cmp rsi, 0 ; check str end is 0
    je .end_loop

    xor rdx, rdx
    mul r8

    sub rsi, '0'

    add rax, rsi

    inc rcx

    jmp .loop
.end_loop:
    cmp byte [rdi], '-'
    jne .exit
    neg rax

.exit:
    ; -- epilog --
    mov rsp, rbp
    pop rbp
    ret
; ~ str_to_int ~

; == strcmp ==
; param 1 ; rdi ; string 1
; param 2 ; rsi ; string 2
strcmp:
    mov rcx, 0

.next:
    movzx rax, byte [rdi + rcx] ; p1
    movzx rdx, byte [rsi + rcx] ; p2

    cmp rax, rdx
    jl .less
    jg .greater

    test rax, rdx
    jz .eq

    inc rcx
    jmp .next

.less:
    mov rax, -1
    ret
.greater:
    mov rax, 1
    ret
.eq:
    mov rax, 0
    ret
; ~ strcmp ~