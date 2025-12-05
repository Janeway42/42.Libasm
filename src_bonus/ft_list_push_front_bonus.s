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

section .text
global  ft_list_push_front
extern malloc
extern __errno_location

ft_list_push_front:
	push rsp						; align stack 
	push rdi						; save address of head pointer
	push rsi						; save data value
	
	mov rdi, NODE_SIZE				; set the size to be used by malloc call
	call malloc						; the pointer to the memory is output in rax
	test	rax, rax				; if malloc fails and returns a NULL pointer, test will do "0 AND 0 = 0", and set ZF = 1
	jz		.malloc_fail			; if equal to zero jump to .malloc_fail
	
	pop rsi
	mov [rax + NODE_DATA], rsi		; move the data in the new node 
	
	pop rdi
    mov r9, [rdi]                   ; load the actual address of the head node 
	mov [rax + NODE_NEXT], r9	; [rdi] = the actual address of the head node 
	
	mov [rdi], rax					; move the value of the address of the new head pointer into RDI as address
	jmp .done
	
.malloc_fail:
    call	__errno_location        ; [call ___error] for MacOS. It returns an address pointer to errno
    mov	dword [rax], ENOMEM	        ; errno val for ENOMEM (12) copied at the pointer address. 
	
    pop rdi
	pop rsi 
	jmp .done				
	
.done:
	pop rsp
	ret
	
	; rdi  = addrss of a box that contains the head node address
	; [rdi] = the actual address of the head node 
	; pointer - dereferenced pointer

