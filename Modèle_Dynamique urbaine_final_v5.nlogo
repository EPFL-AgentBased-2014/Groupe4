globals [
  ;; Déclarations des variables pour les graphiques de l'interface
  gradient-pollution
  pc_pollution
  
  nb-groups
  moyenne-individus
  centers?
  
  happy-regroup
  happy-pollution
  happy-centers
  happy
  
  actual-happy-regroup
  recall-happy-regroup1
  recall-happy-regroup2
  recall-happy-regroup3
  recall-happy-regroup4
  moyenne5-happy-regroup
  
  actual-happy-pollution
  recall-happy-pollution1
  recall-happy-pollution2
  recall-happy-pollution3
  recall-happy-pollution4
  moyenne5-happy-pollution
  
  actual-happy-centers
  recall-happy-centers1
  recall-happy-centers2
  recall-happy-centers3
  recall-happy-centers4
  moyenne5-happy-centers
  
  actual-happy
  recall-happy1
  recall-happy2
  recall-happy3
  recall-happy4
  moyenne5-happy
  
  actual-nb-groups
  recall-nb-groups1
  recall-nb-groups2
  recall-nb-groups3
  recall-nb-groups4
  moyenne5-nb-groups
]


breed [individus individu]
breed [centers center]


individus-own [
  move?
  regroup?
  dispersion?
  happy-regroup?  
  happy-pollution?
  happy-centers?
  pollution-tolerate-aleatoire
  near-polluted
  voisins
  peopleITolerate
]


patches-own [
  t
  white-patch
  pollution
  nb-colorated-patches-in-visoin
  count-colorated-in-vision
]


to setup
  ;; Définition des paramètres initiaux
  clear-all
  reset-ticks
  
  make-individus init-individus 
  
  ;; Initialisation des variables
  
  set moyenne-individus 0
  set nb-groups 0
  set centers? false
  
  ;; Variables pour le lissage des courbes dans l'interface
  ;; % happy-regroup
  set actual-happy-regroup 0
  set recall-happy-regroup1 0
  set recall-happy-regroup2 0
  set recall-happy-regroup3 0
  set recall-happy-regroup4 0
  set moyenne5-happy-regroup 0
  
  ;; % happy-pollution
  set actual-happy-pollution 0
  set recall-happy-pollution1 0
  set recall-happy-pollution2 0
  set recall-happy-pollution3 0
  set recall-happy-pollution4 0
  set moyenne5-happy-pollution 0
  
  ;; % happy-centers
  set actual-happy-centers 0
  set recall-happy-centers1 0
  set recall-happy-centers2 0
  set recall-happy-centers3 0
  set recall-happy-centers4 0
  set moyenne5-happy-centers 0
  
  ;; % happy
  set actual-happy 0
  set recall-happy1 0
  set recall-happy2 0
  set recall-happy3 0
  set recall-happy4 0
  set moyenne5-happy 0
  
  ;; nb-groupes
  set actual-nb-groups 0
  set recall-nb-groups1 0
  set recall-nb-groups2 0
  set recall-nb-groups3 0
  set recall-nb-groups4 0
  set moyenne5-nb-groups 0
  
  ask individus [
    set move? true
    set regroup? false
    set dispersion? false
    set happy-regroup? false
    set happy-pollution? false
    set happy-centers? false
    set peopleITolerate 30
  ]
  
  ask patches [
    set pcolor 9.9
  ]
  
  ;; Initialisation des formes des tortues
  set-default-shape individus "person"
  set-default-shape centers "flag"
  
  happiness
  
end


to go 
  ;; A chaque tick, on effectue cette procédure!
  set gradient-pollution 9.9 * (0.001 * pollution-rate)
  
  ask individus [
    set pollution-tolerate-aleatoire random (pollution-tolerate + 0.99)
    regroup
    move 1
    pollutate
    reac-polution
    compter_voisins
  ] 
  
  ask patches [
    set nb-colorated-patches-in-visoin 0
    set count-colorated-in-vision 0
    
    if pcolor != 9.9 [
      decontaminate
    ]
    set pollution pcolor
  ]
  
  happiness
  
  set pc_pollution ( 1 - (( mean [pollution] of patches ) / 9.9 )) * 100
  set moyenne-individus mean [voisins] of individus
  set nb-groups (init-individus / moyenne-individus)
  set nb-groups round nb-groups
  
  ifelse any? centers [set centers? true] [set centers? false]
  
  ;; Lissage des courbes dans l'interface
  
  ;; Pour lisser la courbe du happy-regroup dans l'interface, on prend la moyenne des happy-regroup des 5 derniers ticks
  set recall-happy-regroup4 recall-happy-regroup3
  set recall-happy-regroup3 recall-happy-regroup2
  set recall-happy-regroup2 recall-happy-regroup1
  set recall-happy-regroup1 actual-happy-regroup
  set actual-happy-regroup happy-regroup
  
  set moyenne5-happy-regroup (actual-happy-regroup + recall-happy-regroup1 + recall-happy-regroup2 + recall-happy-regroup3 + recall-happy-regroup4) / 5 
  
  
  ;; Pour lisser la courbe du happy-pollution dans l'interface, on prend la moyenne des happy-pollution des 5 derniers ticks
  set recall-happy-pollution4 recall-happy-pollution3
  set recall-happy-pollution3 recall-happy-pollution2
  set recall-happy-pollution2 recall-happy-pollution1
  set recall-happy-pollution1 actual-happy-pollution
  set actual-happy-pollution happy-pollution
  
  set moyenne5-happy-pollution (actual-happy-pollution + recall-happy-pollution1 + recall-happy-pollution2 + recall-happy-pollution3 + recall-happy-pollution4) / 5
  
  
  ;; Pour lisser la courbe du happy-centers dans l'interface, on prend la moyenne des happy-centers des 5 derniers ticks
  set recall-happy-centers4 recall-happy-centers3
  set recall-happy-centers3 recall-happy-centers2
  set recall-happy-centers2 recall-happy-centers1
  set recall-happy-centers1 actual-happy-centers
  set actual-happy-centers happy-centers
  
  set moyenne5-happy-centers (actual-happy-centers + recall-happy-centers1 + recall-happy-centers2 + recall-happy-centers3 + recall-happy-centers4) / 5
  
  
  ;; Pour lisser la courbe du happiness dans l'interface, on prend la moyenne des happy des 5 derniers ticks
  set recall-happy4 recall-happy3
  set recall-happy3 recall-happy2
  set recall-happy2 recall-happy1
  set recall-happy1 actual-happy
  set actual-happy happy
  
  set moyenne5-happy (actual-happy + recall-happy1 + recall-happy2 + recall-happy3 + recall-happy4) / 5
  
  
  ;; Pour lisser la courbe du nombre de groupes dans l'interface, on prend la moyenne des nombres de groupes des 5 derniers ticks
  set recall-nb-groups4 recall-nb-groups3
  set recall-nb-groups3 recall-nb-groups2
  set recall-nb-groups2 recall-nb-groups1
  set recall-nb-groups1 actual-nb-groups
  set actual-nb-groups nb-groups
  
  set moyenne5-nb-groups (actual-nb-groups + recall-nb-groups1 + recall-nb-groups2 + recall-nb-groups3 + recall-nb-groups4) / 5
  
  tick
end



;; ------------------------------------------------------
;; PCROCEDURES GENERALES
;; ------------------------------------------------------


;; INDIVIDUS

to make-individus [#n]
  ;; Créer des individus
  create-individus #n 
  [ 
    set-individus
    setxy random-xcor random-ycor
  ]
end


to set-individus
  ;; Définit la taille et la couleur des individus
  set color green
  set size 1
end


to compter_voisins
  ;; Détermine le nombre d'individus voisins pour un individu donné et dans un rayon donné
  set voisins count individus in-radius vision
end


to happiness
  ;; Rapporte si l'individu est heureux ou non
  ;; Il est heureux s'il trouve # peopleITolerate individus dans son rayon de vision,
  ;; s'il se trouve sur une cellule dont les voisines ne sont pas toutes polluées (en fonction du
  ;; seuil de tolérance fixé dans l'interface) et si un centre d'intérêt rentre dans son champ
  ;; de vision
  
  let count-happy-regroup 0
  let sum-happy-regroup 0
  
  ask individus [
    
    set near-polluted count neighbors with [pcolor <= ( 2 * gradient-pollution)]
    let A count individus in-radius vision with [distance myself > 0.01]
    
    ;; L'individu est graduellement heureux s'il a k individus dans son champ de vision (k allant de 1 jusqu'à peopleITolerate/2)
    ;; puis inversement, il devient malheureux (mal à l'aise) si il a m individus dans son champ de vision (m allant de {peopleITolerate/2 + 1} jusqu'à peopleITolerate)
    ifelse A > 0 and A <= peopleITolerate [
      ifelse A <= ceiling (peopleITolerate / 2) [
        set count-happy-regroup A * 1 / ceiling ((peopleITolerate) / 2)
        set sum-happy-regroup sum-happy-regroup + count-happy-regroup
      ] [
        set count-happy-regroup 1 - (A - ceiling (peopleITolerate / 2)) * 1 / ceiling (peopleITolerate)
        set sum-happy-regroup sum-happy-regroup + count-happy-regroup
      ]
    ] [
      set count-happy-regroup 0
    ]
    
    ;; L'individu est heureux s'il n'est pas entouré de plus de # pollution-tolerate-aleatoire cellules autour de lui
    ifelse near-polluted > pollution-tolerate-aleatoire [
      set happy-pollution? false
    ] [
      set happy-pollution? true
    ]
    
    ;; L'individu est heureux s'il voit un centre d'intérêt dans son champ de vision
    ifelse any? centers in-radius vision [ ; On devient heureux si on est aussi proche d'un centre que l'on souhaîte être proche d'un individu
      set happy-centers? true
    ] [
      set happy-centers? false
    ]
  ]
  
  ;; On comptabilise les heureux
  set happy-regroup sum-happy-regroup / init-individus
  set happy-pollution count individus with [happy-pollution? = true]  / init-individus
  set happy-centers count individus with [happy-centers? = true] / init-individus
  
  ;; On fait la différence si les centres d'intérêts sont pris en compte par le modèle ou non pour évaluer le bonheur de manière générale
  ifelse centers? [
    set happy (happy-regroup + happy-pollution + happy-centers) / 3
  ] [
    set happy (happy-regroup + happy-pollution) / 2
  ]
  
end


;; ------------------------------------------------------
;; CENTERS

to draw-centers
  ;; On crée les centres d'intérêts si le bouton "draw" de l'interface est enfoncé, et si le bouton gauche de la souris clique sur les patches où l'utilisateur le souhaite.
  ;; Si un centre d'intérêt est déjà placé sur le patch sélectionné, alors ça l'efface. Sinon, ça en crée.
  ;; Tant que le bouton gauche de la souris est appuyé et que la souris se ballade sur l'écran, alors l'utilisateur crée/supprime des centres d'intérêts.
  let erasing? [any? centers-here] of patch mouse-xcor mouse-ycor
  while [mouse-down?] [
    ask patch mouse-xcor mouse-ycor
      [ 
        ifelse erasing? [ 
          ask centers-here [die] 
        ] [ 
          if count centers-here < 1 [
            sprout-centers 1 [set-centers]
          ] 
        ]
      ]  
    display 
  ]
end


to set-centers
  ;; On définit la couleur et la taille des centres d'intérêts
  set color red
  set size 1
end

to erase-centers
  ;; Supprimer tous les centres d'intérêts d'un coup (bouton 'erase' dans l'interface)
  ask centers [die]
end



;; ------------------------------------------------------
;; DEPLACEMENTS INFDIVIDUS

to move [x]
  ;; Si nous n'avons pas repéré d'individus dans notre rayon de vision, alors on continue à se déplacer
  ;; de façon aléatoire
  if move? = true or dispersion? = true [
    rt random 360
    lt random 360
  ]
  fd x
end


;; ATTRACTION

to regroup
  ;; On tente cette procédure à chaque tick
  ;; Si on trouve au moins un individu ou un centre d'intérêt dans notre rayon de vision, alors on s'en raproche. Sinon
  ;; on continue à bouger aléatoirement (procédure move ci-dessous)
  ifelse any? centers in-radius vision [
    let i random-float 1
    ifelse i < influence-centers / 100 [
      regroup-toward-centers
    ] [
      regroup-towards-individus
    ]
  ] [
    regroup-towards-individus
  ]
end


to regroup-towards-individus
  ;; Procédure pour se rapprocher des individus
  let peopleISee other individus in-radius vision with [distance myself > 0.1] ; Les individus ne se regroupent que s'ils sont à une distance plus grande que 0.1 l'un de l'autre
  let B count peopleISee
  
  ifelse B > 0 [
    ;; Si l'individu est satisfait du # de personne dans son champ de vision, alors il choisit un individu parmi ceux qu'il voit et s'en rapproche
    ;; sinon il se déplace aléatoirement autour de lui de deux pas, pour tenter de trouver une situation plus agréable
    ifelse B <= peopleITolerate [
      set heading towards one-of peopleISee
      set move? false
      set regroup? true
      set dispersion? false
      set happy-regroup? true
    ] [
      move 2
    ]
  ] [
    set move? true
    set regroup? false
    set happy-regroup? false
  ]
end


to regroup-toward-centers
  ;; Procédure pour se rapprocher des individus
  let centerISee centers in-radius vision
  
  if count centerISee > 0 [
    set heading towards one-of centerISee
    set move? false
    set regroup? true
    set dispersion? false
  ]
end



;; ------------------------------------------------------
;; POLLUTION

to pollutate
  ;; Colorer les cases après le passage d'un individu (gradient de blanc-noir)
  ifelse pcolor >= gradient-pollution [
    ;; Gradient de noir
    set pcolor pcolor - gradient-pollution
  ] [
    set pcolor 0
  ]
  if pollution-rate != 0 [
    set t soil-pollution-retention / 4 + 1
  ]
end


to decontaminate
  ;; Décolorer les cases après le passage d'un individu
  set t t - 1
  let newvalue pcolor + gradient-pollution
  if t <= 0 [
    ifelse newvalue < 8.9 [
      set pcolor pcolor + 1
    ] [
      set pcolor 9.9
    ]
  ]
end


;; ------------------------------------------------------
;; REACTION POLLUTION

to reac-polution
  ;; Black pollution
  let black-neighbors? (count neighbors with [pcolor = 0] >= pollution-tolerate-aleatoire)
  
  ifelse black-neighbors? [set happy-pollution? false] [set happy-pollution? true]
  
  ifelse black-neighbors? [
    ifelse any? neighbors with [pcolor = 9.9] [
      set heading towards one-of neighbors with [pcolor = 9.9]
    ] [
      move 3
    ] 
  ] [
    set dispersion? true
  ]
  
  ;; Near black pollution 1
  let black-neighbors1? (count neighbors with [pcolor = 0 + gradient-pollution] >= pollution-tolerate-aleatoire)
  
  ifelse black-neighbors1? [
    ifelse any? neighbors with [pcolor = 9.9] [
      set heading towards one-of neighbors with [pcolor = 9.9]
    ] [
      move 2.5
    ] 
  ] [
    set dispersion? true
  ]
  
  ;; Near black pollution 2
  let black-neighbors2? (count neighbors with [pcolor = 0 + 2 * gradient-pollution] >= pollution-tolerate-aleatoire)
  
  ifelse black-neighbors2? [
    ifelse any? neighbors with [pcolor = 9.9] [
      set heading towards one-of neighbors with [pcolor = 9.9]
    ] [
      move 2
    ] 
  ] [
    set dispersion? true
  ]
  
  ;; Near black pollution 3
  let black-neighbors3? (count neighbors with [pcolor = 0 + 3 * gradient-pollution] >= pollution-tolerate-aleatoire)
  
  ifelse black-neighbors2? [
    ifelse any? neighbors with [pcolor = 9.9] [
      set heading towards one-of neighbors with [pcolor = 9.9]
    ] [
      move 1
    ] 
  ] [
    set dispersion? true
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
199
10
690
522
16
16
14.6
1
10
1
1
1
0
1
1
1
-16
16
-16
16
1
1
1
ticks
30.0

INPUTBOX
12
112
110
172
init-individus
150
1
0
Number

BUTTON
13
47
79
80
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
109
47
172
80
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
12
265
184
298
pollution-tolerate
pollution-tolerate
0
8
3
1
1
NIL
HORIZONTAL

SLIDER
13
442
185
475
soil-pollution-retention
soil-pollution-retention
0
100
30
10
1
NIL
HORIZONTAL

SLIDER
12
181
184
214
vision
vision
0
20
5
1
1
NIL
HORIZONTAL

SLIDER
12
223
184
256
pollution-rate
pollution-rate
0
100
30
10
1
NIL
HORIZONTAL

PLOT
701
221
1390
506
Happiness - Pollution
tick
%
0.0
100.0
0.0
100.0
true
true
"" ""
PENS
"Happy-regroup" 1.0 0 -534828 true "" "plot moyenne5-happy-regroup * 100"
"Happy-pollution" 1.0 0 -2758414 true "" "plot moyenne5-happy-pollution * 100"
"Happy-centers" 1.0 0 -2754856 true "" "plot moyenne5-happy-centers * 100"
"Happy (mean)" 1.0 0 -16777216 true "" "plot moyenne5-happy * 100"
"Soil-pollution" 1.0 0 -7500403 true "" "plot pc_pollution"

PLOT
1228
66
1388
212
Happiness   regroup - pollution
% regroup
% pollution
0.0
101.0
0.0
101.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plotxy happy-regroup * 100 happy-pollution * 100"

SLIDER
12
375
184
408
influence-centers
influence-centers
0
100
30
10
1
NIL
HORIZONTAL

TEXTBOX
14
316
164
334
Centers' parameters
11
0.0
1

TEXTBOX
14
93
164
111
Individus' parameters
11
0.0
1

PLOT
701
66
1064
212
# groups
ticks
# groups
0.0
100.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot moyenne5-nb-groups ;nb-groups"

MONITOR
700
17
793
62
# groups actual
nb-groups
17
1
11

TEXTBOX
11
541
1391
653
Ce modèle montre le comportement d'individus à la quête du bonheur. Le bonheur est fonction de 3 caractéristiques:\n  1° Le nombre d'individus visibles dans un rayon \"vision\". Si ce nombre d'individus est compris entre 0 et 15, alors l'individu est graduellement plus heureux plus ce nombre augmente, l'inverse entre 15 et 30, et au delà de 30 individus, il cherche à bouger dans un rayon de 2 pas autours de lui pour trouver une meilleure situation.\n  2° La pollution qui entoure l'individu. Moins il y en a, plus il est heureux. Le seuil de tolérance est fixé aléatoirement entre 0 et pollution-tolerate pour chaque individu. En se déplaçant, l'individu pollue (il produit des déchets); il laisse une trace derrière lui. Plus la case est polluée, plus elle devient noire. Le sol possède une capacité de rétention de la pollution: soil-pollution-retention.\n  3° Les centres d'intérêts (marché, école, gallerie d'art...). Si au moins un centre d'intérêt se trouve dans le rayon de vision de l'individu, alros il est heureux. Les centres d'intérêts possèdent une influence et plus cette influence est grande, plus les individus seront captivés et tenteront d'en rester proche. Pour dessiner un centre d'intérêt, actionner 'draw', et maintenir le bouton gauche de la souris là où vous le souhaitez. Pour effacer un centre d'intérêt, cliquer sur celui-ci en ayant activé 'draw'. Finalement, pour supprimer tous les centres de la fenêtre, cliquer sur 'erase'.
11
0.0
1

TEXTBOX
1099
80
1221
144
Condition d'équilibre dynamique: formation d'un disque noir\n                    -------->\n
11
0.0
1

TEXTBOX
14
426
164
444
Soil's parameter
11
0.0
1

BUTTON
12
333
96
366
draw
draw-centers
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
799
17
857
62
# centers
count centers
17
1
11

BUTTON
102
333
184
366
erase
erase-centers
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.0.5
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="pollution-rate">
      <value value="0"/>
      <value value="10"/>
      <value value="20"/>
      <value value="30"/>
      <value value="40"/>
      <value value="50"/>
      <value value="60"/>
      <value value="70"/>
      <value value="80"/>
      <value value="90"/>
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="vision">
      <value value="0"/>
      <value value="2"/>
      <value value="4"/>
      <value value="6"/>
      <value value="8"/>
      <value value="10"/>
      <value value="12"/>
      <value value="14"/>
      <value value="16"/>
      <value value="18"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="vision-centers">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="soil-pollution-retention">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pollution-tolerate">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="init-individus">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="influence-centers">
      <value value="30"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
