import os
from dotenv import load_dotenv

load_dotenv()

BESTBUY_API_KEY = os.environ["BESTBUY_API_KEY"]
DISCORD_WEBHOOK_URL = os.environ["DISCORD_WEBHOOK_URL"]
DISCOUNT_THRESHOLD = int(os.getenv("DISCOUNT_THRESHOLD", "75"))
POLL_INTERVAL = int(os.getenv("POLL_INTERVAL_SECONDS", "300"))
PAGE_SIZE = 100
