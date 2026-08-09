# Sistema de Gestão para Biblioteca Municipal

**Desenvolvido por:** Plácido da Silva França

## Índice
- [1. Apresentação do Projeto](#1-apresentação-do-projeto)
- [2. Tecnologias Utilizadas (Stack)](#2-tecnologias-utilizadas-stack)
- [3. Escopo e Regras de Negócio](#3-escopo-e-regras-de-negócio)
- [4. Arquitetura, Lógica de Negócio e Funcionalidades](#4-arquitetura-lógica-de-negócio-e-funcionalidades)
- [5. Como Executar o Projeto](#5-como-executar-o-projeto)
- [6. Primeiro Acesso ao Sistema](#6-primeiro-acesso-ao-sistema)

---

## 1. Apresentação do Projeto
Esta documentação detalha a solução técnica desenvolvida para o desafio de construção de um Sistema de Gestão para Bibliotecas.

O objetivo central do projeto é fornecer uma plataforma robusta e íntegra para o gerenciamento de acervos literários e orquestrar o fluxo operacional de empréstimos. O sistema digitaliza o controle de livros e automatiza o cálculo de prazos e multas através de um controle de acesso eficiente, dividido e isolado entre o perfil administrativo (Bibliotecário) e os clientes da biblioteca (Leitores/Usuários).

## 2. Tecnologias Utilizadas (Stack)
A arquitetura do projeto foi projetada e implementada utilizando ferramentas modernas e consolidadas no mercado:

* **Linguagem Base:** Ruby 
* **Backend e Framework:** Ruby on Rails (v8+)
* **Frontend (Camada de Visão):** ERB (Embedded Ruby) nativo do Rails
* **Banco de Dados Relacional:** MySQL
* **Geração de Relatórios:** Prawn (PDF)
* **Envio de E-mails:** Action Mailer
* **Autenticação:** Devise
* **Infraestrutura:** Docker e Docker Compose

## 3. Escopo e Regras de Negócio

A modelagem do domínio do sistema foi dividida em duas frentes principais: o controle do acervo e a orquestração do fluxo de empréstimos.

**Perfis de Acesso (Controle Baseado em Papéis)**
O sistema exige e implementa um controle de permissões rigoroso, segregando as operações em dois níveis:
* **Bibliotecários (Administradores):** Detêm o controle de gestão estrutural da plataforma. São os únicos autorizados a acessar o sistema, cadastrar categorias, registrar novos livros, cadastrar usuários (leitores) e efetivar operações de empréstimo e devolução.
* **Usuários (Leitores):** São os clientes finais do sistema. Diferente dos bibliotecários, eles não possuem acesso de login à plataforma. Sua atuação é validada fisicamente no balcão de atendimento através de um PIN (senha) gerado pelo sistema e enviado exclusivamente para seus e-mails. *(Nota estrutural: Como os leitores não possuem acesso ao sistema e a senha serve estritamente para a validação presencial do empréstimo pelo bibliotecário, o PIN gerado também foi deixado visível na tela de listagem de usuários. Essa decisão arquitetural permite que o avaliador da banca teste o fluxo completo de empréstimos imediatamente, sem depender de acessos externos a caixas de e-mail).*

**Ciclo de Vida do Livro e Empréstimo**
O fluxo processual foi desenhado para evitar inconsistências. Um livro recém-cadastrado recebe o status de "disponível". Ao ser vinculado a um empréstimo ativo, seu status muda automaticamente para "emprestado", sumindo das opções de seleção para novas transações. Ao atingir o estado de devolução, o sistema calcula eventuais atrasos, registra as multas e devolve o status do livro para "disponível", garantindo a integridade do histórico.

## 4. Arquitetura, Lógica de Negócio e Funcionalidades

A aplicação foi desenvolvida sob o padrão arquitetural MVC (Model-View-Controller). A lógica de negócio foi rigorosamente encapsulada nos Modelos, utilizando callbacks para automatizar as transições de estado, garantindo que as interfaces de usuário e os Controladores operem apenas como pontes de requisição.

Abaixo, detalham-se as principais funcionalidades e as decisões de engenharia que sustentam as regras do sistema:

### Gestão de Identidade e Segurança (Devise)
A autenticação do sistema foi delegada à gem Devise, garantindo criptografia de ponta a ponta para as senhas dos bibliotecários e controle rigoroso de sessão. O sistema exige a redefinição de senhas provisórias no primeiro acesso para garantir a segurança da conta.

### Mensageria e Validação em Duas Etapas (Action Mailer)
A criação de um perfil de Usuário/Leitor aciona automaticamente o UsuarioMailer. O sistema gera um PIN aleatório e o despacha via e-mail no ato do cadastro. 
* **Blindagem de Escopo:** O sistema exige que, para a efetivação de qualquer empréstimo, o bibliotecário insira o PIN exato do usuário selecionado. A transação é bloqueada caso a senha não corresponda ao banco de dados.

### Motor de Prazos e Automação de Status
O ciclo de vida do empréstimo funciona de forma autônoma:
* **Cálculo de Dias Úteis:** Através de um callback de validação, a data de devolução prevista não precisa ser digitada. O sistema calcula automaticamente 15 dias úteis, saltando sábados e domingos matematicamente no momento da persistência.
* **Sincronização Bidirecional:** Ganchos de banco de dados (after_create, after_update) garantem que o livro mude seu status de e para "disponível" / "emprestado" sem a necessidade de intervenção humana.

### Geração Algorítmica de Multas e PDFs (Prawn)
* **Cálculo Dinâmico:** A aplicação avalia em tempo real a relação entre a data atual e a previsão de devolução. Caso o status dinâmico aponte "Atrasado", o sistema multiplica os dias excedentes por uma taxa fixa, exibindo a dívida imediatamente na View.
* **Relatórios em PDF:** A gem Prawn foi utilizada para desenhar arquivos PDF via código. Rotas específicas filtram estritamente os empréstimos em atraso, injetando os dados estruturados em tabelas no relatório gerado.

## 5. Como Executar o Projeto

A infraestrutura desta aplicação foi totalmente conteinerizada para garantir a padronização do ambiente de execução e facilitar os testes. 

### Pré-requisitos
Para rodar o projeto localmente, é estritamente necessário ter as seguintes ferramentas instaladas na sua máquina:
* Git
* Docker e Docker Compose

### Passo a Passo da Instalação

**1. Clonar o repositório**
Abra o seu terminal e faça o clone do projeto:

    git clone https://github.com/PlacidoSF/biblioteca_municipal.git
    cd biblioteca_municipal

**2. Configurar as Variáveis de Ambiente**
Por questões de segurança estrutural, o banco de dados e as credenciais de e-mail (Action Mailer) estão protegidos. As configurações do SMTP foram criptografadas nativamente pelo cofre do Rails (`credentials.yml.enc`). Como a conta de e-mail configurada no sistema foi criada de forma isolada e exclusiva para os testes desta banca avaliadora, a chave mestra real está sendo fornecida para garantir a execução fluida do ambiente local sem erros de autenticação SMTP.

Na raiz do projeto, existe um arquivo chamado `.env_exemplo`. **Renomeie este arquivo para `.env`** (removendo o sufixo `_exemplo`). O arquivo já contém as credenciais necessárias para rodar a aplicação:

    DB_USERNAME=root
    DB_PASSWORD=sua_senha_mysql
    RAILS_MASTER_KEY=c835e2a9adccc7514ac491d2143cfd7f

**3. Compilar e Subir os Contêineres**
Com o Docker em execução na sua máquina e o arquivo `.env` configurado, rode o comando abaixo na raiz do projeto. O Docker irá compilar o código fonte e iniciar os contêineres do banco e da aplicação Web:

    docker compose up --build -d

**4. Acessar o Sistema**
Assim que o banco estiver pronto, acesse a aplicação pelo navegador:
* **URL:** http://localhost:3000

## 6. Primeiro Acesso ao Sistema

A preparação do banco de dados do Rails realiza a criação automática de um usuário bibliotecário administrador padrão para permitir o primeiro acesso à plataforma.

Para realizar o login e começar a utilizar o sistema, utilize as seguintes credenciais:
* **E-mail:** admin@biblioteca.com
* **Senha:** admin123

Vale ressaltar que, por ser um perfil administrador configurado nativamente com o atributo de senha provisória desativado, este acesso não exigirá a tela de redefinição de senha, permitindo entrada direta e imediata no painel principal.