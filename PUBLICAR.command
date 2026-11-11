#!/bin/bash
# PUBLICA EL JUEGO EN GITHUB, la primera vez.
#
# Doble clic. Conecta esta carpeta con el repositorio de GitHub y la sube.
# Solo hay que ejecutarlo UNA VEZ; a partir de ahi se usa ACTUALIZAR.command.
#
# ANTES DE DARLE: hay que haber creado el repositorio en github.com, con
# el boton "New repository", nombre `ironfist-web`, PUBLICO, y sin marcar
# ninguna casilla mas.
cd "$(dirname "$0")"
echo "=========================================="
echo "  PUBLICAR OPERATION IRON FIST EN GITHUB"
echo "=========================================="
echo
if git remote | grep -q origin; then
  echo "Esta carpeta ya esta conectada a GitHub."
else
  echo "Conectando con github.com/Lesbeziers/ironfist-web ..."
  git remote add origin https://github.com/Lesbeziers/ironfist-web.git
fi
git branch -M main
echo
echo "Ahora va a pedirte usuario y contraseña:"
echo "   usuario    : Lesbeziers"
echo "   contraseña : NO la de GitHub. Un TOKEN."
echo "                (GitHub > tu foto > Settings > Developer settings >"
echo "                 Personal access tokens > Tokens classic >"
echo "                 Generate new token > marca la casilla 'repo')"
echo
if git push -u origin main; then
  echo
  echo "=========================================="
  echo "  SUBIDO."
  echo
  echo "  Falta un ultimo paso, en la web de GitHub:"
  echo "    Settings > Pages > Source: Deploy from a branch"
  echo "    rama: main    carpeta: / (root)    > Save"
  echo
  echo "  Y en dos minutos estara en:"
  echo "    https://lesbeziers.github.io/ironfist-web/"
  echo "=========================================="
else
  echo
  echo "*** No ha podido subir. Lo mas probable:"
  echo "    - el repositorio no esta creado todavia en github.com"
  echo "    - o la contraseña no era un token"
fi
echo
read -p "Pulsa INTRO para cerrar."
