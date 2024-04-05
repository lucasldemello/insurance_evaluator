<!-- Inserir descrição do projeto -->
 
Tabela de conteúdos
-----------
<!--ts-->
* Instalando aplicação localmente
    * [Pré-requisitos](#prerequisites)
    * [Instalando depêndencias](#install)
    * [Iniciando containers para debug](#debug)
* Documentação
    * [Testes API](#testesapi)
    * [Endpoints](#endpoints)
    * [Considerações](#consideracoes)
<!--te-->
# Instalando aplicação localmente

<a href="prerequisites">Pré-requisitos</a>
-----------
`docker`
`docker-compose`

Link para documentação oficial de instalação de docker e docker-compose:
https://docs.docker.com/compose/install/


<a href="install">Instalando depêndencias</a>
-----------

Para baixar as imagens e preparar os containers execute o comando:

`docker-compose build --no-cache`

Após a execução, podemos utilizar o seguinte comando para iniciar os containers:

`docker-compose up` ou

`docker-compose up -d` caso queira executar de forma detach (background)

Para descobrir o nome da imagem:

`docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"`

Para acessar o container:

`docker exec -ti nome-da-imagem bash`


Para iniciar a aplicação corretamente execute os comandos

`rails db:create && rails db:migrate`

<a href="debug">Iniciando containers para debug</a>
-----------

    docker-compose up -d
    docker attach nome-da-imagem

Dessa forma podemos utilizar o comando `debugger` para pausar a execução e debugar.


# Documentação da API
<a href="testesapi">Testes da API.</a>
-----------
Os testes da API foram escritos usando RSpec para garantir seu funcionamento adequado. Para executar os testes, siga estes passos:

1. Certifique-se de que todas as dependências estão instaladas executando:

  `bundle install`

2. Em seguida, execute os testes RSpec com o seguinte comando:

  `rspec . `

  Isso executará todos os testes e mostrará os resultados no terminal.

3. Após a primeira execução dos testes, estará disponível o report de coverage. O mesmo se encontra em `./coverage`, basta abrir o arquivo `index.html` em um navegador. 

<a href="endpoints">ENDPOINTS.</a>
-----------


1. Avaliar score para seguros de um usuário

```bash
curl --location 'http://localhost:3001/api/v1/user/evaluate_insurances' \
--header 'Content-Type: application/json' \
--data '{
  "age": 35,
  "dependents": 2,
  "house": {"ownership_status": "owned"},
  "income": 0,
  "marital_status": "married",
  "risk_questions": [0, 1, 0],
  "vehicle": {"year": 2018}
}'

```

Uma avaliação com sucesso irá ter o seguinte retorno:

```json
{
    "auto": "padrao",
    "disability": "inelegivel",
    "home": "padrao",
    "life": "economico"
}
```

Durante falhas na API, o JSON de resposta inclui o campo "error" com informações específicas sobre o erro

```json
{
    "error": [
        "Age is not a number",
        "Dependents is not a number",
        "Income is not a number",
        "Marital status can't be blank"
    ]
}
```

<a href="consideracoes">Considerações.</a>
-----------
* Usei o design pattern Strategy para organizar as regras comuns e especificas dos usuários

* Optei por serviços para desaclopar o possível do controller. 

* Ainda estou um pouco em dúvida se o melhor lugar para as strategies seria em services, ainda seria alguma coisa que eu tentaria isolar embora
não ache que iria mandar para lib ou concerns, levando em consideração acho que foi um bom lugar para armazenar. 

* Por mais que não exigisse achei interessante ter um serializer para mostrar que o retorno também poderia ser construído conforme a necessidade. 

* O teste em sí representa o processamento de um payload, dessa forma optei por não criar um arquivo de seeds com carga inicial.

