import time
import requests
import config


def send_deal(product: dict) -> None:
    name = product.get("name", "Unknown Product")[:256]
    regular = product.get("regularPrice", 0)
    sale = product.get("salePrice", 0)
    savings = product.get("dollarSavings", regular - sale)
    pct = product.get("percentSavings", 0)
    url = product.get("url", "https://www.bestbuy.com")
    image = product.get("image", "")

    embed = {
        "title": name,
        "url": url,
        "color": 0x00B300,
        "fields": [
            {"name": "Regular Price", "value": f"${regular:.2f}", "inline": True},
            {"name": "Sale Price", "value": f"${sale:.2f}", "inline": True},
            {"name": "Savings", "value": f"${savings:.2f} ({pct:.0f}% off)", "inline": True},
        ],
        "footer": {"text": "Best Buy Deal Alert"},
    }

    if image:
        embed["thumbnail"] = {"url": image}

    payload = {"embeds": [embed]}

    try:
        resp = requests.post(config.DISCORD_WEBHOOK_URL, json=payload, timeout=10)
        if resp.status_code == 429:
            retry_after = resp.json().get("retry_after", 2)
            print(f"[discord] Rate limited, sleeping {retry_after}s...")
            time.sleep(retry_after)
            requests.post(config.DISCORD_WEBHOOK_URL, json=payload, timeout=10)
        elif not resp.ok:
            print(f"[discord] HTTP {resp.status_code}: {resp.text[:200]}")
    except requests.RequestException as e:
        print(f"[discord] Request error: {e}")

    time.sleep(2)
