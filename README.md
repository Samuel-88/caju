# Caju

  Bem-vindo à autorizadora de pagamentos da Caju, aonde todos os pagamentos são processados com segurança na velocidade da luz!

### Instalação

  Para subir nossa autorizadora primeiro precisamos instalar o Elixir e o Erlang, conforme descritos no link a seguir:  https://elixir-lang.org/install.html

  Após isso, é necessário adicionar as envs 'DB_USERNAME', 'DB_PASSWORD' e 'DB_HOSTNAME', as quais representam o nome do usário, senha e host do banco de dados. 
  E para nossa aplicação estamos utilizando o PostgreSQL.
  
  Depois de todos esses passos feitos, precisamos instalar as dependências rodando o comando `mix setup` na pasta do projeto.
  E então é só subir o servidor com `iex -S mix phx.server`.

  Agora nosso servidor esta disponível em `localhost:4000`.

### Diferencias da autorizadora Caju

  - Paralelismo: Mesmo que duas transações ocorram exatamente no mesmo momento, não teremos problema com os saldos da conta. E isso ocorre porque todas as autorizações são
  processadas dentro de uma _transaction_ e a conta é buscada com um `SELECT FOR UPDATE`, garantindo que a conta envolvida na transação ficará travada para outras
  operações até que a _transaction_ com o débito de saldo seja concluída.
  
  - Identificador inteligente de MCC: Para garantir que estamos utilizando o MCC correto, temos um sistema para garantir que mesmo com o MCC cadastrado erroneamente pela
  empresa, vamos conseguir sobreescrever com o certo através do nome do estabelecimento.

  - Carteira multi-saldo: Mesmo sem saldo na carteira da compra em questão, se existir saldo na carteira de `CASH` a compra será efetuada com sucesso.

  - Fallback Controller: Para nunca quebrarmos o contrato de responder 200 em todas as requisições, temos um _fallback controller_ no caso de qualquer problema inesperado
  em nossa aplicação que vai responder com status 200 e código 07.
