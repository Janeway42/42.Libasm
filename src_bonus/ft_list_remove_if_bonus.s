; void ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)(), void (*free_fct)(void *));
; ft_list_remove_if() does not return anything

; The functions pointed to by cmp and free_fct will be used as:
; (*cmp)(list_ptr->data, data_ref);
; (*free_fct)(list_ptr->data);

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
; For ft_list_remove_if() this means: 
; RDI   -> t_list **begin_list = &begin_list -> deferenced pointer = the address of the head pointer 
; RSI   -> void *data_ref
; RDX	-> int (*cmp)()
; RCX	-> void (*free_fct)(void *)

; RAX   -> default return value 
; ---------------------------------------------------------------------------------------

%define NODE_DATA 0
%define NODE_NEXT 8
%define NODE_SIZE 16

section .text
global  ft_list_remove_if

ft_list_remove_if:
	mov r9, rdi			; save begin_list
	
	mov rdi, [r9]		; load head in RDI so the cmp function can use it as s1 and RSI as s2
	test rdi, rdi		; if NULL test will do "0 AND 0 = 0", and set ZF = 1
	jz .done
	
.loop_first:
	call rdx			; call compare function with first node in RDI and data_ref as s2 IN RSI
	test rax, rax		; if NULL test will do "0 AND 0 = 0", and set ZF = 1
	jz .remove_first
	jmp .loop_rest
	
.remove_first:
	call rcx						; call free function 
    mov rax, [r9 + NODE_NEXT]       ; temp storage to get the value at the memory location  
	mov [r9], rax		; connect to the next node jumping the deleted one 
	test r9, r9						; if NULL test will do "0 AND 0 = 0", and set ZF = 1
	jz .done
	mov rdi, [r9]					; load new head
	jmp .loop_first
	
.loop_rest:
	mov r8, rdi						; save node we just checked (it now becomes previous)
	mov rdi, [rdi + NODE_NEXT]		; load next node to be compared 
	test rdi, rdi                   ; if NULL test will do "0 AND 0 = 0", and set ZF = 1
	jz	.done
	call rdx						; call compare function with first node in RDI and data_ref as s2 IN R
	jz .remove_rest
	jmp .loop_rest					; restart loop so you can verify next node 
	
.remove_rest:
	call rcx						; call free function
    mov rax, [rdi + NODE_NEXT]       ; temp storage to get the value at the memory location  
	mov [r8 + NODE_NEXT], rax		; connect to the next node jumping the deleted one 
	mov rdi, r8                     ; add previous in rdi so that it remains previous once .loop-rest begins
	jmp .loop_rest

.done:
	ret