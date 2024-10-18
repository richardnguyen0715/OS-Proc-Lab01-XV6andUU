set confirm off
set architecture riscv:rv64
<<<<<<< HEAD
target remote 127.0.0.1:25000
=======
target remote 127.0.0.1:26000
>>>>>>> d8ef786cf7adf02927e1f8892492bb9a315e3fc3
symbol-file kernel/kernel
set disassemble-next-line auto
set riscv use-compressed-breakpoints yes
