#!/bin/bash
# SUBE A GITHUB LA ULTIMA VERSION DE LA WEB.
#
# Doble clic y listo. Regenera la pagina desde el juego de verdad (lee el
# binario y los niveles, asi que siempre sale sincronizada con la ultima
# cinta), la copia aqui y la sube.
#
# NO DICE "SUBIDO" HASTA QUE LA WEB PUBLICADA ES LA NUEVA.
# El 11/11/2026 subir y publicar dejaron de ser lo mismo: el commit
# llego a GitHub pero la publicacion se quedo en cola y acabo fallando,
# asi que la pagina seguia siendo la de antes. Dar por bueno el `git
# push` es mirar la mitad del camino. Ahora el script espera a que la
# pagina publicada sea la que acabas de subir, y si no llega lo dice.
set -e
cd "$(dirname "$0")"
JUEGO=~/Desktop/"IRON FIST"/migracion/proyecto/ironfist_handoff
WEB=https://lesbeziers.github.io/ironfist-web/index.html

echo "Regenerando la pagina desde el juego..."
( cd "$JUEGO" && .venv/bin/python mkweb.py )
cp ~/Desktop/"IRON FIST"/web/ironfist.html index.html

if git diff --quiet index.html; then
  # NADA QUE SUBIR NO ES NADA QUE HACER. Si lo de aqui ya esta subido
  # pero lo publicado es otra cosa, lo que falta no es el contenido:
  # es que GitHub lo publique. Un commit vacio se lo vuelve a pedir.
  echo "La pagina no ha cambiado desde la ultima vez."
  echo "Pidiendo a GitHub que la publique otra vez..."
  git commit -q --allow-empty -m "Reintentar la publicacion: $(date '+%d/%m/%Y %H:%M')"
else
  git add -A
  git commit -q -m "Actualizacion: $(date '+%d/%m/%Y %H:%M')"
fi
git push -q
echo "Enviado a GitHub. Ahora toca esperar a que lo publique."
echo

# --- esperar a que la web publicada sea esta ---------------------------
MIO=$(wc -c < index.html | tr -d ' ')
for i in $(seq 1 40); do
  SUYO=$(curl -s -H 'Cache-Control: no-cache' "$WEB?z=$RANDOM$i" | wc -c | tr -d ' ')
  if [ "$SUYO" = "$MIO" ]; then
    echo
    echo "LISTO. La web publicada ya es esta."
    echo "https://lesbeziers.github.io/ironfist-web/"
    echo
    read -p "Pulsa INTRO para cerrar."
    exit 0
  fi
  printf "."
  sleep 15
done

echo
echo "*** GITHUB NO LA HA PUBLICADO ***"
echo
echo "El contenido SI esta subido; lo que no sale es la publicacion."
echo "Puedes ver en que ha quedado aqui:"
echo "  https://github.com/Lesbeziers/ironfist-web/actions"
echo
echo "Mientras tanto, el juego entero esta en un solo fichero:"
echo "  ~/Desktop/IRON FIST.html"
echo "Doble clic y funciona sin internet. Tambien se manda por AirDrop."
echo
read -p "Pulsa INTRO para cerrar."
