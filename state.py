import json
import time
from pathlib import Path

STATE_FILE = Path("seen_skus.json")
PRUNE_AFTER_SECONDS = 7 * 24 * 3600


def load_seen() -> set[str]:
    if not STATE_FILE.exists():
        return set()
    data: dict[str, float] = json.loads(STATE_FILE.read_text())
    cutoff = time.time() - PRUNE_AFTER_SECONDS
    return {sku for sku, ts in data.items() if ts > cutoff}


def save_seen(skus: set[str], existing: dict[str, float] | None = None) -> None:
    now = time.time()
    cutoff = now - PRUNE_AFTER_SECONDS
    base: dict[str, float] = {}
    if STATE_FILE.exists():
        base = json.loads(STATE_FILE.read_text())
    base = {sku: ts for sku, ts in base.items() if ts > cutoff}
    for sku in skus:
        if sku not in base:
            base[sku] = now
    STATE_FILE.write_text(json.dumps(base))
