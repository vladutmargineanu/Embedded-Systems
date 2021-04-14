# [host] aflam parametrul pentru placa Versatile PB
qemu-system-arm -machine ? | grep Versatile/PB

# parametrul este '-machine versatilepb'

# [host] aflam parametrul pentru procesorul ARM1176JZ-F
qemu-system-arm -machine versatilepb -cpu ? | grep arm1176

# parametrul este '-cpu arm1176'
