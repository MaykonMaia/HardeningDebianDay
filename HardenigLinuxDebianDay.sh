# Script de Hardening Linux Versão 1.0 - Maykon Maia
# LinkedIn: https://www.linkedin.com/in/maykon-maia/

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

