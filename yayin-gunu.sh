#!/bin/bash
# YAYIN GÜNÜ — "sürüm 2 henüz yayımlanmamıştır" cümleleri (4 yer) kaldırılır,
# tarihler yayın gününe çekilir. Sürüm mağazada GÖRÜNDÜKTEN sonra koşulur; öncesinde
# cümleler doğrudur ve KALIR (GO-NO-GO.md madde 2). Kullanım: bash yayin-gunu.sh 2026-09-XX
set -euo pipefail
cd "$(dirname "$0")"
TARIH="${1:?yayın tarihi (YYYY-MM-DD)}"
python3 - "$TARIH" <<'PY'
import sys, re, pathlib, datetime as d
t = d.date.fromisoformat(sys.argv[1])
AY_TR = ["Ocak","Şubat","Mart","Nisan","Mayıs","Haziran","Temmuz","Ağustos","Eylül","Ekim","Kasım","Aralık"]
AY_EN = ["January","February","March","April","May","June","July","August","September","October","November","December"]
tr = f"{t.day} {AY_TR[t.month-1]} {t.year}"; en = f"{t.day} {AY_EN[t.month-1]} {t.year}"
def edit(path, pairs):
    p = pathlib.Path(path); s = p.read_text(encoding="utf-8")
    for old, new in pairs:
        n = len(re.findall(old, s, flags=re.S)); assert n == 1, (path, old[:40], n)
        s = re.sub(old, new, s, flags=re.S)
    p.write_text(s, encoding="utf-8"); print("düzenlendi:", path)
edit("privacy.html", [
    (r" As of the last-updated date above, version 2\s+has not been released\.", ""),
    (r" Yukarıdaki güncelleme tarihi itibarıyla\s+sürüm 2 henüz yayımlanmamıştır\.", ""),
    (r"Last updated: [0-9]+ [A-Za-z]+ 2026", f"Last updated: {en}"),
    (r"Son güncelleme: [0-9]+ [A-Za-zÇŞĞÜÖİçşğüöı]+ 2026", f"Son güncelleme: {tr}"),
])
edit("support.html", [
    (r" As of 3 August 2026, version 2 has not been released\.", ""),
    (r" 3 Ağustos 2026\s+itibarıyla sürüm 2 henüz yayımlanmamıştır\.", ""),
])
PY
echo "kalan yayın-durumu cümlesi:"; grep -n -i "has not been released\|henüz yayımlanma" privacy.html support.html || echo "  (yok) ✅"
echo; echo "Şimdi: git diff'i gözle kontrol et → commit → push → Pages'te önbelleksiz doğrula (GO-NO-GO madde 4)."
