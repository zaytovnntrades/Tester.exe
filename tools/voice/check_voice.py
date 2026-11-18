"""Transcribe each lesson's voice with a free local model (faster-whisper) and compare it word for word with the script.
Usage: python tools/voice/check_voice.py d01 ...  (no ids = every lesson that has a voice file). Exit 1 on any mismatch."""
import json, os, re, subprocess, sys, difflib
import numpy as np
os.environ.setdefault('HF_HUB_DISABLE_XET', '1')
from faster_whisper import WhisperModel
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(os.path.dirname(HERE)); VD = os.path.join(ROOT, 'tools/reel/public/voice')
NUM = {'one': '1', 'two': '2', 'three': '3', 'four': '4', 'five': '5', 'first': '1st'}
norm = lambda s: [NUM.get(w, w) for w in re.sub(r"[^a-z0-9' ]", ' ', s.lower().replace('’', "'").replace('-', ' ')).split()]
data = json.loads(subprocess.check_output(['node', '-e', "const {SERIES,ORDER}=require('./tools/studio/series.js');console.log(JSON.stringify(Object.fromEntries(ORDER.map(id=>[id,SERIES[id].s.map(s=>s[0]).join(' ')]))))"], cwd=ROOT))
ids = sys.argv[1:] or sorted(f[:-4] for f in os.listdir(VD) if f.endswith('.wav'))
m = WhisperModel('small.en', device='cpu', compute_type='int8'); bad = 0
for id in ids:
    pcm = subprocess.run(['ffmpeg', '-loglevel', 'error', '-i', os.path.join(VD, id + '.wav'), '-ac', '1', '-ar', '16000', '-f', 'f32le', '-'], capture_output=True, check=True).stdout
    segs, _ = m.transcribe(np.frombuffer(pcm, dtype=np.float32), beam_size=5, initial_prompt='Trading lesson: bid, ask, spread, wicks, sim, FOMO, pip, tick, drawdown, overtrading.')
    heard, want = norm(' '.join(s.text for s in segs)), norm(data[id])
    sm = difflib.SequenceMatcher(None, want, heard); diffs = [(op, ' '.join(want[a:b]), ' '.join(heard[c:d])) for op, a, b, c, d in sm.get_opcodes() if op != 'equal']
    print(f"{id}: {'OK' if not diffs else str(len(diffs)) + ' difference(s)'} ({sm.ratio():.3f})")
    for op, w, h in diffs: print(f'   script: "{w}"   heard: "{h}"')
    bad += bool(diffs)
sys.exit(1 if bad else 0)
