# PayNow

- Devise para autenticação;
- SQLite como banco de dados;
- Active Storage para upload de imagens;
- Rspec e Capybara para testes;
- Selenium WebDrive para teste de sistema no Chrome.

## Dependencias
   - ruby 2.6.0
   - node 16.1.0
   - yarn 1.3.2
   - webpack 5.37.0
   - webpack-cli 4.7.0

## Instalando Projeto

```
git clone git@github.com:marcelasmoura/paynow.git

```
No diretorio do projeto:

```
./bin/setup

```

## Rodando os Testes

```
## na pasta raiz do projeto
rspec
```

## API

```
POST /api/v1/transactions
{
  "business_token": "SDPNtC2BbkCbNxsPEirO",
  "payment_option_token": "knfdbkljdfnbkldmvçla5",
  "product_token": "WccdjbN4FkmwHDVQf6PK",
  "customer_token": "xVafjxwU8v4Fxw5JEqwQ"
}

## response

{"token":"yWhw5B5jKKX7ukhijchZ"} 

```

```
POST /api/v1/customers
{
  "customer": {
    "full_name": "João da Silva",
    "cpf": "12345678912"
  },
  "business_token": "SDPNtC2BbkCbNxsPEirO"
}

## response

{
  "full_name": "João da 'silva",
  "cpf": "12345678912"
}
```


## Tabelas

![Untitled (1)](https://user-images.githubusercontent.com/57685135/123000914-8b3c5f00-d386-11eb-81f4-41bf735414dd.png)
