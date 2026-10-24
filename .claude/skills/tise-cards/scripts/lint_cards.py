import argparse
import json
import re
import sys
import unicodedata

LIMITS = {"statement": 12, "truth": 16, "dare": 16, "ask": 20, "vote": 20, "point": 20, "ten": 14}
SIPS = {"soft": range(1, 4), "hot": range(2, 6)}
KINDS_BY_AUDIENCE = {"friends": {"statement", "truth", "dare", "ask", "vote", "point", "ten"}, "couple": {"ask", "point"}}
TARGETS = {"none", "any", "opposite", "same", "male", "female"}
TOKEN = re.compile(r"\{(player|target|[ptx]:[^{}|]+\|[^{}|]+)\}")
SEXTO = re.compile(r"sexto|\bsext|\bnudes?\b", re.I)
WORK = re.compile(r"\bboulot|\btaff?\b|\btravail\b|collègue|\bboss\b|\bpatron|\bmanager\b|\bbureau\b|pot de départ|entretien d'embauche|\bstage\b", re.I)
PHONE = re.compile(r"téléphone|galerie|messages?\b|\bappelle|\benvoie|\bstory|insta|snap|contacts?\b|\bappli|\blike\b|\bDM\b", re.I)
CRUDE = re.compile(r"\bbais(e|er|é|ée|ait|es|ent|eur|euse)\b|levrette|rouler une pelle|\bpelle\b|\bsuc(e|er|é)\b|\bpipe\b|cunni", re.I)

RULES = [
    ("error", "euphémisme", r"couette|coquin|moments? intimes?|galipette|batifol|finir la nuit avec|se chauffer|faire des choses", None),
    ("error", "euphémisme", r"c[âa]lin", {"hot"}),
    ("error", "formule « plutôt A ou B »", r"\bplutôt\b[^?.]*\bou\b", None),
    ("error", "mise en scène", r"\bimit|voix off|\bmime|fais semblant|présentateur|documentaire|\bGPS\b|bulletin|météo|\bimpro|joue (un|une|le rôle|la)\b|\baccent\b", {"dare"}),
    ("error", "comparaison ou métaphore", r"comme si\b|\bfaçon\b|\ben mode\b|\btel(le)? (un|une)\b|digne d'un", {"dare"}),
    ("warning", "comparaison ou métaphore", r"comme si\b|\bfaçon\b|\ben mode\b|\btel(le)? (un|une)\b|digne d'un", {"statement", "truth", "ask", "vote", "point", "ten"}),
    ("error", "matériel", r"bandeau|yeux bandés|glaçon|chantilly|nourriture|\bmiel\b|bougie|menottes|plume|fouet", {"dare"}),
    ("warning", "mot en trop", r"\bjuste\b|\bvraiment\b|\bun peu\b|\bexactement\b|\bcarrément\b|\bau fond\b|^honnêtement", None),
    ("warning", "« ou » qui couvre plusieurs cas", r", ou (ton|ta|tes|ton dernier|ta dernière)\b", None),
    ("warning", "citation entre guillemets", r"«", None),
    ("error", "mot écrit", r"inavouable|abîm|langoureu|ébats|émoi|charnel|sulfureu|torride", None),
]


def resolve(text):
    """Renders the template with sample names and the first agreement form."""
    text = text.replace("{player}", "Hugo").replace("{target}", "Léa")
    return re.sub(r"\{[ptx]:([^{}|]+)\|[^{}|]+\}", r"\1", text)


def normalized(text):
    """Folds a card to lowercase ASCII words for duplicate detection."""
    text = unicodedata.normalize("NFD", resolve(text).lower())
    text = "".join(c for c in text if unicodedata.category(c) != "Mn")
    return re.sub(r"[^a-z0-9 ]", "", text).strip()


def scope_matches(scope, card):
    """Tells whether a rule scope (kinds or levels) covers this card."""
    return scope is None or card.get("kind") in scope or card.get("level") in scope


def schema_issues(card):
    """Lists the format errors of one card, per its kind."""
    issues = []
    kind, text, target = card.get("kind"), card.get("text", ""), card.get("target")
    audience = card.get("audience", "friends")
    if kind not in LIMITS:
        return [f"type inconnu {kind!r}"]
    if card.get("level") not in SIPS:
        issues.append("niveau inconnu")
    elif card.get("sips") not in SIPS[card["level"]]:
        issues.append(f"tises {card.get('sips')} hors plage")
    if audience not in KINDS_BY_AUDIENCE or kind not in KINDS_BY_AUDIENCE[audience]:
        issues.append(f"type {kind} interdit pour le public {audience}")
    if card.get("player") not in ("any", "male", "female") or target not in TARGETS:
        issues.append("player ou target inconnu")
    if re.search(r"[{}]", TOKEN.sub("", text)):
        issues.append("jeton mal formé")
    if (target != "none") != ("{target}" in text):
        issues.append("champ target et jeton {target} en désaccord")
    if "{t:" in text and target not in ("any", "opposite", "same"):
        issues.append("{t:} demande une cible any, opposite ou same")
    if "{x:" in text and kind != "ten":
        issues.append("{x:} réservé à C'est un 10")
    if audience == "couple" and target in ("opposite", "same"):
        issues.append("une carte couple n'utilise jamais opposite ou same")
    if "’" in text:
        issues.append("apostrophe courbe")
    issues += kind_issues(kind, card, text, target)
    count = len(resolve(text).split())
    if count > LIMITS[kind] or count < 2:
        issues.append(f"{count} mots, plafond {LIMITS[kind]}")
    return issues


def kind_issues(kind, card, text, target):
    """Lists the errors specific to one kind of card."""
    issues = []
    ending = text.rstrip()[-1:]
    if kind == "statement":
        if not resolve(text)[:1].islower() or ending in ".!?" or "{p:" in text or "{t:" in text:
            issues.append("Je n'ai jamais : minuscule, sans ponctuation finale, sans accord")
        if target not in ("none", "any") or card.get("player") != "any":
            issues.append("Je n'ai jamais : player any, target none ou any")
    elif kind == "truth" and ending != "?" and not re.match(r"(Raconte|Décris|Pose|Cite|Dis|Donne|Nomme|Classe|Avoue)\b", resolve(text)):
        issues.append("une Vérité finit par ?, sauf une consigne (Raconte, Décris, Cite…)")
    elif kind == "dare" and ending == "?":
        issues.append("une Action ne finit pas par ?")
    elif kind == "ask" and "{player}" not in text:
        issues.append("une carte ask nomme {player}")
    elif kind == "vote" and (not text.startswith("Levez la main si") or "{p:" in text or "{player}" in text):
        issues.append("un vote commence par « Levez la main si », sans {player} ni {p:}")
    elif kind == "point" and (not text.startswith(("À trois, pointez", "Votez tous pour")) or TOKEN.search(text)):
        issues.append("un pointage commence par « À trois, pointez » ou « Votez tous pour », sans jeton")
    elif kind == "ten":
        if card.get("score") != 10 and card.get("score") not in range(2, 7):
            issues.append("score : 10, ou 2 à 6 en mode inverse")
        if not resolve(text)[:1].islower() or ending in ".!?…":
            issues.append("C'est un 10 : minuscule, sans ponctuation finale")
    return issues


def style_issues(card):
    """Lists the charter violations a script can detect, with their severity."""
    issues = []
    text = card.get("text", "")
    for severity, label, pattern, scope in RULES:
        if scope_matches(scope, card) and re.search(pattern, text, re.I):
            issues.append((severity, label))
    if CRUDE.search(text):
        severity = "error" if "{target}" in text or " ici" in text or card.get("level") != "hot" else "warning"
        issues.append((severity, "mot cru"))
    return issues


def quota_issues(cards):
    """Checks the per-lot ceilings: sextos and crude words."""
    hot = [c for c in cards if c.get("level") == "hot"]
    ceiling = max(1, len(hot) // 50)
    issues = []
    for label, pattern in (("sextos", SEXTO), ("mots crus", CRUDE)):
        count = sum(1 for c in hot if pattern.search(c.get("text", "")))
        if count > ceiling:
            issues.append(f"{count} cartes Hot avec des {label}, plafond {ceiling}")
    work = sum(1 for c in cards if WORK.search(c.get("text", "")))
    if work > max(1, len(cards) // 50):
        issues.append(f"{work} cartes sur le boulot, plafond {max(1, len(cards) // 50)}")
    dares = [c for c in cards if c.get("kind") == "dare"]
    on_phone = sum(1 for c in dares if PHONE.search(c.get("text", "")))
    if dares and on_phone > 0.4 * len(dares):
        issues.append(f"{on_phone} Actions sur {len(dares)} passent par le téléphone, plafond 40 %")
    return issues


def lint(paths, show_warnings):
    """Lints every card of the given files and returns the number of errors."""
    errors, warnings, seen = 0, 0, {}
    every = []
    for path in paths:
        cards = json.load(open(path, encoding="utf-8"))
        every += cards
        for index, card in enumerate(cards):
            where = f"{path.split('/')[-1]}#{index} « {resolve(card.get('text', ''))[:70]} »"
            found = [("error", issue) for issue in schema_issues(card)] + style_issues(card)
            key = normalized(card.get("text", ""))
            if key in seen:
                found.append(("error", f"doublon de {seen[key]}"))
            seen.setdefault(key, where)
            for severity, issue in found:
                if severity == "error":
                    errors += 1
                    print(f"ERREUR  {where} : {issue}")
                else:
                    warnings += 1
                    if show_warnings:
                        print(f"ATTENTION {where} : {issue}")
    for issue in quota_issues(every):
        errors += 1
        print(f"ERREUR  quota : {issue}")
    print(f"{len(every)} cartes, {errors} erreurs, {warnings} points à relire")
    return errors


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Checks Tise cards against the format and the writing charter.")
    parser.add_argument("files", nargs="+")
    parser.add_argument("--warnings", action="store_true", help="also print the points to review")
    arguments = parser.parse_args()
    sys.exit(1 if lint(arguments.files, arguments.warnings) else 0)
