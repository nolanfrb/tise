---
name: tise-cards
description: Écrire, réécrire ou auditer des cartes de Tise (Je n'ai jamais, Action ou Vérité, Sans tact, C'est un 10 mais) avec le ton calibré par Nolan. À charger dès qu'une tâche ajoute, corrige ou juge des cartes de la banque.
---

# Cartes Tise

La banque de cartes (`Tise/Features/Game/Data/Resources/prompts.json`) se modifie par cette chaîne, jamais à la main
et jamais d'un seul jet : **rédacteur → contrôleur → critique → banque**.

## Ce qui fait foi

1. `references/charte.md` : le ton et la formulation, calibrés avec Nolan. À lire en entier avant d'écrire.
2. `docs/guide-questions.md` : le format JSON, les champs et les jetons de chaque jeu.
3. `references/calibration-2026-10-24.md` : les réponses de Nolan qui fondent la charte, à relire quand une
   règle semble ambiguë.

## La chaîne

1. **Rédacteur** : lancer l'agent `card-writer` avec le jeu, le niveau, le public, le nombre de cartes et le
   chemin du fichier à écrire (un tableau JSON, un lot par fichier, hors du dépôt).
2. **Contrôleur** : `python3 -I .claude/skills/tise-cards/scripts/lint_cards.py <lot> --warnings`. Zéro erreur
   exigé ; chaque point à relire est soit corrigé, soit justifié dans le rapport du rédacteur.
3. **Critique** : lancer l'agent `card-critic` sur le lot. Il n'a pas écrit les cartes. Il note chaque carte
   sur cinq axes et ne garde que celles qui ont au moins 4 partout ; les autres repartent une fois au
   rédacteur avec sa remarque, puis sont jetées.
4. **Banque** : `python3 -I .claude/skills/tise-cards/scripts/update_bank.py --add <lot> --prefix <jeu-niveau-vN>`
   (ou `--replace` avec les `id` existants pour une réécriture, `--remove` pour retirer). Puis relancer le
   contrôleur sur toute la banque, compiler, et vérifier que `Localizable.xcstrings` ne bouge pas.
5. **Nolan** : un échantillon de chaque lot lui est soumis carte par carte (Garde / Jette + raison). Ses
   réponses mettent à jour la charte et la calibration. On ne produit en masse que si au moins 80 % des
   cartes de l'échantillon sont gardées sans retouche.

## Interdits de la chaîne

- Recopier une carte d'une autre app ou d'une liste, même reformulée de près : les exemples externes servent au
  ton et aux structures, jamais au texte.
- Fusionner un lot qui n'est pas passé par le critique.
- Modifier la charte sans une réponse de Nolan qui la fonde : la noter d'abord dans la calibration.
