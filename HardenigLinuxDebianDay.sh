# Script de Hardening Linux Versão 1.0 - Maykon Maia e Marcelino
# LinkedIn: https://www.linkedin.com/in/maykon-maia/ - https://www.linkedin.com/in/marcelino-camilo/

# 1. Atualizar pacotes do sistema
echo "Atualizando pacotes do sistema..."
sudo apt update && sudo apt upgrade -y

# 2. Criação do usuário comum
echo "Criando um novo usuário $usuario..."
sudo adduser $usuario --gecos "Primeiro Último,NúmeroSala,TelefoneTrabalho,TelefoneCasa" --disabled-password
echo "Adicionando $usuario ao grupo sudo..."
sudo usermod -aG sudo $usuario

# 3. Desabilitar login root via ssh
echo "Desativando login root via SSH..."
sudo sed -i 's/PermitRootLogin yes/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config

# 4.Configurar acesso SSH com chave
u=usuario; k=/root/id_rsa.pub
mkdir -p /home/$u/.ssh
cat $k >> /home/$u/.ssh/authorized_keys
chown -R $u:$u /home/$u/.ssh && chmod 700 /home/$u/.ssh && chmod 600 /home/$u/.ssh/authorized_keys
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/;s/^#\?PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd

# 5. Hardening no SSH
echo "Aplicando hardening adicional no SSH..."

# Desativar encaminhamento X11
sudo sed -i 's/#X11Forwarding yes/X11Forwarding no/' /etc/ssh/sshd_config

# Desativar senhas vazias
sudo sed -i 's/#PermitEmptyPasswords yes/PermitEmptyPasswords no/' /etc/ssh/sshd_config

# Desativar encaminhamento TCP
echo "AllowTcpForwarding no" | sudo tee -a /etc/ssh/sshd_config

# Limitar tentativas de login SSH para mitigar ataques de força bruta
echo "MaxAuthTries 3" | sudo tee -a /etc/ssh/sshd_config

# 6. Configuração do UFW
echo "[2/4] Configurando UFW (firewall)..."
apt install ufw -y

# Padrão: bloquear tudo e permitir conexões específicas
ufw default deny incoming
ufw default allow outgoing

# Permitir apenas SSH (porta 22) e HTTP/HTTPS
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp

ufw --force enable
ufw status verbose

# 7. Remoção de pacotes e serviços desnecessários
echo "[3/4] Removendo pacotes e serviços desnecessários..."
apt purge telnet rsh-server rsh-client talk talkd xinetd -y
apt autoremove --purge -y
apt clean

# 8. Fail2ban
echo "[4/4] Instalando e configurando Fail2ban..."
apt install fail2ban -y

# Arquivo de configuração local
cat > /etc/fail2ban/jail.local <<EOF
[sshd]
enabled = true
port = 22
maxretry = 5
findtime = 10m
bantime = 1h
EOF

systemctl enable fail2ban
systemctl restart fail2ban

# 9. Permissões, Serviços e Auditoria
echo "[Extra] Ajustando permissões e desativando serviços inseguros..."

# Bloquear acesso ao /etc/shadow e /etc/passwd
chmod 600 /etc/shadow
chmod 644 /etc/passwd

# Desabilitar root login via SSH
sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl restart sshd

# Listar serviços ativos e desativar os desnecessários
systemctl list-unit-files --type=service --state=enabled
# Exemplo para desativar (remova o # e altere o serviço conforme necessário):
# systemctl disable nome-do-servico

# Habilitar auditoria de logs
apt install auditd -y
systemctl enable auditd
systemctl start auditd

echo "Configuração concluída! Verifique os logs e revise serviços ativos."
