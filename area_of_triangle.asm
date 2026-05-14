global _start

SYS_EXIT  equ 1
SYS_READ  equ 3
SYS_WRITE equ 4
STDIN     equ 0
STDOUT    equ 1


%macro      function 1-*
    %rep %0
        %rotate -1
        push dword %1
    %endrep
    pop eax
    call eax
    add esp, (%0-1)*4
%endmacro

%macro      kernel 1-*
    %if %0 > 1
        push ebx
        %if %0 > 4
            push esi
            push edi
        %endif
    %endif

    %rep %0
        %rotate -1
        push dword %1
    %endrep

    pop eax
    %if %0 > 1
        pop ebx
        %if %0 > 2
            pop ecx
            %if %0 > 3
                pop edx
                %if %0 > 4
                    pop esi
                    %if %0 > 5
                        pop edi
                        %if %0 > 6
                            %error "Can't do Linux syscall with 6+ params"
                        %endif
                    %endif
                %endif
            %endif
        %endif
    %endif

    int 80h
    mov ecx, eax
    and ecx, 0fffff000h
    cmp ecx, 0fffff000h
    jne %%ok
    mov ecx, eax
    neg ecx
    mov eax, -1
    jmp short %%q

%%ok:
    xor ecx, ecx
%%q:
    %if %0 > 1
        %if %0 > 4
            pop edi
            pop esi
        %endif
        pop ebx
    %endif
%endmacro

section .data
        
        base_ask_msg db "please, write base length of triangle:", 0
        base_ask_msg_len equ $-base_ask_msg
        high_ask_msg db "please, write high length of triangle:", 0
        high_ask_msg_len equ $-high_ask_msg
        debug_msg db "debug", 10, 0
        debug_msg_len equ $-debug_msg
        res_msg db "area of triangleis:", 0
        res_msg_len equ $-res_msg
        nlstr db 10, 0
        nlstr_len equ $-nlstr

section .bss
        area    resd    5
        base    resd    5
        high    resd    5
        buf    resd    5
        length    resd    5

section .text   

triangle_area:
        push ebp
        mov ebp, esp
        push ebx

        mov ebx, [ebp+8]
        mov eax, [ebp+12]

        mul ebx

        xor edx, edx
        mov ebx, 2
        div ebx

        pop ebx
        mov esp, ebp
        pop ebp
        ret

print_two_digit_num: 
        push ebp
        mov ebp, esp
        mov eax, [ebp+8]
        sub esp, 4

        xor edx, edx
        mov ebx, 10
        div ebx

        mov dword [ebp-4], edx

        mov dword [buf], eax
        add dword [buf], 48 
        kernel SYS_WRITE, STDOUT, buf, 1

        mov edx, dword [ebp-4]

        mov dword [buf], edx
        add dword [buf], 48 
        kernel SYS_WRITE, STDOUT, buf, 1

        mov esp, ebp
        pop ebp
        ret
    
read_two_digit_num: 
        push ebp
        mov ebp, esp
        mov eax, [ebp+8]

        kernel SYS_READ, STDIN, buf, eax       
        sub byte [buf], 48

        cmp byte [buf+1], 48
        jb .quit
        sub byte [buf+1], 48
        xor eax, eax
        mov bh, 10
        mov al, byte [buf]

        mul bh
        
        add al, byte [buf+1]

        mov ebx, buf
        xor ebx, buf
        mov dword [buf], eax
.quit:  
        mov esp, ebp
        pop ebp
        ret

_start:
        kernel SYS_WRITE, STDOUT, high_ask_msg, high_ask_msg_len

        mov dword [length], 5
        function read_two_digit_num, length

        mov eax, dword [buf]
        mov dword [high], eax

        kernel SYS_WRITE, STDOUT, base_ask_msg, base_ask_msg_len

        mov dword [length], 5
        function read_two_digit_num, length

        mov eax, dword [buf]
        mov dword [base], eax

        function triangle_area, dword [high], dword [base] 

        mov dword [buf], eax

        function print_two_digit_num, dword [buf]

        kernel SYS_WRITE, STDOUT, nlstr, nlstr_len
        kernel SYS_EXIT, 0