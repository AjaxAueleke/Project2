INCLUDE Irvine32.inc
INCLUDE macros.inc
BUFFER_SIZE = 5000
.data
buffer BYTE BUFFER_SIZE DUP(0)
filename BYTE 80 DUP(0)
fileHandle HANDLE ?
buffer2 BYTE BUFFER_SIZE DUP (0)
filename2 BYTE 80 DUP(0)
fileHandle2 HANDLE ?
fileSize1 dword ?
fileSize2 dword ?
string1 byte 5000 DUP(0)
string2 byte 5000 DUP(0)
counter dword 0

first_word_count dword 0
second_word_count dword 0
.code
main PROC


mWrite "Enter name for File 1:"
mov edx,OFFSET filename
mov ecx,SIZEOF filename
call ReadString

;--------------------------------------
; Open the file for input.
mov edx,OFFSET filename
call OpenInputFile
mov fileHandle,eax
;--------------------------------------

;--------------------------------------
; Read the file into a buffer.

mov edx,OFFSET buffer
mov ecx,BUFFER_SIZE
call ReadFromFile
mov buffer[eax],0 ; insert null terminator
;---------------------------------------

;--------------------------------------
mWrite "File1 size: "
call WriteDec ; display file size
mov fileSize1, eax
call Crlf
; Display the buffer.
mWrite <"File1 Buffer:",0dh,0ah,0dh,0ah>
mov edx,OFFSET buffer ; display the buffer
call WriteString
call Crlf
mov eax,fileHandle
call CloseFile
;--------------------------------------



mWrite "Enter name for File 2:"
mov edx,OFFSET filename2
mov ecx,SIZEOF filename2
call ReadString

;--------------------------------------
; Open the file for input.
mov edx,OFFSET filename2
call OpenInputFile
mov fileHandle2,eax
;--------------------------------------

;--------------------------------------
; Read the file into a buffer.

mov edx,OFFSET buffer2
mov ecx,BUFFER_SIZE
call ReadFromFile
mov buffer2[eax],0 ; insert null terminator
;---------------------------------------

;--------------------------------------
mWrite "File2 size: "
call WriteDec ; display file size
mov fileSize2, eax
call Crlf
; Display the buffer.
mWrite <"File2 Buffer:",0dh,0ah,0dh,0ah>
mov edx,OFFSET buffer2 ; display the buffer
call WriteString
call Crlf
mov eax,fileHandle2
call CloseFile
;--------------------------------------

INVOKE Str_length, ADDR buffer
mWrite "FILE 1 SIZE BEFORE TRIMMING : "
call WriteDec
call crlf
cmp eax, 0
je zeroFileSize
INVOKE Str_length, ADDR buffer2
mWrite "FILE 2 SIZE BEFORE TRIMMING : "
call WriteDec
call crlf
cmp eax, 0
je zeroFileSize


; Cleaning the buffers from trailing spaces

INVOKE Str_trim, ADDR buffer, ' '
INVOKE Str_trim, ADDR buffer2, ' '
INVOKE Str_trim, ADDR buffer, 0ah
INVOKE Str_trim, ADDR buffer, 0dh
INVOKE Str_trim, ADDR buffer2, 0ah
INVOKE Str_trim, ADDR buffer2, 0dh

INVOKE Str_length, ADDR buffer
mov ecx, eax
inc ecx

L1:
	INVOKE Str_trim, ADDR buffer, ' '
	INVOKE Str_trim, ADDR buffer, 0ah
	INVOKE Str_trim, ADDR buffer, 0dh
loop l1

INVOKE Str_length, ADDR buffer
mov ecx, eax
inc ecx

L2:
	INVOKE Str_trim, ADDR buffer2, ' '
	INVOKE Str_trim, ADDR buffer2, 0ah
	INVOKE Str_trim, ADDR buffer2, 0dh
loop L2








INVOKE Str_length, ADDR buffer
mWrite "FILE 1 SIZE AFTER TRIMMING : "
call WriteDec
call crlf
cmp eax, 0
je zeroFileSize
INVOKE Str_length, ADDR buffer2
mWrite "FILE 2 SIZE AFTER TRIMMING : "

call WriteDec
call crlf
cmp eax, 0
je zeroFileSize
; replacing spaces, colon, semi-colon, commas, and fullstop with 0
INVOKE Str_length, ADDR buffer
mov ecx, eax
mov esi, 0
replace:
	push eax
	mov eax, 0

	mov al, ' '
	cmp buffer[esi], al
	je replacing
	mov al, ','
	cmp buffer[esi], al
	je replacing
	mov al, ';'
	cmp buffer[esi], al
	je replacing
	mov al, ':'
	cmp buffer[esi], al
	je replacing
	mov al, '.'
	cmp buffer[esi], al
	je replacing
after_replaced: inc esi
pop eax
loop replace
mWriteString offset buffer
call crlf
mov eax, 0
mov eax, first_word_count
call WriteDec
exit
zeroFileSize:
mWrite "One of the files is empty so can't check for plagiarism"
call crlf
exit

replacing:
	mov buffer[esi], 0
	push ebx
	mov ebx, 0
	mov ebx, first_word_count
	inc ebx
	mov first_word_count, ebx 
	pop ebx
	jmp after_replaced
exit
main ENDP
END main