# Desafio Pipeline CICD Cloud Build + Terraform.

## Princípios do desafio:
1. Utilize o git https://github.com/digitalinnovationone/terraform-gcp/tree/main/terraform-exemplo2 para configurar a trigger do Cloud Build.
2. Edite o script para trocar o nome da máquina para cloudbbuildterraform.
3. Salve os arquivos do Estado no Google Cloud Storage.

Submeta o print de cada etapa de configuração do Pipeline .

# Inicio da Configuração: 

Para a configuração do nosso pipeline CI-CD, será necessário configurar algumas dependências em nossa console do **GCP.**

- Os recursos necessários para este tutorial :
    - Cloud Source Repositories;
        - Responsável por ser nosso repositório de dados remoto do próprio Google.
        - Utilizamos os comandos GIT.
    - Cloud Storage; e
        - Usaremos um Bucket para armazenar o arquivo de estados de nosso Terraform
        - Salvará nosso `backend gcs`
    - Google Cloud Build.
        - Para Definição de nossos triggers CI-CD.

## Configuração do Cloud Source Repositories

Acesse o Cloud Source Repositories no Console da GCP

- Seja pelo botão abaixo ou diretamente pela barra de pesquisa utilizando o termo **“Source Repositories”.**

<a href="https://console.cloud.google.com/flows/enableapi?apiid=sourcerepo.googleapis.com&%3Bredirect=https%3A%2F%2Fcloud.google.com%2Fsource-repositories%2Fdocs%2Fcreate-code-repository&hl=pt-br&_ga=2.81496222.848313426.1674099253-1827423088.1669521052&_gac=1.149136196.1673051841.CjwKCAiAqt-dBhBcEiwATw-ggAy3j7wawfYOCb5bObxeLKcUxOP1jRcsDajHtocTfymazNtuV8mNkBoCswUQAvD_BwE">
<img alt="Open in Cloud Shell" src ="https://user-images.githubusercontent.com/32373902/210641943-86dc6428-dfaf-4391-a472-758d91af0533.png" width=250 ></a>

![Screenshot_2](https://user-images.githubusercontent.com/32373902/213400737-c2223669-c1f2-43f4-801a-40a934ba83b7.png)

Assim, atingimos todos os objetivos do desafio!

 - Lembre-se, é possível que erros aconteçam no Cloud Build por necessidade de permissões do IAM.

Ao entrar diretamente na página do recurso, clique  nos botões, respectivamente:

- **Get Started → Create Repository**
    - Esta opção é apenas caso nunca tenha utilizado o recurso
![Screenshot_3](https://user-images.githubusercontent.com/32373902/213400740-c3c463b7-2ca7-4615-8273-04568eebc06e.png)
- Em **Add a repository**
    - Selecione “**Create new repository” → Continue**
 
![Screenshot_4](https://user-images.githubusercontent.com/32373902/213400741-c2f6635b-7c48-4859-8e21-0aab07417358.png)
- Preencha com as informações necessárias:
    - Nome do repositório (`dio-iac`);
    - Projeto em que o repositório será alocado.
- Após isso, clique em **Create.**

![Screenshot_5](https://user-images.githubusercontent.com/32373902/213400745-a8216a4a-be61-420f-a9d0-7fd62510b22a.png)


Vamos utilizar o recurso de envio de nossa “máquina local” ( utilizando o Cloud Shell) para o nosso **Source Repository.**

- Para isso, selecione a opção: **Push Code From a local Git repository.**
- Método de autenticação: **Google Cloud SDK.**
- Auth Credentials: **Linux.**
![Screenshot_6](https://user-images.githubusercontent.com/32373902/213400746-8675d09c-2536-4fb5-9583-5ec3b4fe54dc.png)
    - Será listado os comandos em que se necessita utilizar em seu terminal Cloud Shell para inicialização do repositório.
        - Entre na pasta aonde encontra-se seus arquivos ( será o `git clone` deste repositório).
        - Acesse a pasta utilizando os comandos `cd` e realize o primeiro comando `gcloud init` .
        ![Screenshot_7](https://user-images.githubusercontent.com/32373902/213400748-133d1761-185b-4e80-b892-499f9e39916c.png)
        
        - Vamos fazer a reinicialização da configuração utilizando nosso **usuário e projeto.**
        ![Screenshot_8](https://user-images.githubusercontent.com/32373902/213400751-62519978-2cfc-4f09-9d88-2cbda7a0253f.png)
        
        - Realize o `git init` no diretório utilizando o cloud shell.
        ![Screenshot_9](https://user-images.githubusercontent.com/32373902/213400758-65eb1407-2b8c-4fca-9897-ce17e8b1934d.png)
        
        - Execute o passo 3, aplicando o `git remote` ao repositório.
        ![Screenshot_10](https://user-images.githubusercontent.com/32373902/213400762-a91b9b63-d97f-4117-9ce4-eb0d07c5e407.png)
        ![Screenshot_11](https://user-images.githubusercontent.com/32373902/213400764-ae3bbc10-ab85-45cf-829f-ffbd8fc946bd.png)
        
        - Execute o passo 4, empurrando o código diretamente do nosso Git local.
        ![Screenshot_12](https://user-images.githubusercontent.com/32373902/213400766-e7cbfac4-232e-4c14-bee1-28ba5807d81d.png)
        ![Screenshot_13](https://user-images.githubusercontent.com/32373902/213400770-903c9b95-7c3a-4e84-89a6-6375f587da2e.png)
        
        - Após isso, atualize a página, você verá nos novos arquivos diretamente em seu Cloud Source Repositories.
![Screenshot_14](https://user-images.githubusercontent.com/32373902/213400773-61091c5d-5fbe-4bad-93ad-487ab20a65ec.png)
    

## Configuração do Cloud Build

- Acesse do Cloud Build diretamente pela barra de pesquisa utilizando o termo **“Cloud Build”.**
    - Podemos verificar se o repositório já é visto pelo serviço cliando em **Triggers → Manage repositóries**
        - No caso, existe o repositório `dio-iac` que foi criado anteriormente.
![Screenshot_17](https://user-images.githubusercontent.com/32373902/213400777-498ac022-c0ea-4c30-8cea-294c01c2977e.png)

    - Vamos criar nosso gatilho com o repositório: **Triggers → CREATE TRIGGER**
        - Preencha o **nome** (utilizei `dio-iac-trigger-terraform`);
        - Deixe na região global;
        - Preencha a descrição;
        - Utilize Tags se necessário;

       **Em Event:** 
    
    - Selecione: **Push to a branch**
    
       **********Em Source:**********
    
    - Selecione o repositório por nome;
    - Como só há a branch `master` , iremos utiliza-la, caso tenha outras, verifique o seu projeto para melhor adequar ao seu projeto;
    
    
    ![Screenshot_19](https://user-images.githubusercontent.com/32373902/213400782-0ac257b0-585f-41c4-820c-359cc413f29e.png)
    
    **Em Configuration:**
    
    - O serviço do Google automaticamente que iremos utilizar um `cloudbuild.yaml` que já está presente em nosso diretório
    
    ![Screenshot_20](https://user-images.githubusercontent.com/32373902/213400785-ade6475a-750c-4f8e-bde9-f1af87e4b2dc.png) 
    
    Após isso: **Create** para finalizar nosso trigger. Ele aparecerá diretamente em nosso painel
    
           

    ![Screenshot_22](https://user-images.githubusercontent.com/32373902/213400787-b7c4b233-bb8b-45f9-a7ee-715ee4d8cdd3.png)

## Configuração do Cloud Storage:

- Acesse do Cloud Storage diretamente pela barra de pesquisa utilizando o termo **“Cloud Storage”.**
    
    Vá em **Buckets → Create** 
    
    - Preencha com as informações necessárias.
    - O nome do bucket é importante pois ele será utilizado em nosso código do arquivo `main.tf` onde passaremos o **bucket name** diretamente via código:
    
   ![Screenshot_23](https://user-images.githubusercontent.com/32373902/213404486-7c118a26-9b3d-4ae3-bf45-49a829f55a3a.png)
 
    
    ```bash
    backend "gcs" {
        bucket  = "[insira_seu_bucket_name]" # utilizei o desyncterraform
        prefix  = "terraform/state"
      }
    ```
   
   
![Screenshot_24](https://user-images.githubusercontent.com/32373902/213400791-5ea8523f-9706-4bc4-b331-3ef1700e9c61.png)
   
   
Após isso vamos iniciar nossa instancia do terraform para que o código seja executado corretamente

- `terraform init` → Inicia nosso terraform, baixando todos os arquivos necessários para uso (dependências, plugins, arquivos,  [...] )
- `terraform plan` → Segundo item na hierarquia dos comandos, o comando “planeja” o que será executado em sequência, compreendendo tudo que será aplicado posteriormente **(add, change or destroy)**
- `terraform apply` → Realiza a criação dos recursos que foram planejados
    - digite yes para confirmar a ação.
        - Caso quiser destruir a instancia: `terraform destroy`
    
    Agora veja em **Compute Engine** o deploy do terraform;
    
![Screenshot_27](https://user-images.githubusercontent.com/32373902/213400794-24bc3afe-6768-4475-864c-350d9bc651c0.png)    
    


O bucket, agora apresenta o arquivo de estados do terraform:  
![Screenshot_25](https://user-images.githubusercontent.com/32373902/213400792-6a9a1f24-b1b2-49e2-bd1a-545e9ffc4dbf.png)



## Testando o trigger do CI-CD:

Será necessário uma modificação de um arquivo e a realização de um `push` ao nosso repositório para aplicação dos **Triggers.**

- Vamos trocar o nome de nossa **Vm instance** no arquivo `main.tf` de **************************************terraform-instance************************************** para **cloudbbuildterraform.**
- Faremos a alteração utilizando o Cloud Shell Editor;
![Screenshot_29](https://user-images.githubusercontent.com/32373902/213400800-b5533f25-2039-4bd6-851b-dd116e969328.png)

- Realizamos o `git add.`  o `git commit` e o `git push --all google` para envio ao repositório.
![Screenshot_30](https://user-images.githubusercontent.com/32373902/213400803-e57fbde2-46de-4b9e-88ba-de5eec1f0258.png)

- Assim que push é percebido pela trigger, ele começará o processo de construção da nossa infraestrutura
![Screenshot_32](https://user-images.githubusercontent.com/32373902/213400809-c4c51054-8adc-4fa5-9ba8-edecdf575d4c.png)

    - É possivel ver que ao final do build temos  o **IP 10.128.0.2** que é o mesmo apresentado em nossa VM instances e agora com o nome de **cloudbbuildterraform**
    
   ![Screenshot_31](https://user-images.githubusercontent.com/32373902/213400805-f13834a1-8044-49e4-aa0e-022831988f79.png)
    


Assim, atingimos todos os objetivos do desafio!

 - Lembre-se, é possível que erros aconteçam no Cloud Build por necessidade de permissões do IAM
