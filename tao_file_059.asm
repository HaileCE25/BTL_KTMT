# Data segment
 .data
# Cac dinh nghia bien
dulieu: .word	 60, 31, 22, 12, 11, -7, -13, -19, -24, -43 
file_path: .asciiz "INT10.BIN"
descriptor: .word 0
# Cac cau nhac nhap/xuat du lieu
str_tc:	.asciiz	"Thanh cong."
str_loi:	.asciiz	"Mo file bi loi."
#-----------------------------------
.macro puts($str  ) 
 la $a0, $str
 li $v0, 4
 syscall
 .end_macro 
#-----------------------------------
# Code segment
 .text
#-----------------------------------
# Chuong trinh chinh
#-----------------------------------
main:
# Nhap (syscall)
	# Xu ly
 	la $a0, file_path
 	addi $a1,$zero, 1 # open with a1=1 (write-only)
 	addi $v0,$zero, 13
 	syscall
	bgez	$v0,tiep
puts	str_loi		# mo file khong duoc
  	# ghi file
tiep:	sw	$v0, descriptor	#luu file descriptor
	 
 	# 4 byte dau (du lieu kieu word)
 	# 4 byte dau (du lieu kieu word) 
   	lw $a0, descriptor # file descriptor 
   	la $a1, dulieu 
   	addi $a2, $zero, 40 #ghi 40 byte so nguyen 
   	addi $v0 ,$zero, 15 
   	syscall  

 	# dong file
 	lw $a0, descriptor
 	addi $v0,$zero, 16
	syscall
	
	# Xuat ket qua (syscall)
 	puts str_tc
 	
	# Ket thuc chuong trinh (syscall)
	addi $v0,$zero, 10
 	syscall 
