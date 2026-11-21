#!/bin/sh
# ----------------------------------------------------------------------------
# Maven Wrapper (Linux / macOS)
# Baixa (se necessário) a versão do Maven definida em
# .mvn/wrapper/maven-wrapper.properties e executa o comando recebido.
# Uso:  ./mvnw spring-boot:run     |     ./mvnw test     |     ./mvnw clean package
# ----------------------------------------------------------------------------
set -e

BASE_DIR=$(cd "$(dirname "$0")" && pwd -P)
PROPS="$BASE_DIR/.mvn/wrapper/maven-wrapper.properties"

if [ ! -f "$PROPS" ]; then
  echo "Arquivo nao encontrado: $PROPS" >&2
  exit 1
fi

DIST_URL=$(sed -n 's/^distributionUrl=//p' "$PROPS" | tr -d '\r' | head -n 1)
if [ -z "$DIST_URL" ]; then
  echo "distributionUrl nao encontrada em $PROPS" >&2
  exit 1
fi

DIST_FILE=${DIST_URL##*/}          # apache-maven-3.9.11-bin.zip
DIST_NAME=${DIST_FILE%-bin.zip}    # apache-maven-3.9.11
MAVEN_HOME_BASE="${MAVEN_USER_HOME:-$HOME/.m2}/wrapper/dists/$DIST_NAME"
MVN_CMD="$MAVEN_HOME_BASE/$DIST_NAME/bin/mvn"

if [ ! -x "$MVN_CMD" ]; then
  echo "Baixando Maven: $DIST_URL"
  mkdir -p "$MAVEN_HOME_BASE"
  TMP_ZIP="$MAVEN_HOME_BASE/$DIST_FILE.tmp"

  if command -v curl >/dev/null 2>&1; then
    curl -fsSL -o "$TMP_ZIP" "$DIST_URL"
  elif command -v wget >/dev/null 2>&1; then
    wget -q -O "$TMP_ZIP" "$DIST_URL"
  else
    echo "Instale curl ou wget para o wrapper poder baixar o Maven." >&2
    exit 1
  fi

  if command -v unzip >/dev/null 2>&1; then
    unzip -q -o "$TMP_ZIP" -d "$MAVEN_HOME_BASE"
  elif command -v jar >/dev/null 2>&1; then
    (cd "$MAVEN_HOME_BASE" && jar xf "$TMP_ZIP")
  else
    echo "Instale unzip (ou use um JDK com o comando jar) para extrair o Maven." >&2
    exit 1
  fi

  rm -f "$TMP_ZIP"
  chmod +x "$MVN_CMD"
fi

exec "$MVN_CMD" "$@"
