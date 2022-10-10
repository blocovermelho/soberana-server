# Configuração inicial
FROM eclipse-temurin:17

# Versão do minecraft
ENV MC_VERSION="1.19.2" 

ENV MIN_RAM=1G
ENV MAX_RAM=2G

ARG MC_HELPER_VERSION="1.22.7"
ARG MC_HELPER_BASE_URL=https://github.com/itzg/mc-image-helper/releases/download/v${MC_HELPER_VERSION}

ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

ARG EASY_ADD_VER=0.7.1
ADD https://github.com/itzg/easy-add/releases/download/${EASY_ADD_VER}/easy-add_${TARGETOS}_${TARGETARCH}${TARGETVARIANT} /usr/bin/easy-add
RUN chmod +x /usr/bin/easy-add

RUN easy-add --var os=${TARGETOS} --var arch=${TARGETARCH}${TARGETVARIANT} \
  --var version=1.6.0 --var app=rcon-cli --file {{.app}} \
  --from https://github.com/itzg/{{.app}}/releases/download/{{.version}}/{{.app}}_{{.version}}_{{.os}}_{{.arch}}.tar.gz

RUN curl -fsSL ${MC_HELPER_BASE_URL}/mc-image-helper-${MC_HELPER_VERSION}.tgz \
  | tar -C /usr/share -zxf - \
  && ln -s /usr/share/mc-image-helper-${MC_HELPER_VERSION}/bin/mc-image-helper /usr/bin

# Pasta onde as ferramentas serão instaladas
WORKDIR /opt/tools

# Baixa o quilt modloader
RUN curl -LJo quilt.jar https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/latest/quilt-installer-latest.jar

# Baixa o packwiz
RUN mc-image-helper maven-download \
                           --maven-repo=https://maven.packwiz.infra.link/repository/release/ \
                           --group=link.infra.packwiz --artifact=packwiz-installer --classifier=dist \
                           --skip-existing

# Instala o quilt pelo command line
RUN java -jar quilt.jar install server ${MC_VERSION} --download-server --install-dir=/opt/minecraft

# Pasta do servidor
WORKDIR /opt/minecraft

# Permanencia de dados
VOLUME [ "/opt/minecraft" ]

ARG CACHEBUST=1

RUN java -cp /opt/tools/packwiz-installer-*.jar link.infra.packwiz.installer.Main -s server https://roridev.github.io/soberana-server-mods/pack.toml 

COPY server.properties .
COPY config/ ./config/
COPY start.sh .

RUN echo "eula=true" > eula.txt

CMD /opt/minecraft/start.sh ${MIN_RAM} ${MAX_RAM}

# Expõe a porta padrão do jogo (25565)
EXPOSE 25565/tcp

# Expõe a porta do Simple Voice Mod
EXPOSE 24454/udp
