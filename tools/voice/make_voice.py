"""Free voiceover for the 30 lessons (Kokoro, Apache-2.0, runs offline once the model is downloaded).
Usage: python tools/voice/make_voice.py d01 d02 ...   (no ids = all 30)
Writes tools/reel/public/voice/dNN.wav and dNN.json (exact sentence and scene timings for the Remotion video).
The words come straight from tools/studio/series.js, so they always match the approved script."""
import json, os, re, subprocess, sys
import numpy as np, soundfile as sf
from kokoro_onnx import Kokoro
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(os.path.dirname(HERE))
OUT = os.path.join(ROOT, 'tools/reel/public/voice')
VOICE, SPEED, LANG = 'am_onyx', 0.92, 'en-us'   # one voice for all 30 (approved on the day-1 pilot)
HOOK_SPEED, HOOK_GAP = 1.06, 0.06               # the hook (scene 1) is read a touch quicker and tighter, so it lands in 3 seconds
GAP, SCENE_GAP, LEAD = 0.18, 0.40, 0.15          # pauses (seconds): between sentences, between scenes, before the first word
SR = 24000
data = json.loads(subprocess.check_output(['node', '-e', "const {SERIES,ORDER}=require('./tools/studio/series.js');console.log(JSON.stringify(ORDER.map(id=>({id,vo:SERIES[id].s.map(s=>s[0])}))))"], cwd=ROOT))
ids = sys.argv[1:] or [d['id'] for d in data]
k = Kokoro(os.path.join(HERE, 'models/onnx/model.onnx'), os.path.join(HERE, 'models/voices.npz'))
sil = lambda s: np.zeros(int(round(s * SR)), dtype=np.float32)
def trim(a, thr=0.004):
    idx = np.where(np.abs(a) > thr)[0]
    return a[max(0, idx[0] - 240): idx[-1] + 480] if len(idx) else a
os.makedirs(OUT, exist_ok=True)
FAIL = []
for d in [d for d in data if d['id'] in ids]:
    parts, t, scenes = [sil(LEAD)], LEAD, []
    for si, line in enumerate(d['vo']):
        start, sents = t, []
        for s in [x for x in re.split(r'(?<=[.?!])\s+', line) if x]:
            a, sr = k.create(s, voice=VOICE, speed=HOOK_SPEED if si == 0 else SPEED, lang=LANG); assert sr == SR
            a = trim(a); sents.append({'text': s, 'start': round(t, 3), 'end': round(t + len(a) / SR, 3)})
            g = HOOK_GAP if si == 0 else GAP
            parts.append(a); t += len(a) / SR; parts.append(sil(g)); t += g
        if si < len(d['vo']) - 1: parts.append(sil(SCENE_GAP - g)); t += SCENE_GAP - g
        scenes.append({'start': round(start, 3), 'dur': round(t - start, 3), 'sentences': sents})
    raw = os.path.join(OUT, d['id'] + '.raw.wav'); wav = os.path.join(OUT, d['id'] + '.wav')
    sf.write(raw, np.concatenate(parts), SR)
    subprocess.run(['ffmpeg', '-y', '-loglevel', 'error', '-i', raw, '-af', 'loudnorm=I=-16:TP=-1.5:LRA=7', '-ar', str(SR), wav], check=True); os.remove(raw)
    json.dump({'id': d['id'], 'voice': VOICE, 'speed': SPEED, 'total': round(t, 3), 'scenes': scenes}, open(os.path.join(OUT, d['id'] + '.json'), 'w'), indent=1)
    h = scenes[0]['sentences'][-1]['end'] - scenes[0]['sentences'][0]['start']
    print(d['id'], f'total {t + 1.2:.1f}s (with end card)', f'hook {h:.2f}s')
    if h > 3.0: FAIL.append(f"{d['id']}: hook {h:.2f}s is over 3 seconds")
    if not 30 <= t + 1.2 <= 45: FAIL.append(f"{d['id']}: length {t + 1.2:.1f}s is outside 30-45s")
if FAIL: print('\n'.join(FAIL)); sys.exit(1)
