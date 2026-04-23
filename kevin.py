"""
Kevin - The Meme Lord, Sports Fanatic, and People Lover Bot
"""

import random
import datetime


# Kevin's personality constants
KEVIN_NAME = "Kevin"
KEVIN_CATCHPHRASES = [
    "LET'S GOOOOO!!!",
    "No cap, that's bussin fr fr",
    "This is giving main character energy",
    "Bro woke up and chose VIOLENCE",
    "We are SO back",
    "It's giving... it's giving...",
    "Not me crying at this W",
    "Sheesh, that hit different",
    "Ratio + L + you fell off",
    "Touch grass challenge: FAILED",
]

MEME_REACTIONS = {
    "happy": ["😂💀", "LMAOOO I'm deceased", "I can't breathe rn 💀💀", "ded. absolutely ded."],
    "hyped": ["LETS GOOO 🔥🔥🔥", "SHEEEESH 🤯", "NO WAY BRO 😤", "IT'S HAPPENING 🚨🚨"],
    "sad": ["F in chat 😔", "Pouring one out rn 🥺", "We don't talk about that", "This is not it chief"],
    "shocked": ["WAIT WHAT?! 😱", "Bro I'm not okay 💀", "The audacity... THE AUDACITY", "Plot twist nobody asked for"],
}

SPORTS = {
    "nfl": {
        "teams": ["Chiefs", "Eagles", "Cowboys", "49ers", "Bills", "Ravens", "Dolphins", "Bengals"],
        "hot_takes": [
            "Patrick Mahomes is literally built different, change my mind 🏈",
            "The Cowboys are ALWAYS 'this is our year' and it's NEVER their year 😂",
            "Bills Mafia is the most unhinged fanbase and I respect every second of it",
            "If your team hasn't won a Super Bowl in 10 years, it's a cope season bro",
        ],
    },
    "nba": {
        "teams": ["Lakers", "Celtics", "Warriors", "Bucks", "Nuggets", "Heat", "Knicks", "Suns"],
        "hot_takes": [
            "Steph Curry shooting from half court is just trolling at this point 🏀",
            "The Knicks will find a way to fumble this, they always do 💀",
            "Load management is just a fancy word for 'nah I'm good today'",
            "Any team with the Lakers losing is an automatic W for me personally",
        ],
    },
    "soccer": {
        "teams": ["Real Madrid", "Barcelona", "Man City", "Liverpool", "PSG", "Bayern", "Juventus", "Arsenal"],
        "hot_takes": [
            "Messi vs Ronaldo debate is just Twitter's way of never letting us rest ⚽",
            "VAR ruined football and I will die on this hill",
            "Arsenal fans have been saying 'this is the year' since 2004 😭",
            "Anyone who does a fake injury flop should get a penalty against them, no notes",
        ],
    },
}

BET_LINES = [
    "Bro put your rent on it, trust me 💀 (jk please don't)",
    "The spread is juicy rn, just saying...",
    "My guy really bet his lunch money and tripled up. Living the dream.",
    "Parlay szn. We stay locked in. We stay broke. It's the culture.",
    "3-leg parlay hits? Generational wealth. Doesn't hit? Never happened.",
    "If you're not betting the underdog you're not living life to the fullest",
    "The house always wins but WHAT IF IT DIDN'T THOUGH",
    "My betting record: 4-47. My confidence level: immaculate.",
]

PEOPLE_LOVE_QUOTES = [
    "Yo you're genuinely one of the realest ones, no cap 🫶",
    "Big fan of you as a person, not gonna lie",
    "We need more people like you in this world fr",
    "You absolute legend, how are you this cool??",
    "Bro/sis you are built different and I mean that in the best way",
    "Not me being lowkey obsessed with how awesome you are 😭",
    "You deserve all the good things, I said what I said",
    "People like you make the group chat worth checking 💯",
]


class Kevin:
    def __init__(self):
        self.name = KEVIN_NAME
        self.mood = "hyped"
        self.favorite_sport = random.choice(list(SPORTS.keys()))
        self.win_streak = 0
        self.loss_streak = 0

    def introduce(self):
        print(f"""
╔══════════════════════════════════════════════════╗
║   YO WHAT IS GOOD, IT'S YOUR BOY {self.KEVIN_NAME_PADDED}      ║
║                                                  ║
║   🏈 Sports analyst (self-appointed)             ║
║   💀 Certified Meme Connoisseur                  ║
║   🎰 Betting expert (results may vary)           ║
║   🫶 Lover of all people (yes, even you)         ║
╚══════════════════════════════════════════════════╝
        """)

    @property
    def KEVIN_NAME_PADDED(self):
        return self.name.upper().ljust(6)

    def react_to_meme(self, vibe="happy"):
        mood = vibe if vibe in MEME_REACTIONS else "happy"
        reaction = random.choice(MEME_REACTIONS[mood])
        catchphrase = random.choice(KEVIN_CATCHPHRASES)
        print(f"Kevin: {reaction}")
        print(f"Kevin: {catchphrase}")

    def sports_hot_take(self, sport=None):
        sport = sport if sport in SPORTS else random.choice(list(SPORTS.keys()))
        take = random.choice(SPORTS[sport]["hot_takes"])
        team = random.choice(SPORTS[sport]["teams"])
        print(f"\n🔥 KEVIN'S HOT TAKE ({sport.upper()}) 🔥")
        print(f"Kevin: {take}")
        print(f"Kevin: Also shoutout {team} fans, y'all are built different 💪")

    def give_bet_advice(self):
        advice = random.choice(BET_LINES)
        print(f"\n🎰 KEVIN'S BETTING CORNER 🎰")
        print(f"Kevin: {advice}")
        print(f"Kevin: (This is NOT financial advice. Please gamble responsibly. Kevin is not liable.)")

    def hype_someone_up(self, name=None):
        person = name if name else "you"
        quote = random.choice(PEOPLE_LOVE_QUOTES)
        print(f"\n💛 KEVIN APPRECIATION POST 💛")
        print(f"Kevin: Hey {person}! {quote}")

    def daily_energy_check(self):
        hour = datetime.datetime.now().hour
        if 5 <= hour < 12:
            energy = "Morning crew rise up ☀️ We're locked in today, no cap"
            self.mood = "hyped"
        elif 12 <= hour < 17:
            energy = "Afternoon check-in 🌤️ We staying focused OR we staying chaotic, pick one"
            self.mood = "happy"
        elif 17 <= hour < 21:
            energy = "PRIME TIME HOURS 🌆 Game's on. Bets are placed. We're in it."
            self.mood = "hyped"
        else:
            energy = "Late night Kevin is activated 🌙 Posting unhinged takes, don't @ me"
            self.mood = "shocked"

        print(f"\n⚡ KEVIN'S DAILY VIBE CHECK ⚡")
        print(f"Kevin: {energy}")

    def generate_parlay(self):
        legs = []
        for _ in range(random.randint(2, 4)):
            sport = random.choice(list(SPORTS.keys()))
            team = random.choice(SPORTS[sport]["teams"])
            bet_type = random.choice(["ML", "spread -3.5", "over 220.5", "first TD scorer", "clean sheet"])
            legs.append(f"  • {team} {bet_type} ({sport.upper()})")

        odds = random.randint(250, 2500)
        print(f"\n🎯 KEVIN'S LOCK OF THE CENTURY PARLAY 🎯")
        print("Legs:")
        for leg in legs:
            print(leg)
        print(f"Payout: +{odds} (trust the process)")
        print("Kevin: This is the one. I can FEEL it. (I said this last time too)")

    def roast_rival_team(self, team_name):
        roasts = [
            f"Oh {team_name}? I think you mean the 'moral victory' specialists 😂",
            f"{team_name} fans really woke up today huh? Brave.",
            f"The {team_name} offense is a work of abstract art. Nobody understands it, including them.",
            f"I respect {team_name}'s commitment to building character through losing 💀",
            f"Shoutout {team_name} for keeping expectations LOW and delivering on that promise EVERY time",
        ]
        print(f"\n🗣️ KEVIN SPEAKS ON {team_name.upper()} 🗣️")
        print(f"Kevin: {random.choice(roasts)}")

    def full_vibe_session(self):
        print("\n" + "="*52)
        print("  WELCOME TO THE KEVIN EXPERIENCE™")
        print("="*52)

        self.introduce()
        self.daily_energy_check()
        self.sports_hot_take()
        self.give_bet_advice()
        self.generate_parlay()
        self.hype_someone_up()
        self.react_to_meme("hyped")

        print("\n" + "="*52)
        print("  Kevin has left the chat. (He'll be back in 5min)")
        print("="*52 + "\n")


if __name__ == "__main__":
    kevin = Kevin()
    kevin.full_vibe_session()
