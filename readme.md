# Soberana-Server
Dockerfile e arquivos de configuração (que serão) utilizados no servidor da soberana.

## Pastas expostas

### `config`

Essa pasta contém todas as configurações publicamente disponíveis do servidor.  
Ela é versionada e faz parte do repositório, faz parte da imagem e é copiada durante a criação da imagem.  

### `world`

Pasta contendo o mundo do servidor, sendo criada quando não providenciada.  
Não é versionada e é ignorada tanto pelo git como pelo docker.

## Onde está a pasta `mods`?

Os mods são gerenciados automaticamente pelo packwiz em um [outro repositório](https://github.com/roridev/soberana-server-mods).

## Como eu faço pra ligar isso?

- Verifique que você tenha memória ram o suficiente para abrir o server (~1G)
- Tenha o `docker` e o `docker-compose` instalado em sua máquina 

- Abra o `Docker Desktop` (Isso inicia o daemon do docker e abre uma interface gráfica, se você quiser iniciar o daemon pelo `systemctl`/`services.msc` fica sobre seu critério e funciona também.) 

- Edite o `docker-compose.yaml`:

```yaml
    # Edite isso conforme as especificações do seu pc
    # **Depois** do minecraft estar aberto
    environment:
      - MIN_RAM=512M
      - MAX_RAM=1G
```

- Execute `docker build --pull --rm -f "Dockerfile" -t soberana-server:latest "."`

- Execute `docker-compose -f docker-compose.yaml up`

## Dicas

- Para mandar comandos para o servidor use o seguinte comando: 

```
docker exec -it soberana-server_dev_1 rcon-cli --password soberana --port 25597
```

- Para abrir uma shell no servidor use o seguinte comando:

```
docker exec -it soberana-server_dev_1 bash
```

- Para executar o servidor no segundo plano use o seguinte comando:

```
docker-compose -f docker-compose.yaml up -d
```

- **Não adicione a porta do RCON no docker-compose.yml**
