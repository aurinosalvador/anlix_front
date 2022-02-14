# Projeto Anlix Front

**Projeto feito para o [desafio Anlix](https://github.com/anlix-io/desafio-anlix).**

## Pré-requisitos

 - [Docker](https://docs.docker.com/engine/install/)
 - [Docker Compose](https://docs.docker.com/compose/install/)
 - [Git](https://git-scm.com/book/pt-br/v2/Come%C3%A7ando-Instalando-o-Git)

## Procedimentos antes de executar o projeto

Registrar token do github na máquina para ter acesso as imagens que estão hospedadas no github.
Seguindo o que está no [site oficial](https://docs.github.com/pt/packages/working-with-a-github-packages-registry/working-with-the-container-registry#)

 - Acesse a página principal do [github](https://github.com/).
 - Step 1: Acesse as configurações de sua conta (Settings).
 - Step 2: Menu Developer settings.
 - Step 3: Menu Personal access tokens.
 - Step 4: Clica em Generate new token.
 - Caso ele solicite, digite sua senha do github.
 - Step 5: Digite um nome pro seu token. ex: docker.
 - Step 6: Em Expiration selecione **No expiration**.
 - Step 7: Marque as opções **repo** e **write:packages**
 - Step 8: Clica em Generate token.
 - Step 9: Copia o token que foi gerado.
 - Step 10: No seu terminal digite o comando abaixo substituindo USERNAME pelo seu nome de usuário do github:
```bash
  docker login docker.pkg.github.com -u USERNAME
```
  - Step 11: Cole seu token gerado gerado no Step 9.

## Executando o projeto

Clone o repositório do projeto.
```bash
git clone https://github.com/aurinosalvador/anlix_front.git
``` 

Acesse a pasta do projeto
```bash
cd anlix_front/
``` 

Executar o docker-composer pra baixar as imagens e montar os containers necessários para execução do projeto.
```bash
docker-compose up -d
``` 

Acesse no seu navegador o endereço http://localhost

### Populando o banco.

[Baixe aqui o zip.](https://github.com/anlix-io/desafio-anlix/archive/refs/heads/main.zip)

Descompacte o arquivo e na pasta **dados** estarão todos os arquivos necessários.

 - Incluindo os pacientes: Na tela inicial clique no menu de Pacientes, ao abrir na Barra terá um ícone para importar, basta informar o arquivo paciente.json que está dentro da pasta **dados** referente ao passo anterior.
 - Incluindo os diagnósticos: Na tela inicial clique no menu de Diagnósticos, da mesma forma que na tela de Pacientes, terá um botão para importar os arquivos, dentro da pasta **dados** tem duas sub pastas **ind_card** e **ind_pulm**, basta acessar cada pasta e selecionar todos os arquivos para a importação.


    