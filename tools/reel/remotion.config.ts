import {Config} from '@remotion/cli/config';
import {existsSync} from 'fs';
// In the cloud session, use the browser that's already installed. On your own computer this path won't exist,
// so Remotion falls back to its own browser (it downloads one the first time).
const LOCAL = '/opt/pw-browsers/chromium_headless_shell-1243/chrome-headless-shell-linux64/chrome-headless-shell';
const browser = process.env.REMOTION_BROWSER || (existsSync(LOCAL) ? LOCAL : null);
if (browser) Config.setBrowserExecutable(browser);
Config.setVideoImageFormat('jpeg');
Config.setJpegQuality(92);
Config.setCodec('h264');
Config.setCrf(18);
Config.setPixelFormat('yuv420p');
