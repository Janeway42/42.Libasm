; ssize_t read(int fd, void *buf, size_t count);
; read() returns on success the number of bytes read or -1 on error with errno being set. 

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
; For read() this means: 
; RDI   -> int fd
; RSI   -> void *buf
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
global  ft_read
extern __errno_location

ft_read:

	mov	rax, 0				; 0 is the syscall number for read and must be placed in RAX before the syscall 
	syscall
	cmp	rax, 0				; check if rax < 0
	jge	.done				; SF = 0, ZF = 0

	neg	rax								; converts rax to a positive value (rax = 0 - rax)
	mov	ebx, eax						; save errno val from EAX (lower 32 bit from RAX) to EBX (lower 32 bit of RBX)
	call	__errno_location wrt ..plt	; [call ___error] for MacOS. It returns an address pointer to errno "with respect to the PLT" 
	mov	dword [rax], ebx				; errno val from EBX copied at the pointer address. 
										; assembler requires to know how many bytes to move when memory is referenced. dword = 4 bytes (32 bits)   
	mov	rax, -1
	jmp	.done

.done:
	ret

; PLT (Procedure Linkage Table) is part of the ELF binary format used on Linux
; It contains stubs that jump to dynamically linked functions in shared libraries (ex: malloc in libc.so)
; "wrt ..plt": NASM generates a relocation that tells the linker "resolve this call through the PLT entry for malloc"