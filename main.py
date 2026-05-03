import time
import config
import bestbuy
import discord
from state import load_seen, save_seen


def run():
    print(f"[main] Starting Spooky Deals (threshold: {config.DISCOUNT_THRESHOLD}% off, poll every {config.POLL_INTERVAL}s)")

    while True:
        print("[main] Fetching deals from Best Buy...")
        try:
            deals = bestbuy.fetch_deals()
        except Exception as e:
            print(f"[main] Unexpected error fetching deals: {e}")
            deals = []

        print(f"[main] Found {len(deals)} deal(s) at or above {config.DISCOUNT_THRESHOLD}% off")

        seen = load_seen()
        new_deals = [d for d in deals if str(d.get("sku")) not in seen]
        print(f"[main] {len(new_deals)} new (unseen) deal(s) to alert")

        for product in new_deals:
            sku = str(product.get("sku"))
            name = product.get("name", "?")
            pct = product.get("percentSavings", 0)
            sale = product.get("salePrice", 0)
            print(f"[main] Alerting: {name} — ${sale:.2f} ({pct:.0f}% off)")
            discord.send_deal(product)
            seen.add(sku)
            save_seen(seen)

        print(f"[main] Sleeping {config.POLL_INTERVAL}s until next poll...\n")
        time.sleep(config.POLL_INTERVAL)


if __name__ == "__main__":
    try:
        run()
    except KeyboardInterrupt:
        print("\n[main] Shutting down.")
