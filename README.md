# Script de Hardening Inicial no Debian (AWS + Debian Day)

Este script automatiza configurações iniciais de segurança em uma instância Debian, incluindo:

- Atualização completa do sistema
- Criação de usuário comum
- Desabilitar login root via SSH
- Configurar acesso SSH com chave pública
- Hardening básico no SSH
- Configuração do UFW
- Remoção de pacotes e serviços desnecessários
- Fail2ban e proteção contra brute force
- Permissão, serviços e auditoria de logs

---

## 📋 Pré-requisitos

- Servidor Debian em execução (local ou na AWS)
- Acesso via terminal com um usuário com privilégios de `root` ou `sudo`
- Uma chave pública SSH gerada no seu computador

---

## 📂 Criando o arquivo do script

Você pode criar o arquivo de script de diferentes formas:

- Usando nano (mais simples para iniciantes):
bash
nano hardening.sh

Cole o conteúdo do script dentro do editor, depois salve com:

CTRL + O → Enter para confirmar

CTRL + X → para sair

- Usando touch (cria o arquivo vazio para depois editar):

touch hardening.sh
nano hardening.sh

- Usando vi (para quem já conhece o editor vi/vim):

vi hardening.sh

---

🔑 Dando permissão de execução

Após criar o arquivo, torne-o executável:

chmod +x hardening.sh

---

▶️ Executando o script
Execute com privilégios administrativos:

sudo ./hardening.sh

---

⚠️ Observações importantes
Teste sempre em um ambiente de laboratório antes de executar em produção.

Se for rodar em uma instância AWS, mantenha uma sessão SSH extra aberta para evitar perder acesso em caso de erro na configuração.

Tenha backup das configurações originais:

cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

---

📄 Licença

Este script foi desenvolvido para fins educacionais e pode ser adaptado conforme suas necessidades.
