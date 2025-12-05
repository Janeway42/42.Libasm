;ssize_t write(int fd, const void *buf, size_t count);
; write() returns on success, the number of bytes written is returned. On error, -1 is returned, 
;       and errno is set to indicate the cause of the error.

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
; For write() this means: 
; RDI   -> int fd
; RSI   -> const void *buf 
; RDX   -> size_t count 
; RAX   -> return value 
; ---------------------------------------------------------------------------------------
; syscall
; RAX -> syscall number
; RDI -> file descriptor 
; RSI -> pointer to buffer 
; RDX -> number of bytes to read 
; ---------------------------------------------------------------------------------------

section .text
global  ft_write
extern __errno_location

ft_write:

	mov	rax, 1				    ; 1 is the syscall number for write and must be placed in RAX before the syscall 
	syscall
	cmp	rax, 0 				    ; check if rax < 0
	jge	.done				    ; SF = 0, ZF = 0
	
	neg	rax					    ; converts rax to a positive value (rax = 0 - rax)
	mov	ebx, eax			    ; save errno val from EAX (lower 32 bit from RAX) to EBX (lower 32 bit of RBX)
	call	__errno_location	; [call ___error] for MacOS. It returns an address pointer to errno
	mov	dword [rax], ebx	    ; errno val from EBX copied at the pointer address. 
                                ; assembler requires to know how many bytes to move when memory is referenced. dword = 4 bytes (32 bits)  
	mov	rax, -1
	jmp	.done

.done:
	ret