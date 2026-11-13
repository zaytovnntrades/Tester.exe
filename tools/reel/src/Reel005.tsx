import React from 'react';
import {AbsoluteFill, Sequence, interpolate, spring, useCurrentFrame, useVideoConfig, Easing} from 'remotion';
import {C, FONT, SAFE, CX} from './brand';

// Reel 005 · How to read a candle (Trading Basics, day 1). Words are the approved script, scripts/005-how-to-read-a-candle.md.
// Every candle is an illustration: no real market data, no prices, no figures.
export const VO = [
  "You'll see this shape on almost every trading chart. Can you read it?",
  "It's called a candle. If you can't read it, you're guessing.",
  'One candle is one slice of time. A minute. An hour. A day. You choose.',
  'The thick part is the body. Where price opened and where it closed. Its colour tells you up or down.',
  'The thin lines are wicks. They show the highest and lowest price in that time.',
  'Four prices. One shape. Open, high, low, close. Learn that before anything else. Survive first. Follow.',
];
const KEY = /^(candle|body|wicks|open|high|low|close|survive|guessing)$/i;
type Props = {captions: boolean; durations: number[]};
const words = (s: string) => s.split(/\s+/);
const estimate = VO.map((s) => Math.max(2.8, words(s).length / 2.5));
export const reel005Defaults: Props = {captions: true, durations: estimate};
const HOLD = 1.2; // end card holds after the voice
export const reel005Duration = (p: Props) => Math.round((p.durations.reduce((a, b) => a + b, 0) + HOLD) * 30);

// ---------- helpers
const T: React.FC<{children: React.ReactNode; size: number; color?: string; weight?: number; style?: React.CSSProperties}> = ({children, size, color = C.white, weight = 900, style}) => (
  <div style={{fontFamily: FONT, fontSize: size, fontWeight: weight, color, lineHeight: 1.08, letterSpacing: -0.5, ...style}}>{children}</div>
);
const Red: React.FC<{children: React.ReactNode}> = ({children}) => <span style={{color: C.red}}>{children}</span>;
// Pop-in used for every headline: lands within ~7 frames, with a little overshoot.
const usePop = (delay = 0) => {
  const f = useCurrentFrame(), {fps} = useVideoConfig();
  const s = spring({frame: f - delay, fps, config: {damping: 14, stiffness: 220, mass: 0.6}});
  return {opacity: interpolate(f - delay, [0, 4], [0, 1], {extrapolateLeft: 'clamp', extrapolateRight: 'clamp'}), transform: `translateY(${(1 - s) * 40}px) scale(${0.92 + 0.08 * s})`};
};
const Head: React.FC<{children: React.ReactNode; y?: number; size?: number; delay?: number; sub?: React.ReactNode; subDelay?: number}> = ({children, y = 250, size = 92, delay = 0, sub, subDelay = 12}) => {
  const a = usePop(delay), b = usePop(subDelay);
  return (
    <div style={{position: 'absolute', top: y, left: SAFE.left, width: SAFE.right - SAFE.left, textAlign: 'center'}}>
      <div style={a}><T size={size}>{children}</T></div>
      {sub ? <div style={{...b, marginTop: 22}}><T size={50} weight={800} color={C.grey}>{sub}</T></div> : null}
    </div>
  );
};

// A candlestick drawn in SVG coordinates. up=true: open at the bottom of the body, close at the top.
const Candle: React.FC<{x: number; high: number; top: number; bottom: number; low: number; w: number; color: string; wick?: string; grow?: number}> = ({x, high, top, bottom, low, w, color, wick, grow = 1}) => {
  const mid = (top + bottom) / 2, k = Math.max(0, Math.min(1, grow));
  const g = (y: number) => mid + (y - mid) * k;
  return (
    <g>
      <line x1={x} x2={x} y1={g(high)} y2={g(low)} stroke={wick || color} strokeWidth={Math.max(5, w * 0.08)} strokeLinecap="round" />
      <rect x={x - w / 2} y={g(top)} width={w} height={Math.max(2, g(bottom) - g(top))} rx={4} fill={color} />
    </g>
  );
};
const Pointer: React.FC<{x1: number; y: number; x2: number; label: string; color?: string; size?: number; progress: number; note?: string}> = ({x1, y, x2, label, color = C.white, size = 50, progress, note}) => {
  const p = Math.max(0, Math.min(1, progress));
  if (p <= 0) return null;
  return (
    <g opacity={Math.min(1, p * 3)}>
      <circle cx={x1} cy={y} r={10} fill={color} />
      <line x1={x1} x2={x1 + (x2 - 18 - x1) * p} y1={y} y2={y} stroke={color} strokeWidth={5} />
      <text x={x2} y={y + size * 0.36} fill={color} fontFamily={FONT} fontWeight={900} fontSize={size}>{label}</text>
      {note ? <text x={x2} y={y + size * 0.36 + 44} fill={C.grey} fontFamily={FONT} fontWeight={700} fontSize={30}>{note}</text> : null}
    </g>
  );
};
const Illustration: React.FC<{y?: number}> = ({y = 1180}) => (
  <div style={{position: 'absolute', top: y, left: SAFE.left, width: SAFE.right - SAFE.left, textAlign: 'center'}}>
    <T size={28} weight={600} color={C.dim}>illustration</T>
  </div>
);
const Stage: React.FC<{children: React.ReactNode}> = ({children}) => (
  <svg width={1080} height={1920} viewBox="0 0 1080 1920" style={{position: 'absolute', inset: 0}}>{children}</svg>
);

// ---------- background: soft red glow, slow-drifting grid, vignette, grain
const Background: React.FC = () => {
  const f = useCurrentFrame();
  const drift = (f * 0.6) % 90;
  return (
    <AbsoluteFill style={{background: C.bg}}>
      <AbsoluteFill style={{background: `radial-gradient(900px 700px at 50% ${38 + Math.sin(f / 90) * 3}%, rgba(255,255,255,0.05), rgba(10,10,12,0) 70%)`}} />
      <AbsoluteFill style={{backgroundImage: 'linear-gradient(rgba(255,255,255,0.035) 2px, transparent 2px), linear-gradient(90deg, rgba(255,255,255,0.035) 2px, transparent 2px)', backgroundSize: '90px 90px', backgroundPosition: `0 ${drift}px`, maskImage: 'radial-gradient(closest-side at 50% 45%, black, transparent)'}} />
      <AbsoluteFill style={{background: 'radial-gradient(ellipse at 50% 45%, transparent 55%, rgba(0,0,0,0.65) 100%)'}} />
      <svg width={1080} height={1920} style={{position: 'absolute', inset: 0, opacity: 0.07, mixBlendMode: 'overlay'}}>
        <filter id="n"><feTurbulence type="fractalNoise" baseFrequency="0.9" numOctaves={2} seed={f % 7} /></filter>
        <rect width="100%" height="100%" filter="url(#n)" />
      </svg>
    </AbsoluteFill>
  );
};

// ---------- scenes (each receives its own length in frames)
const ROW = Array.from({length: 11}, (_, i) => {
  const h = (n: number) => { const s = Math.sin(n * 127.1) * 43758.5453; return s - Math.floor(s); };
  if (i === 6) return {x: 110 + i * 80, top: 690, bottom: 930, up: true}; // the ringed candle: tall and clear
  const o = 860 - i * 14 + (h(i) - 0.5) * 150, c = o + (h(i + 20) - 0.55) * 190;
  return {x: 110 + i * 80, top: Math.min(o, c), bottom: Math.max(o, c, Math.min(o, c) + 12), up: c < o};
});
const S1: React.FC<{d: number}> = ({d}) => {
  const f = useCurrentFrame();
  const ring = interpolate(f, [8, 18], [0, 1], {extrapolateLeft: 'clamp', extrapolateRight: 'clamp'});
  const pulse = 1 + 0.04 * Math.sin(f / 4);
  const q = ROW[6];
  return (
    <>
      {/* frame 0 is the Reel cover: the headline and the chart are already on screen */}
      <div style={{position: 'absolute', top: 250, left: SAFE.left, width: SAFE.right - SAFE.left, textAlign: 'center'}}>
        <T size={74}>On almost every chart.</T>
        <div style={usePop(Math.round(d * 0.62))}><T size={92} style={{marginTop: 18}}><Red>Can you read it?</Red></T></div>
      </div>
      <Stage>
        {ROW.map((c, i) => <Candle key={i} x={c.x} high={c.top - 40} top={c.top} bottom={c.bottom} low={c.bottom + 40} w={46} color={c.up ? C.green : C.red} />)}
        <rect x={q.x - 62} y={q.top - 92} width={124} height={q.bottom - q.top + 184} rx={22} fill="none" stroke={C.red} strokeWidth={7} opacity={ring}
          style={{transformOrigin: `${q.x}px ${(q.top + q.bottom) / 2}px`, transform: `scale(${pulse})`}} />
      </Stage>
      <Illustration />
    </>
  );
};
const BIG = {x: 380, high: 610, top: 730, bottom: 990, low: 1110, w: 170};
const S2: React.FC<{d: number}> = ({d}) => {
  const f = useCurrentFrame(), {fps} = useVideoConfig();
  const z = spring({frame: f, fps, config: {damping: 16, stiffness: 120}});
  return (
    <>
      <Head sub={<>Can't read it? <span style={{color: C.white}}>You're guessing.</span></>} subDelay={Math.round(d * 0.45)}>It's called a <Red>candle.</Red></Head>
      <Stage><g style={{transformOrigin: `${CX}px 860px`, transform: `scale(${0.35 + 0.65 * z})`}}><Candle {...BIG} x={CX} color={C.green} /></g></Stage>
    </>
  );
};
const S3: React.FC<{d: number}> = ({d}) => {
  const f = useCurrentFrame();
  const n = words(VO[2]).length, per = d / n, at = (w: number) => w * per; // word-timed label changes
  const marks: [number, string][] = [[at(7), '1 MINUTE'], [at(9), '1 HOUR'], [at(11), '1 DAY'], [at(13), 'YOU CHOOSE']];
  const cur = marks.filter(([t]) => f >= t).pop();
  const hs = [[70, 150], [120, 60], [60, 190], [150, 90], [90, 130]];
  return (
    <>
      <Head size={74}>1 candle = <Red>1 slice of time</Red></Head>
      <Stage>
        <line x1={110} x2={910} y1={1030} y2={1030} stroke={C.dim} strokeWidth={4} />
        {hs.map(([a, b], i) => {
          const X = 190 + i * 160, top = 900 - a - b, m = i === 2;
          return <g key={i}><line x1={X} x2={X} y1={1020} y2={1042} stroke={C.dim} strokeWidth={4} />
            <Candle x={X} high={top - 40} top={top} bottom={top + b} low={top + b + 50} w={78} color={m ? C.green : '#3a3a44'} grow={interpolate(f, [i * 3, i * 3 + 12], [0, 1], {extrapolateLeft: 'clamp', extrapolateRight: 'clamp'})} /></g>;
        })}
        <path d="M 430 1058 L 430 1082 L 590 1082 L 590 1058" fill="none" stroke={C.red} strokeWidth={7} />
      </Stage>
      {cur ? <div style={{position: 'absolute', top: 1110, left: SAFE.left, width: SAFE.right - SAFE.left, textAlign: 'center'}}><LabelPop text={cur[1]} age={f - cur[0]} /></div> : null}
      <Illustration y={1240} />
    </>
  );
};
const LabelPop: React.FC<{text: string; age: number}> = ({text, age}) => {
  const k = interpolate(age, [0, 6], [1.25, 1], {extrapolateLeft: 'clamp', extrapolateRight: 'clamp', easing: Easing.out(Easing.cubic)});
  return <div style={{transform: `scale(${k})`}}><T size={80}>{text}</T></div>;
};
const S4: React.FC<{d: number}> = ({d}) => {
  const f = useCurrentFrame();
  const n = words(VO[3]).length, per = d / n;
  const split = Math.round(per * 13); // body first, then a hard cut to colour on word 14, "Its colour tells you up or down"
  const p = (w: number) => (f - w * per) / 8;
  if (f < split)
    return (
      <>
        <Head>The <Red>body</Red></Head>
        <Stage>
          <Candle {...BIG} color={C.green} />
          <rect x={BIG.x - 102} y={BIG.top - 12} width={204} height={BIG.bottom - BIG.top + 24} rx={12} fill="none" stroke={C.white} strokeWidth={7} opacity={interpolate(f, [6, 14], [0, 1], {extrapolateLeft: 'clamp', extrapolateRight: 'clamp'})} />
          <text x={BIG.x + 140} y={(BIG.top + BIG.bottom) / 2 + 20} fill={C.white} fontFamily={FONT} fontWeight={900} fontSize={56} opacity={interpolate(f, [8, 14], [0, 1], {extrapolateLeft: 'clamp', extrapolateRight: 'clamp'})}>BODY</text>
          <Pointer x1={BIG.x + 85} y={BIG.bottom} x2={BIG.x + 140} label="OPEN" progress={p(8)} />
          <Pointer x1={BIG.x + 85} y={BIG.top} x2={BIG.x + 140} label="CLOSE" progress={p(11.5)} />
        </Stage>
        <Illustration />
      </>
    );
  return (
    <Sequence from={split} layout="none">
      <Head sub="Colours vary by platform." subDelay={10} size={84}>Colour = <Red>direction</Red></Head>
      <Stage>
        <Candle x={CX - 190} high={640} top={740} bottom={980} low={1060} w={140} color={C.green} />
        <Candle x={CX + 190} high={640} top={740} bottom={980} low={1060} w={140} color={C.red} />
        <text x={CX - 190} y={1140} textAnchor="middle" fill={C.green} fontFamily={FONT} fontWeight={900} fontSize={60}>UP</text>
        <text x={CX + 190} y={1140} textAnchor="middle" fill={C.red} fontFamily={FONT} fontWeight={900} fontSize={60}>DOWN</text>
        <text x={CX - 190} y={1190} textAnchor="middle" fill={C.grey} fontFamily={FONT} fontWeight={700} fontSize={30}>closed higher</text>
        <text x={CX + 190} y={1190} textAnchor="middle" fill={C.grey} fontFamily={FONT} fontWeight={700} fontSize={30}>closed lower</text>
      </Stage>
    </Sequence>
  );
};
const S5: React.FC<{d: number}> = ({d}) => {
  const f = useCurrentFrame();
  const n = words(VO[4]).length, per = d / n, p = (w: number) => (f - w * per) / 8;
  const wickOn = interpolate(f, [4, 12], [0, 1], {extrapolateLeft: 'clamp', extrapolateRight: 'clamp'});
  return (
    <>
      <Head>The <Red>wicks</Red></Head>
      <Stage>
        <Candle {...BIG} color={C.green} wick={wickOn > 0.5 ? C.white : C.green} />
        <Pointer x1={BIG.x} y={BIG.high} x2={BIG.x + 140} label="HIGH" color={C.white} size={60} progress={p(9)} note="highest price in that time" />
        <Pointer x1={BIG.x} y={BIG.low} x2={BIG.x + 140} label="LOW" color={C.white} size={60} progress={p(11)} note="lowest price in that time" />
      </Stage>
      <Illustration />
    </>
  );
};
const S6: React.FC<{d: number}> = ({d}) => {
  const f = useCurrentFrame();
  const n = words(VO[5]).length, per = d / n, p = (w: number) => (f - w * per) / 8;
  const endAt = Math.round(per * 14); // "Survive first. Follow." -> end card
  const c = {x: 300, high: 560, top: 650, bottom: 860, low: 950, w: 130};
  const learn = usePop(Math.round(per * 8));
  return (
    <>
      <Head size={88}>4 prices. <Red>1 shape.</Red></Head>
      {f < endAt ? (
        <>
          <Stage>
            <Candle {...c} color={C.green} />
            <Pointer x1={c.x + 65} y={c.bottom} x2={c.x + 140} label="OPEN" progress={p(4)} />
            <Pointer x1={c.x} y={c.high} x2={c.x + 140} label="HIGH" progress={p(5)} />
            <Pointer x1={c.x} y={c.low} x2={c.x + 140} label="LOW" progress={p(6)} />
            <Pointer x1={c.x + 65} y={c.top} x2={c.x + 140} label="CLOSE" progress={p(7)} />
          </Stage>
          <div style={{position: 'absolute', top: 1060, left: SAFE.left, width: SAFE.right - SAFE.left, textAlign: 'center', ...learn}}>
            <T size={60} weight={800} color={C.grey}>Learn this first.</T>
          </div>
        </>
      ) : (
        <Sequence from={endAt} layout="none"><EndCard /></Sequence>
      )}
    </>
  );
};
const EndCard: React.FC = () => {
  const a = usePop(0), b = usePop(8), c = usePop(14), e = usePop(20);
  return (
    <div style={{position: 'absolute', top: 560, left: SAFE.left, width: SAFE.right - SAFE.left, textAlign: 'center'}}>
      <div style={a}><T size={120}><Red>Survive first.</Red></T></div>
      <div style={{...b, marginTop: 50, display: 'inline-block', background: C.white, borderRadius: 60, padding: '22px 64px'}}><T size={56} color={C.bg}>Follow</T></div>
      <div style={{...c, marginTop: 40}}><T size={44} weight={800} color={C.grey}>Next: Part 2 · The stop loss</T></div>
      <div style={{...e, marginTop: 70}}><T size={64}>Zaytovnn Trades</T></div>
    </div>
  );
};
const SCENES = [S1, S2, S3, S4, S5, S6];

// ---------- captions: 2-4 words at a time, current word bright, key words red. Timed to the scene lengths.
const Captions: React.FC<{durations: number[]}> = ({durations}) => {
  const f = useCurrentFrame(), {fps} = useVideoConfig();
  let start = 0, out: React.ReactNode = null;
  durations.forEach((d, si) => {
    const ws = words(VO[si]), per = (d * fps) / ws.length, t = f - start;
    if (t >= 0 && t < d * fps) {
      const wi = Math.min(ws.length - 1, Math.floor(t / per));
      // chunk by sentence, 2-4 words per chunk
      const chunks: number[][] = []; let cur: number[] = [];
      // a chunk ends at punctuation, at 4 words, or before it would pass 22 characters, so it always fits on one line
      ws.forEach((w, i) => { const len = cur.reduce((a, j) => a + ws[j].length + 1, 0); if (cur.length && len + w.length > 22) { chunks.push(cur); cur = []; } cur.push(i); if (/[.?!,]$/.test(w) || cur.length === 4) { chunks.push(cur); cur = []; } });
      if (cur.length) chunks.push(cur);
      const ch = chunks.find((c) => c.includes(wi))!;
      out = (
        <div style={{position: 'absolute', top: 1300, left: SAFE.left, width: SAFE.right - SAFE.left, display: 'flex', justifyContent: 'center'}}>
          <div style={{background: 'rgba(0,0,0,0.72)', borderRadius: 26, padding: '16px 34px', maxWidth: 880, textAlign: 'center', whiteSpace: 'nowrap'}}>
            {ch.map((i) => {
              const raw = ws[i], clean = raw.replace(/[^A-Za-z']/g, '');
              const col = KEY.test(clean) ? C.red : C.white;
              return <span key={i} style={{fontFamily: FONT, fontWeight: 900, fontSize: 62, color: col, opacity: i <= wi ? 1 : 0.45, marginRight: 16, display: 'inline-block', transform: i === wi ? 'scale(1.06)' : 'none'}}>{raw}</span>;
            })}
          </div>
        </div>
      );
    }
    start += d * fps;
  });
  return <>{out}</>;
};

export const Reel005: React.FC<Props> = ({captions, durations}) => {
  const {fps, durationInFrames} = useVideoConfig();
  const f = useCurrentFrame();
  const starts: number[] = []; durations.reduce((a, d, i) => (starts[i] = a, a + d), 0);
  return (
    <AbsoluteFill style={{background: C.bg}}>
      <Background />
      {SCENES.map((S, i) => {
        const from = Math.round(starts[i] * fps);
        const len = i === 5 ? durationInFrames - from : Math.round(durations[i] * fps);
        return (
          <Sequence key={i} from={from} durationInFrames={len} name={`Scene ${i + 1}`}>
            <AbsoluteFill><S d={Math.round(durations[i] * fps)} /></AbsoluteFill>
          </Sequence>
        );
      })}
      {captions ? <Captions durations={durations} /> : null}
      <div style={{position: 'absolute', top: 1450, left: SAFE.left, width: SAFE.right - SAFE.left, textAlign: 'center'}}>
        <T size={30} weight={600} color={C.grey}>Educational only — not financial advice.</T>
      </div>
      <div style={{position: 'absolute', left: 0, bottom: 0, height: 8, width: `${(f / durationInFrames) * 100}%`, background: C.red}} />
    </AbsoluteFill>
  );
};
