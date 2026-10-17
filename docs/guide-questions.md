# Guide d'écriture des questions — Trinque

Ce guide fait foi pour toute question ajoutée à la banque (`Trinque/Features/Game/Data/Resources/prompts.json`).
Il a servi de brief aux agents qui ont écrit la première banque.

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
| `sips` | 1 à 5 | gorgées en jeu : celles que boit qui l'a fait (Je n'ai jamais) ou qui refuse (Action ou Vérité) |
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
- 4 à 14 mots. Concret et visuel plutôt qu'abstrait.
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
