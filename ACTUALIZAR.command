#!/bin/bash
# SUBE A GITHUB LA ULTIMA VERSION DE LA WEB.
#
# Doble clic y listo. Regenera la pagina desde el juego de verdad (lee el
# binario y los niveles, asi que siempre sale sincronizada con la ultima
# cinta), la copia aqui y la sube.
set -e
cd "$(dirname "$0")"
JUEGO=~/Desktop/"IRON FIST"/migracion/proyecto/ironfist_handoff
echo "Regenerando la pagina desde el juego..."
( cd "$JUEGO" && .venv/bin/python mkweb.py )
cp ~/Desktop/"IRON FIST"/web/ironfist.html index.html
if git diff --quiet index.html; then
  echo "No ha cambiado nada. Nada que subir."
else
  git add -A
  git commit -m "Actualizacion: $(date '+%d/%m/%Y %H:%M')"
  git push
  echo
  echo "Subido.  https://lesbeziers.github.io/ironfist-web/"
  echo "(tarda uno o dos minutos en verse)"
fi
echo
read -p "Pulsa INTRO para cerrar."
