import React, {useEffect, useRef, useState} from 'react';
import {AbsoluteFill, Audio, continueRender, delayRender, staticFile, useCurrentFrame, useVideoConfig} from 'remotion';
import {C, FONT, SAFE} from './brand';

// One lesson (d01-d30) with the free voice. Visuals: the same drawing code as tools/studio/basics.html (one source),
// drawn on a transparent canvas over a Remotion background. Timing: every scene is as long as its voice (voice/dNN.json).
export type LessonProps = {id: string; captions: boolean};
type Sent = {text: string; start: number; end: number};
type Timing = {total: number; scenes: {start: number; dur: number; sentences: Sent[]}[]};
export const HOLD = 1.2; // end card holds after the last word
export const loadTiming = async (id: string): Promise<Timing> => (await fetch(staticFile(`voice/${id}.json`))).json();

// ---- background: near-black, soft neutral glow, slow-drifting grid, vignette, grain
const Background: React.FC = () => {
  const f = useCurrentFrame();
  return (
    <AbsoluteFill style={{background: C.bg}}>
      <AbsoluteFill style={{background: `radial-gradient(900px 700px at 50% ${38 + Math.sin(f / 90) * 3}%, rgba(255,255,255,0.05), rgba(10,10,12,0) 70%)`}} />
      <AbsoluteFill style={{backgroundImage: 'linear-gradient(rgba(255,255,255,0.035) 2px, transparent 2px), linear-gradient(90deg, rgba(255,255,255,0.035) 2px, transparent 2px)', backgroundSize: '90px 90px', backgroundPosition: `0 ${(f * 0.6) % 90}px`, maskImage: 'radial-gradient(closest-side at 50% 45%, black, transparent)'}} />
      <AbsoluteFill style={{background: 'radial-gradient(ellipse at 50% 45%, transparent 55%, rgba(0,0,0,0.65) 100%)'}} />
      <svg width={1080} height={1920} style={{position: 'absolute', inset: 0, opacity: 0.06, mixBlendMode: 'overlay'}}>
        <filter id="n"><feTurbulence type="fractalNoise" baseFrequency="0.9" numOctaves={2} seed={f % 7} /></filter>
        <rect width="100%" height="100%" filter="url(#n)" />
      </svg>
    </AbsoluteFill>
  );
};

// ---- the shared drawing code, run against this component's canvas
type Drawer = {render: (t: number) => void; keys: string[][]};
const useDrawer = (id: string, timing: Timing | null, canvas: React.RefObject<HTMLCanvasElement>) => {
  const [d, setD] = useState<Drawer | null>(null);
  const [handle] = useState(() => delayRender('lesson code'));
  useEffect(() => {
    if (!timing || !canvas.current) return;
    Promise.all(['series.js', 'lib.js', 'basics-core.js'].map((f) => fetch(staticFile('lesson/' + f)).then((r) => r.text()))).then(([series, lib, core]) => {
      const durs = timing.scenes.map((s) => s.dur.toFixed(3)).join(',');
      const fakeDoc = {getElementById: () => canvas.current};
      const fakeLoc = {search: `?id=${id}&clean&transparent&d=${durs}`};
      const win: any = {};
      // series.js first (defines SERIES), then lib.js (helpers), then the lesson drawing; all in one scope
      const run = new Function('document', 'location', 'window', 'module', `${series}\n${lib}\n${core}\n;return {render: window.render, SERIES};`);
      const out = run(fakeDoc, fakeLoc, win, undefined);
      // caption key words per scene: *red* and ^green^ words from that scene's headline
      const keys = out.SERIES[id].s.map((s: any[]) => {
        const m = (s[1] as string).match(/\*[^*]+\*|\^[^^]+\^/g) || [];
        return m.flatMap((w) => w.slice(1, -1).toLowerCase().replace(/[^a-z' ]/g, '').split(' ').filter((x) => x.length > 2).map((x) => (w[0] === '^' ? '^' : '*') + x));
      });
      setD({render: out.render, keys});
      continueRender(handle);
    });
  }, [timing, id, canvas, handle]);
  return d;
};

// ---- captions: per sentence (measured), words spread by length inside it; 2-4 words, one line, current word bright
const Captions: React.FC<{timing: Timing; keys: string[][]}> = ({timing, keys}) => {
  const f = useCurrentFrame(), {fps} = useVideoConfig(), t = f / fps;
  let out: React.ReactNode = null;
  timing.scenes.forEach((sc, si) => sc.sentences.forEach((s) => {
    if (t < s.start || t >= s.end + 0.12) return;
    const ws = s.text.split(/\s+/), weight = ws.map((w) => w.length + 2), tot = weight.reduce((a, b) => a + b, 0);
    const at = Math.min(1, (t - s.start) / (s.end - s.start)) * tot;
    let acc = 0, wi = 0; weight.forEach((w, i) => { if (acc <= at) wi = i; acc += w; });
    const chunks: number[][] = []; let cur: number[] = [];
    ws.forEach((w, i) => { const len = cur.reduce((a, j) => a + ws[j].length + 1, 0); if (cur.length && len + w.length > 22) { chunks.push(cur); cur = []; } cur.push(i); if (/[,;:]$/.test(w) || cur.length === 4) { chunks.push(cur); cur = []; } });
    if (cur.length) chunks.push(cur);
    const ch = chunks.find((c) => c.includes(wi))!;
    out = (
      <div style={{position: 'absolute', top: 1300, left: SAFE.left, width: SAFE.right - SAFE.left, display: 'flex', justifyContent: 'center'}}>
        <div style={{background: 'rgba(0,0,0,0.72)', borderRadius: 26, padding: '16px 34px', whiteSpace: 'nowrap'}}>
          {ch.map((i) => {
            const clean = ws[i].toLowerCase().replace(/[^a-z']/g, '');
            const col = keys[si].includes('^' + clean) ? C.green : keys[si].includes('*' + clean) ? C.red : C.white;
            return <span key={i} style={{fontFamily: FONT, fontWeight: 900, fontSize: 62, color: col, opacity: i <= wi ? 1 : 0.45, marginRight: 16, display: 'inline-block', transform: i === wi ? 'scale(1.06)' : 'none'}}>{ws[i]}</span>;
          })}
        </div>
      </div>
    );
  }));
  return <>{out}</>;
};

export const Lesson: React.FC<LessonProps & {timing?: Timing}> = ({id, captions, timing}) => {
  const frame = useCurrentFrame(), {fps} = useVideoConfig();
  const canvas = useRef<HTMLCanvasElement>(null);
  const drawer = useDrawer(id, timing || null, canvas);
  useEffect(() => { if (drawer) drawer.render(frame / fps); }, [drawer, frame, fps]);
  return (
    <AbsoluteFill style={{background: C.bg}}>
      <Background />
      <canvas ref={canvas} width={1080} height={1920} style={{position: 'absolute', inset: 0}} />
      {captions && timing && drawer ? <Captions timing={timing} keys={drawer.keys} /> : null}
      <Audio src={staticFile(`voice/${id}.wav`)} />
    </AbsoluteFill>
  );
};
