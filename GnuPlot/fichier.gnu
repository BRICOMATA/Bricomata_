    reset
    set terminal png
    set output "essai1.png"  # Nom du fichier de sortie
    set title textcolor rgb "red" "Mon exemple"  # Titre du graphique, de couleur rouge
    set xlabel "Mes données 1"  # Nom de l'axe x
    set ylabel textcolor rgb "green" "Mes données 2"  #Nom de l'axe y, de couleur verte
    set zlabel offset +5,+4 "Mes données 3"  # Nom de l'axe z et repositionnement au-dessus
    r(x,y)=sqrt(x**2+y**2)
    f(x,y)=sin(r(x,y))/r(x,y)
    set pm3d  # Colorisation de la surface
    set hidden3d  # Masquage du quadrillage
    set isosamples 80,80  # Dimensionnement des entre-axes de la surface
    splot f(x,y) with pm3d at s  # Création du graphique 3D, avec splot


