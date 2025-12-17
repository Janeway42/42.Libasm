; void ft_list_push_front(t_list **begin_list, void *data);
; ft_list_push_front() does not return anything

; malloc sets errno in case of insuficient memory failure (ENOMEM - errno.h)

; Registers
; As per the System V AMD64 ABI convention: 
; the first six interger/pointer arguments are passed in the following registers:
; RDI -> first argument
; RSI -> second argument
; RDX -> third argument
; RCX -> fourth argument
; R8 -> fifth argument
; R9 ->  sixth argument
; 
; RAX -> designated return register 
; ---------------------------------------------------------------------------------------
; For ft_list_push_front() this means: 
; RDI   -> t_list **begin_list = &begin_list -> deferenced pointer = the address of the head pointer 
; RSI   -> void *data  = the pointer to data = address of dats 

; RAX   -> default return value 
; ---------------------------------------------------------------------------------------

%define NODE_DATA 0
%define NODE_NEXT 8
%define NODE_SIZE 16
%define ENOMEM 12

section .data 
msg db "Incorrect input!\n", 10, 0

section .text
global  ft_list_push_front
extern malloc
extern __errno_location
extern printf

ft_list_push_front:
    test	rdi, rdi        ; test if input is NULL
    jz		.error_input
    test	rsi, rsi        ; test if input is NULL
    jz		.error_input

	push	rsp				; align stack
	push	rdi				; save begin
	push	rsi				; save data

	mov		rdi, NODE_SIZE			; set the size to be used by malloc call 
	xor		rax, rax				; set RAX (default return value) to 0
	call	malloc wrt ..plt		; the pointer to the memory is output in rax "with respect to the PLT" malloc(sizeof(t_list)) (16)
	test	rax, rax				; if malloc fails and returns a NULL pointer, test will do "0 AND 0 = 0", and set ZF = 1
    jz		.malloc_fail			; if equal to zero jump to .malloc_fail

    pop		rsi				; retrieve data
	pop		rdi				; retrieve begin

	mov		[rax + NODE_DATA], rsi		; move the data in the new node 
	mov		rcx, [rdi]                  ; load head 				
	mov		[rax + NODE_NEXT], rcx		; new.next = *begin
	mov		[rdi], rax					; *begin = new

.malloc_fail:
    call	__errno_location wrt ..plt	; [call ___error] for MacOS. It returns an address pointer to errno "with respect to the PLT" 
    mov		dword [rax], ENOMEM			; errno val for ENOMEM (12) copied at the pointer address. 
    xor		rax, rax					; return null
	jmp		.done	

.error_input:
    mov     rdi, msg
    xor     rax, rax
    call    printf wrt ..plt
    jmp     .done

.done:
	pop		rsp				; align stack
	ret

; rdi  = addrss of a box that contains the head node address
; [rdi] = the actual address of the head node 
; pointer - dereferenced pointer

; PLT (Procedure Linkage Table) is part of the ELF binary format used on Linux
; It contains stubs that jump to dynamically linked functions in shared libraries (ex: malloc in libc.so)
; "wrt ..plt": NASM generates a relocation that tells the linker "resolve this call through the PLT entry for malloc"