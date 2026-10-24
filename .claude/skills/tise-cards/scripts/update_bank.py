import argparse
import json
import sys

BANK = "Tise/Features/Game/Data/Resources/prompts.json"
ORDER = ["id", "kind", "level", "audience", "score", "sips", "player", "target", "text"]


def load(path):
    """Reads a JSON array of cards."""
    return json.load(open(path, encoding="utf-8"))


def write_bank(path, cards):
    """Writes the bank one card per line, in the field order of the existing file."""
    lines = ",\n".join("  " + json.dumps({k: c[k] for k in ORDER if k in c}, ensure_ascii=False) for c in cards)
    with open(path, "w", encoding="utf-8") as handle:
        handle.write("[\n" + lines + "\n]\n")


def add(bank, lot, prefix):
    """Appends a lot, numbering its cards after the highest id already using the prefix."""
    taken = [int(c["id"].rsplit("-", 1)[1]) for c in bank if c["id"].startswith(prefix + "-") and c["id"].rsplit("-", 1)[1].isdigit()]
    start = max(taken, default=0) + 1
    return bank + [{"id": f"{prefix}-{start + i:03d}", **{k: v for k, v in card.items() if k != "id"}} for i, card in enumerate(lot)]


def replace(bank, lot):
    """Replaces the cards whose id appears in the lot, keeping their position."""
    by_id = {card["id"]: card for card in lot}
    unknown = set(by_id) - {card["id"] for card in bank}
    if unknown:
        sys.exit(f"ids absents de la banque : {sorted(unknown)}")
    return [by_id.get(card["id"], card) for card in bank]


def remove(bank, ids):
    """Drops the cards with the given ids."""
    missing = set(ids) - {card["id"] for card in bank}
    if missing:
        sys.exit(f"ids absents de la banque : {sorted(missing)}")
    return [card for card in bank if card["id"] not in set(ids)]


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Adds, replaces or removes cards in the Tise card bank.")
    parser.add_argument("--bank", default=BANK)
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--add", metavar="LOT")
    group.add_argument("--replace", metavar="LOT")
    group.add_argument("--remove", metavar="IDS_FILE", help="a JSON array of ids")
    parser.add_argument("--prefix", help="id prefix for --add, e.g. truth-hot-v2")
    arguments = parser.parse_args()
    cards = load(arguments.bank)
    if arguments.add:
        if not arguments.prefix:
            sys.exit("--add demande --prefix")
        updated = add(cards, load(arguments.add), arguments.prefix)
    elif arguments.replace:
        updated = replace(cards, load(arguments.replace))
    else:
        updated = remove(cards, load(arguments.remove))
    write_bank(arguments.bank, updated)
    print(f"{len(cards)} cartes avant, {len(updated)} après")
