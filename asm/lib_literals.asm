#
.global	lit_nl
.global	lit_tab
.global	lit_cs
.global	lit_arrA
.global	lit_wa
.global	lit_fb
.global	lit_ub
.global	lit_wt
.global	lit_wc
.global	lit_dl
.global	lit_oif
.global	lit_ifd
.global	lit_oof
.global	lit_ofd
.global	lit_orc
.global	lit_iifn
.global	lit_iofn
.global	lit_anf
.global	lit_res
.global	lit_ifn
.global	lit_ofn
.global	lit_ifore


.data
lit_nl:		.asciz	"\n"
lit_tab:		.asciz	"\t"
lit_cs:		.asciz	": "
lit_arrA:	.asciz	"Array A: "
lit_wa:		.asciz	"Work area address           : "
lit_fb:		.asciz	"File buffer address         : "
lit_ub:		.asciz	"utoa buffer address         : "
lit_wt:		.asciz	"Word addresses array address: "
lit_wc:		.asciz	"Word counters array address : "
lit_dl:		.asciz	"File readed data length     : "
lit_oif:		.asciz	"Open input file             : "
lit_ifd:		.asciz	"Input file descriptor       : "
lit_oof:		.asciz	"Open output file            : "
lit_ofd:		.asciz	"Output file descriptor      : "
lit_orc:		.asciz	"Output result to console?"
lit_iifn:	.asciz	"Input input-file name."
lit_iofn:	.asciz	"Input output-file name."
lit_anf:		.asciz	"Analize next file?"
lit_res:		.asciz	"Result:\n"
lit_ifn:		.asciz	"Input file name : "
lit_ofn:		.asciz	"Output file name: "
lit_ifore:	.asciz	"Input file open/read error!\n"
