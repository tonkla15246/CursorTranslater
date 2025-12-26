import sys
import requests

text = sys.argv[1]

url = "https://translate.googleapis.com/translate_a/single"
params = {
    "client": "gtx",
    "sl": "auto",
    "tl": "th",  # target language
    "dt": "t",
    "q": text
}

res = requests.get(url, params=params)
data = res.json()

translated = "".join(item[0] for item in data[0])

with open("result.txt", "w", encoding="utf-8") as f:
    f.write(translated)
