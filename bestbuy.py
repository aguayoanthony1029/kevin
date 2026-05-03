import time
import requests
import config

BASE_URL = "https://api.bestbuy.com/v1/products"
FIELDS = "sku,name,regularPrice,salePrice,percentSavings,dollarSavings,url,image"


def fetch_deals() -> list[dict]:
    threshold = config.DISCOUNT_THRESHOLD
    params = {
        "format": "json",
        "show": FIELDS,
        "pageSize": config.PAGE_SIZE,
        "apiKey": config.BESTBUY_API_KEY,
    }
    query = f"(percentSavings>={threshold}&onSale=true&onlineAvailability=true)"
    url = f"{BASE_URL}{query}"

    deals = []
    page = 1

    while True:
        params["page"] = page
        try:
            resp = requests.get(url, params=params, timeout=15)
        except requests.RequestException as e:
            print(f"[bestbuy] Request error: {e}")
            break

        if resp.status_code == 429:
            print("[bestbuy] Rate limited, sleeping 60s...")
            time.sleep(60)
            continue

        if not resp.ok:
            print(f"[bestbuy] HTTP {resp.status_code}: {resp.text[:200]}")
            break

        data = resp.json()
        products = data.get("products", [])
        deals.extend(products)

        total_pages = data.get("totalPages", 1)
        if page >= total_pages:
            break
        page += 1

    return deals
