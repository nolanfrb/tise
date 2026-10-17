# Tise

Jeu de soirée iOS natif : **Action ou Vérité** et **Je n'ai jamais**, niveaux Soft, Hot et Aléatoire.
Les joueurs entrent leur prénom et leur sexe ; le jeu choisit les cartes qui conviennent à la table et nomme
les autres joueurs dans les cartes ciblées. Aucun backend : la banque de cartes est embarquée dans l'app.

## Lancer

Ouvrir `Tise.xcodeproj` (Xcode 27), scheme **Tise**, puis Run sur un iPhone ou un simulateur iOS 26+.

```bash
xcodebuild -project Tise.xcodeproj -scheme Tise -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build
```

## Structure

Mêmes conventions que Yuno : MVVM + Repository par feature, `@Observable` + `@Environment`, zéro dépendance.

| Dossier | Rôle |
|---|---|
| `Tise/App` | point d'entrée et racine de composition (`RootView`) |
| `Tise/Core` | thème (couleurs, typo, transition), `ViewState`, conteneur, composants partagés |
| `Tise/Features/Players` | joueurs : entité, stockage local (`UserDefaults`), roster de session, sheet |
| `Tise/Features/Game` | cartes : entités, tirage (`Deck`), banque JSON, écrans Accueil / Niveau / Partie |

## La banque de cartes

`Tise/Features/Game/Data/Resources/prompts.json` — une carte par ligne. Le format, le ton, les jetons
(`{target}`, `{p:…|…}`, `{t:…|…}`) et les règles de ciblage sont décrits dans
[`docs/guide-questions.md`](docs/guide-questions.md). Les cartes sont en français : c'est du contenu, elles ne
se traduisent pas ; l'interface, elle, existe en français et en anglais.

Les cartes sont originales. TOZ a servi de référence de format et de ton, aucune de ses questions n'est reprise.
