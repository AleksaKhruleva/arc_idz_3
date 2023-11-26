.global	fopen_func
.global	fclose_func
.global	fread_func
.global	fwrite_func


# function:
#	Opens a file from a path
# arguments:
#	stack (+00) - file name address (input)
#	stack (+04) - file open flags (intput)
# return:
#	register (a0) - the file descriptor
.text
fopen_func:
	lw	a0, +0(sp)		# file name address
	lw	a1, +4(sp)		# file open flags
	li	a7, 1024			# environment call code
	ecall				# execute environment call
	ret				# return


# function:
#	Close a file
# arguments:
#	stack (+00) - file descriptor value (input)
.text
fclose_func:
	lw	a0, +0(sp)		# file descriptor value
	li	a7, 57			# environment call code
	ecall				# execute environment call
	ret				# return


# function:
#	Read from a file descriptor into a buffer
# arguments:
#	stack (+00) - file descriptor value (input)
#	stack (+04) - buffer address (input)
#	stack (+08) - buffer size value (input)
# return:
#	register (a0) - the length read or -1 if error
.text
fread_func:
	lw	a0, +0(sp)		# file descriptor value
	lw	a1, +4(sp)		# buffer address
	lw	a2, +8(sp)		# buffer size value
	li	a7, 63			# environment call code
	ecall				# execute environment call
	ret				# return


# function:
#	Write to a filedescriptor from a buffer
# arguments:
#	stack (+00) - file descriptor value (input)
#	stack (+04) - buffer address (input)
#	stack (+08) - buffer size value (input)
# return:
#	register (a0) - the number of charcters written
.text
fwrite_func:
	lw	a0, +0(sp)		# file descriptor value
	lw	a1, +4(sp)		# buffer address
	lw	a2, +8(sp)		# buffer size value
	li	a7, 64			# environment call code
	ecall				# execute environment call
	ret				# return
