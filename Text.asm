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

INVOKE Str_length, ADDR buffer
mov ecx, eax
mov ebx, 0 ; ebx is used as index for the buffer in the following loop
L3:
	push ecx
	;ebx is used an index for string
	mov esi, 0
	extracting_words:
	.IF buffer[ebx] == ' ' || buffer[ebx] ==  ',' || buffer[ebx] == ':' || buffer[ebx] == ';' || buffer[ebx] == '.' || buffer[ebx] == 0dh || buffer[ebx] == 0ah
		mWriteString offset string1
		mov esi, 0
		mov ecx, 1
	.ELSE
	push eax
	mov al, buffer[ebx]
	mov string1[esi], al
	pop eax
	inc esi
	.ENDIF
	
	loop extracting_words
	inc ebx
	;INVOKE Str_length, ADDR buffer2
	;mov eax, ecx
	;L4:
		
	;loop L4
	pop ecx
loop L3
exit
zeroFileSize:
mWrite "One of the files is empty so can't check for plagiarism"
call crlf
exit
main ENDP
END main