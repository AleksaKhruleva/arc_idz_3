.global	cat_func
.include "lib_macros.asm"


# function:
#	Print file context to console
# locals constants:
.eqv	lc_fb_sz	16	# file buffer size
.eqv	lc_fb_of	12	# file buffer offset
# locals area:
.eqv	la_fd	+0(sp)	# stack (+00) - file descriptor value
.eqv	la_dl	+4(sp)	# stack (+04) - readed data length
.eqv	la_fb	+8(sp)	# stack (+08) - file buffer address
.eqv	la_size	28	# = 12 + lc_fb_sz
# save area:
.eqv	sa_ra	+0(sp)	# stack (+00) - register ra (return address)
.eqv	sa_s0	+4(sp)	# stack (+04) - register s0
.eqv	sa_size	8
# arguments area:
.eqv	arg1	+0(s0)	# stack (+00) - (i) - input file name string address
# register usage:
#	s0 - on-call stack position (arguments area)
.text
cat_func:
	# save registers
	addi	sp, sp, -sa_size		# obtain stack for save area
	sw	ra, sa_ra		# save ra register
	sw	s0, sa_s0		# save s0 register
	addi	s0, sp, sa_size		# set on-call stack position (arguments area)
	# initialize locals area
	addi	sp, sp, -la_size		# obtain stack for locals area
	addi	t0, sp, lc_fb_of		# calculate file buffer address
	sw	t0, la_fb		# store file buffer address

	# open file
_oif:	lw	t0, arg1			# load file name address
	li	t1, 0			# flags - read only
	fopen	(t0, t1)			# open file
	sw	a0, la_fd		# store file descriptor
	lw	a0, la_fd		# load file descriptor
	blt	a0, zero, _break		# break if fopen error

_iread:	# read file
	lw	a0, la_fd		# load file descriptor value
	lw	a1, la_fb		# load buffer address
	li	a2, lc_fb_sz		# load buffer size value
	addi	a2, a2, -1		# decrement buffer size value for '\0'-character
	fread	(a0, a1, a2)		# read from file
	sw	a0, la_dl		# store readed data length
	lw	t0, la_fb		# load buffer address
	add	t0, t0, a0		# calculate '\0'-character position
	sb	zero, (t0)		# set '\0'-character
	lw	a0, la_dl		# load data_leng value
	blt	a0, zero, _break		# break if fread error
	beq	a0, zero, _iclose		# branch if end of file

	# print readed data
	lw	a0, la_fb		# load buffer address
	coutT0
	
	j	_iread			# next iteration

_iclose:	# close input file
	lw	t0, la_fd		# load file descriptor value
	fclose	(t0)			# close file

	# return
_end:	li	a0, 0			# ok - return code

_break:	# this we must free heap, but no evironment call exist
	addi	sp, sp, la_size		# free stack for locals area
	lw	ra, sa_ra		# load ra register
	lw	s0, sa_s0		# load s0 register
	addi	sp, sp, sa_size		# free stack for save area
	ret				# return
