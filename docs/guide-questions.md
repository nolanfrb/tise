# Guide d'écriture des questions — Tise

Ce guide fait foi sur le **format** de toute carte de la banque (`Tise/Features/Game/Data/Resources/prompts.json`) :
champs, jetons, règles par type. Le **ton** fait foi dans `.claude/skills/tise-cards/references/charte.md`,
calibrée avec Nolan le 24/10/2026 : en cas de désaccord sur la formulation, la charte gagne.

## D'où viennent les règles

- **Observation de TOZ** (captures du 17/10/2026 et démo web `toz-app.com/fr/games/…`) : format et ton
  seulement. Aucune question TOZ n'est reprise : leur banque est leur contenu protégé.
  - Deux niveaux par jeu, **Soft** et **Hot**, plus **Aléatoire** qui mélange les deux.
  - Carte : une catégorie en petit au-dessus (« Je n'ai jamais », « Action », « Vérité »), la phrase en très gros.
  - Une pastille « N toz » sur chaque carte : le nombre de gorgées en jeu.
  - Phrases courtes, tutoiement, langage oral et un peu d'argot (mec, meuf, pote, crush, story, DM).
  - Les questions Hot nomment parfois un joueur présent, surligné en couleur.
- **Bonnes pratiques recensées** (Narcity, guides « dirty truth or dare », guides « never have I ever ») :
  - Monter en intensité progressivement : on ne commence pas par le plus osé.
  - Une bonne question **déclenche une histoire** (« raconte ! »), elle ne cherche pas seulement la honte.
  - « Je n'ai jamais » marche quand une partie du groupe boit, pas tout le monde ni personne.
  - Une action doit être faisable sur place, sans danger, et respecter les limites de chacun.
  - Chaque joueur peut refuser : il boit à la place. Le refus ne se discute pas.

## Les trois types de carte

| Type | Qui la reçoit | Forme |
|---|---|---|
| `statement` (Je n'ai jamais) | tout le groupe | la suite de « Je n'ai jamais », sans ces mots |
| `truth` (Vérité) | le joueur dont c'est le tour | une question à la 2ᵉ personne (« tu ») |
| `dare` (Action) | le joueur dont c'est le tour | un impératif à la 2ᵉ personne |

## Format d'une entrée

```json
{
  "kind": "dare",
  "level": "hot",
  "sips": 3,
  "player": "any",
  "target": "opposite",
  "text": "Murmure à l'oreille de {target} pourquoi tu {t:le|la} trouves {t:craquant|craquante}"
}
```

| Champ | Valeurs | Sens |
|---|---|---|
| `kind` | `statement`, `truth`, `dare` | le type de carte |
| `level` | `soft`, `hot` | Soft : tout public adulte, bon enfant. Hot : 18+, séduction et sexe |
| `sips` | 1 à 5 | les tises en jeu (l'unité de l'app : une tise, une gorgée) : celles que boit qui l'a fait (Je n'ai jamais) ou qui refuse (Action ou Vérité) |
| `player` | `any`, `male`, `female` | le sexe du joueur qui peut recevoir la carte. `any` dans 85 % des cas ; toujours `any` pour `statement` |
| `target` | `none`, `any`, `opposite`, `same`, `male`, `female` | un autre joueur nommé dans la phrase via `{target}`. `opposite`/`same` se comprennent par rapport au joueur dont c'est le tour |
| `text` | la phrase | voir les jetons ci-dessous |

### Jetons dans `text`

| Jeton | Remplacé par |
|---|---|
| `{target}` | le prénom du joueur ciblé. Obligatoire si `target` ≠ `none`, interdit sinon |
| `{p:forme masculine\|forme féminine}` | l'accord selon le sexe du joueur dont c'est le tour (`truth`/`dare` uniquement) |
| `{t:forme masculine\|forme féminine}` | l'accord selon le sexe du joueur ciblé (seulement si `target` ≠ `none`) |

Exemples : `As-tu déjà été {p:jaloux|jalouse} du couple d'un pote ?` ·
`Fais un compliment à {target} sur ce qui te {p:rend fou|rend folle} chez {t:lui|elle}`.

Pour `target: "male"` ou `"female"` le sexe de la cible est connu : on écrit directement l'accord, sans `{t:…}`.

Le jeu élide tout seul « de » et « que » devant un prénom qui commence par une voyelle ou un h
(« la main d'Anaïs », « dis qu'Hugo… ») : on écrit `de {target}` et `que {target}` normalement.

## Règles par type

### Je n'ai jamais (`statement`)
- Le texte **continue** « Je n'ai jamais » : il commence par un participe passé en minuscule
  (« dormi dans une baignoire »), sans point final.
- **Grammaire neutre** : le lecteur peut être un homme ou une femme. Aucun accord avec « je » :
  pas d'auxiliaire être (« allé », « tombé », « sorti » au sens être), pas d'adjectif (« été jaloux »).
  Tourner autrement : « eu une crise de jalousie », « fini la soirée dans un autre lit ».
- Négation : « jamais » appelle « de/d' » devant un complément indéfini (« eu **de** crush », « pris **de** râteau »).
- 12 mots au plus (charte). Concret et visuel plutôt qu'abstrait.
- Vise un **taux de « déjà fait » de 20 à 70 %** dans un groupe de 20-30 ans.
- `{target}` permis (« menti à {target} ») avec `target: "any"` ; jamais de `{p:…}`.

### Vérité (`truth`)
- Une vraie question, réponse possible en moins d'une minute.
- Les meilleures forcent un **choix** ou un **classement** (« Qui ici… », « Entre X et Y… », « Top 3… »),
  ou appellent une **anecdote** (« Raconte la fois où… »).
- « Qui ici… » est très bon : il implique le groupe sans `{target}`.
- 6 à 22 mots.

### Action (`dare`)
- Faisable **dans la pièce**, en moins de deux minutes, avec ce qu'on a sur soi : téléphone, verre, vêtements.
- Jamais dangereux : pas d'alcool forcé hors gorgées, pas de cul sec, pas de conduite, pas d'appel aux urgences,
  rien qui casse, rien qui blesse, rien dehors la nuit.
- Ce qui sort du groupe (message, story, appel) reste gentil ou drôle, jamais humiliant pour un tiers, jamais
  définitif (pas de publication qu'on ne peut pas supprimer ensuite).
- Contact physique avec un autre joueur : uniquement en Hot ou en geste amical en Soft (câlin, high-five),
  toujours avec `{target}` pour que la personne soit nommée et puisse refuser elle aussi.
- 8 à 25 mots, impératif.

## Soft et Hot

| | Soft | Hot |
|---|---|---|
| Public | adultes, groupe mixte qui se connaît plus ou moins | 18+, potes proches, fin de soirée |
| Thèmes | flemme, honte en public, téléphone et réseaux, taf et études, famille, voyages, bouffe, soirées, crushs et râteaux, petits mensonges, argent | séduction, dates et applis, premières fois, lieux insolites, sextos, fantasmes, ex, préférences au lit, tromperie, walk of shame |
| Gorgées | 1 à 3 | 2 à 5 |
| Limite | rien de sexuel explicite | suggestif et cru permis, jamais pornographique ni graphique |

**Interdits partout** : mineurs, absence de consentement, inceste, violence, drogues dures, religion ou origine
comme cible de moquerie, moquerie du physique d'un joueur, harcèlement d'un tiers.

## Ciblage par sexe

- `opposite` : séduction, bisou, regard, danse collée, compliment charmeur.
- `same` : câlin de bromance ou de girl power, imitation, duo.
- `male` / `female` en `target` : quand l'action suppose le sexe de la cible (« emprunte la veste de… »).
- `player: male/female` : seulement quand la question n'a de sens que pour un sexe (≈ 10 % des Vérités et
  Actions). Le jeu ne tire jamais une carte dont la contrainte n'a aucun joueur pour la satisfaire.

## Originalité et variété

- Écrire du neuf. Pas de reprise mot pour mot d'une app ou d'un site existant, pas de quasi-doublon dans la banque.
- Varier les ouvertures : pas dix Vérités de suite qui commencent par « Quel est ».
- Varier les thèmes selon les tableaux ci-dessus, aucun thème au-delà de 15 % d'un lot.

## Sans tact

Le jeu des vérités qu'on pense tout bas sur les gens présents. Deux publics : **Potes** (le groupe) et
**Couple** (deux joueurs en couple). Deux niveaux : **Soft** (`level: "soft"`) et **Hard** (`level: "hot"`).

### Ce que montre l'app de référence (Sans Tact, App Store, captures du 17/10/2026)

Format seulement, aucune question reprise :
- une carte s'adresse à **un joueur nommé**, son prénom en couleur en tête de phrase, qui doit répondre
  en **désignant quelqu'un** du groupe ;
- une carte de **vote** fait lever la main à tout le monde au sujet d'un joueur nommé ;
- une carte de **pointage** fait désigner tout le monde en même temps ;
- trois intensités (Soft, Hard, Mix), des modes Potes, Couple, « Les absents ont toujours tort ».

### Ce qui fait une bonne carte Sans tact

Le drama vient du **choix** qu'on impose (désigner, noter, comparer), jamais de la méchanceté de la phrase.

- **Vise un comportement, une habitude, un choix, une manie** : comment on drague, on s'habille, on répond
  aux messages, on gère l'argent d'une soirée, on part sans dire au revoir. Jamais l'identité, le physique,
  le poids, la santé, l'argent de quelqu'un, sa famille, son origine, sa religion, son orientation.
- **La réponse se défend en une phrase et fait rire.** La personne désignée doit pouvoir répliquer.
- **Humain** : environ 30 % des cartes sont chaleureuses (admiration, gratitude, confiance, « qui ici… pour
  toi ») ou cachent un compliment derrière une pique. C'est ce qui rend le jeu jouable deux heures.
- **Du drama, pas trop** : on peut piquer (« qui ici devrait répondre plus vite à ses messages ? »), on ne
  casse pas une amitié (« qui ici tu n'aimes pas ? » est interdit). En Soft, on ne juge pas le couple d'un
  joueur présent. En Hard, on peut parler d'ex, de sexe, de défauts, de jalousie, toujours sans cruauté.
- **Jamais** : deviner l'orientation de quelqu'un, révéler le secret d'un autre, accuser quelqu'un de
  tromper, parler de mineurs, de violence, de drogues dures.

### Les structures qui marchent

| Structure | Type | Exemple (écrit pour ce guide) |
|---|---|---|
| Désignation par un superlatif de comportement | `ask` | `{player}, qui ici finit toujours par raconter la même anecdote ?` |
| Jugement direct sur un joueur | `ask` | `{player}, quelle habitude de {target} tu changerais si tu pouvais ?` |
| Comparaison | `ask` | `{player}, entre {target} et toi, qui ment le mieux ?` |
| Projection | `ask` | `{player}, dans dix ans, {target} fait quel métier ?` |
| Aveu sur le groupe | `ask` | `{player}, à qui ici tu confierais ton téléphone déverrouillé ?` |
| Vote | `vote` | `Levez la main si vous pensez que {target} a déjà stalké un ex cette semaine` |
| Pointage | `point` | `À trois, pointez la personne qui arrivera en retard à son propre mariage` |
| Couple, sur l'autre | `ask` | `{player}, qu'est-ce que {target} fait sans s'en rendre compte et qui te fait craquer ?` |
| Couple, qui de nous deux | `point` | `À trois, pointez celui ou celle de vous deux qui boude le plus longtemps` |

### Format

```json
{"kind": "ask", "level": "soft", "audience": "friends", "sips": 2, "player": "any", "target": "none",
 "text": "{player}, qui ici finit toujours par raconter la même anecdote ?"}
```

| Champ | Valeurs |
|---|---|
| `kind` | `ask` (question à un joueur), `vote` (tout le monde lève la main au sujet d'un joueur), `point` (tout le monde désigne en même temps) |
| `level` | `soft` ou `hot` (affiché « Hard ») |
| `audience` | `friends` (Potes) ou `couple` |
| `sips` | 1 à 3 en Soft, 2 à 5 en Hard. `ask` : ce que boit le joueur s'il refuse. `vote` : ce que boit `{target}` si la majorité lève la main. `point` : ce que boit la personne la plus désignée |
| `player` | `any`, `male`, `female` : le sexe du joueur qui reçoit une carte `ask` (`any` dans 90 % des cas, toujours `any` pour `vote` et `point`) |
| `target` | `none`, `any`, `opposite`, `same`, `male`, `female` (voir les règles par type) |

### Règles par type

- **`ask`** : contient `{player}` (le plus souvent en tête : « {player}, … ») ; une question finit par « ? »,
  une consigne (devinette, tour de table, question à poser, note entre deux joueurs) non ; 20 mots au plus. `{target}` permis selon `target`. Accords avec `{p:…|…}` (joueur) et `{t:…|…}` (cible).
- **`vote`** (Potes seulement) : commence par « Levez la main si », contient `{target}` (`target` : `any`,
  `male` ou `female`), pas de `{player}` ni de `{p:…}`, `{t:…|…}` permis, pas de « ? » final, 8 à 24 mots.
- **`point`** : commence par « À trois, pointez » ou « Votez tous pour », aucun jeton, `target: "none"`,
  pas de « ? » final, 20 mots au plus. En Couple : « celui ou celle de vous deux qui… ».
- **Couple** : seulement `ask` et `point`. Une carte `ask` de couple parle presque toujours de l'autre :
  `target: "any"` (la table n'a que deux joueurs, `{target}` est donc le ou la partenaire). Jamais
  `opposite` ni `same` : le couple peut être de même sexe. Elle reste légère en Soft (habitudes, souvenirs,
  belle-famille, vacances, jalousie gentille) ; en Hard, intimité, ex, fantasmes, défauts, sans cruauté.

Le jeu élide tout seul « de » et « que » devant un prénom à voyelle : écrire `de {target}` normalement.

## C'est un 10 mais

Une personne parfaite (« un 10 »), puis un « mais » qui gâche tout. À trois, chacun montre sa nouvelle note
avec ses doigts, de 0 à 10. La note la plus haute et la plus basse boivent les tises de la carte et défendent
leur chiffre ; si tout le monde a mis la même note, tout le monde boit. Le lecteur change à chaque carte.

### D'où viennent les règles

Analyse du 18/10/2026 (démo web TOZ reconstituée depuis son code, ses articles, C.1.10, 10 Mais, Aperolt,
Know Your Meme, NBC, Bustle, The Brag, un fil Goodreads ; le détail est dans le rapport de recherche de la
session). Aucune carte n'est reprise : seules la mécanique et la structure le sont.

- Le cœur du jeu est **l'écart entre les notes** : une carte réussie fait tomber la note pour une moitié de
  la table et la laisse intacte pour l'autre.
- Le défaut grave fait l'unanimité vers le bas, le défaut trop léger vers le haut : dans les deux cas, rien
  ne se passe. On vise **le milieu qui divise**.
- Les mots de fréquence dosent la carte : « a déjà fait X » divise, « fait X tous les jours » condamne.
- Impliquer le joueur (« ton chien », « avec toi », « tes potes ») rend le défaut plus coûteux.
- La démo TOZ part d'un 10 dans 4 cartes sur 5 ; le reste est en **mode inverse** : une note basse suivie
  d'une qualité, qui peut faire monter la note.

### La carte

L'app affiche « C'est un {score}, mais… », puis le texte de la carte, qui **continue la phrase**.

```json
{"kind": "ten", "level": "soft", "score": 10, "sips": 2, "player": "any", "target": "none",
 "text": "{x:il|elle} répond à tes messages par des captures d'écran de ses notes"}
```

| Champ | Valeurs |
|---|---|
| `kind` | `ten` |
| `level` | `soft` ou `hot` |
| `score` | `10` pour un défaut (environ 80 % des cartes) ; `2` à `6` pour le mode inverse, toujours suivi d'une qualité ou d'un atout |
| `sips` | 1 à 3 en Soft, 2 à 4 en Hot : ce que boivent les notes extrêmes |
| `player`, `target` | toujours `any` et `none` |
| `text` | la suite de « C'est un 10, mais… », en minuscule, sans ponctuation finale, 4 à 14 mots |

### Le genre de la personne décrite

La personne décrite est du sexe opposé à celui du joueur qui lit. On l'écrit avec le jeton
`{x:forme masculine|forme féminine}` : `{x:il|elle}`, `{x:prêt|prête}`, `{x:son mec|sa meuf}`.
Quand une tournure sans accord existe, elle est préférable (« ses vocaux durent dix minutes », « son fond
d'écran, c'est son ex »). Jamais de barre oblique (« il/elle »), jamais de « (e) ».

### Ce qui fait une bonne carte

- **Un comportement précis et visuel, au présent**, pas une étiquette : « applaudit quand l'avion atterrit »
  oui, « est toxique » non. On doit voir la scène.
- **Jamais le physique** qu'on ne choisit pas (taille, poids, visage, corps) : la note de départ en parle
  déjà, le « mais » porte un goût, une habitude, un choix.
- **Jamais grave** : violence, mensonge lourd, négligence, racisme, tromperie avérée tuent la carte (note 0
  pour tout le monde) et la soirée.
- **Jamais un genre dénigré** : la carte se lit aussi bien avec « il » qu'avec « elle ».
- Personne réelle jamais visée : la personne décrite est fictive.

### Familles, de la plus fertile à la moins fertile

1. Goûts clivants : nourriture, musique, séries, astrologie, sport à la télé.
2. Mode de vie : vape, boîte tous les week-ends, sport à 6 h, végan militant, gamer de nuit.
3. Communication et réseaux : délai de réponse, vocaux, stories, ne s'affiche pas avec toi.
4. Red flags relationnels légers et ambigus : ex encore présent, meilleur ami qui est l'ex, jalousie douce.
5. Manies, « beige flags » : petites bizarreries ni bonnes ni mauvaises.
6. Argent : radinerie, addition au centime, dépenses folles.
7. Famille et entourage : mère très présente, potes envahissants.
8. Mode inverse : une note basse et un atout, sérieux ou trivial (« C'est un 4, mais… »).
9. Hygiène à petite dose, seulement les cas limites.
10. Absurde : à saupoudrer, ça fait rire mais débattre peu.

En Hot : intimité, sexe, préférences, ex, jalousie, applis — suggestif, jamais graphique, jamais le corps.
