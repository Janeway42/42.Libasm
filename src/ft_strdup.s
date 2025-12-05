; char * strdup(const char *str1);
; strdup() returns a pointer to the duplicated string.
;   It returns NULL if insufficient memory was available, with errno set to indicate the error (ENOMEM - errno.h).

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
; For strdup() this means: 
; RDI   -> str1
; RAX   -> return value 
; ---------------------------------------------------------------------------------------

%define ENOMEM 12

section .text
global  ft_strdup
extern malloc
extern ft_strlen
extern ft_strcpy
extern __errno_location

ft_strdup:
	
	push	rdi				; saves the source pointer on the stack as any function calls (call) can overwrite registers
	
	call	ft_strlen		; returns length of str1 in RAX
	
	mov	rdi, rax			; move size of string in RDI
	call	malloc
	test	rax, rax		; if malloc fails and returns a NULL pointer, test will do "0 AND 0 = 0", and set ZF = 1
	jz		.malloc_fail	; if equal to zero jump to .malloc_fail
	
	pop rsi					; restore source pointer from stack in RSI to be used by ft_strcpy
	mov rdi, rax			; move dest (just allocated) string pointer to rdi to be used by ft_strcpy			
	call ft_strcpy
	jmp .done
	
.malloc_fail:
    call	__errno_location	; [call ___error] for MacOS. It returns an address pointer to errno
	mov	dword [rax], ENOMEM	    ; errno val for ENOMEM (12) copied at the pointer address. 

	pop rsi					    ; every push must have a pop to balance the stack. the choice for RSI is arbitrary
	xor rax, rax			    ; make RAX = 0 to be able to return NULL
	jmp .done

.done:
	ret