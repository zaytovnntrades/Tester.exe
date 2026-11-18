"""Download the free Kokoro voice model (Apache-2.0) into tools/voice/models. Run once per machine.
Needs these hosts allowed: huggingface.co, us.aws.cdn.hf.co (the Tester.exe cloud environment has them)."""
import os, numpy as np
os.environ.setdefault('HF_HUB_DISABLE_XET', '1')  # plain HTTPS download, no extra hosts
from huggingface_hub import hf_hub_download
HERE = os.path.dirname(os.path.abspath(__file__)); OUT = os.path.join(HERE, 'models')
REPO = 'onnx-community/Kokoro-82M-v1.0-ONNX'
VOICES = ['am_onyx', 'am_fenrir', 'am_michael', 'bm_george']
hf_hub_download(REPO, 'onnx/model.onnx', local_dir=OUT)
np.savez(os.path.join(OUT, 'voices.npz'), **{v: np.fromfile(hf_hub_download(REPO, f'voices/{v}.bin', local_dir=OUT), dtype=np.float32).reshape(-1, 1, 256) for v in VOICES})
print('model ready in', OUT)
