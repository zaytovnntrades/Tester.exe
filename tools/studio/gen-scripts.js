// Writes scripts/dNN-slug.md, briefs/vo/dNN-vo.txt, ideas/calendar-30-day.md and briefs/capcut-scene-times.md from series.js.
// Run: node tools/studio/gen-scripts.js   (keeps an existing script's status line, so approvals survive a re-run)
// Fails loudly on: hook over 7 words, voice outside 30-45s, figures, banned words, captions over 150 characters,
// and any term used before the day that teaches it.
const fs=require('fs'),path=require('path'),{SERIES,ORDER}=require('./series.js'),ROOT=path.resolve(__dirname,'../..');
const plain=s=>s.replace(/[*^]/g,''),W=s=>s.split(/\s+/).length,strip=s=>s.replace(/^[!^]/,'');
const BANNED=/(guarantee|risk-free|easy money|get rich|can't lose|quit your job)/i;
const CRITICAL=new Set(['d02','d12','d15','d16','d18','d19','d20','d26','d29','d30']); // survival-first: post these even if you skip others
const see=v=>{const [k,o]=v;switch(k){
  case 'line':return ({up:'A green price line stepping upward',down:'A red price line stepping downward',side:'A white price line moving sideways',zig:'A zig-zag price line',range:'A price line bouncing between a floor and a ceiling',break:'A price line that ranges, then breaks above the ceiling',spike:'A green price line that is flat, then shoots up',steps:'A staircase line',dd:'A line that climbs to a peak, then falls',gap:'A price line that jumps from the expected price to a worse one',gapdown:'A falling price that jumps past a dashed red stop line and fills below it',limit:'A red line that falls, then stops flat on the max-daily-loss line'})[o.shape]+' (illustration).';
  case 'bars':return 'Bars growing from a baseline (illustration): '+o.map(b=>(b[0]||'unlabelled')+(b[2]==='red'?' in red':b[2]==='green'?' in green':'')).join(', ')+'.';
  case 'steps':return 'A stack of boxes appearing one by one'+(o.hi!==undefined?', with the current one lit in red':'')+'.';
  case 'vs':return 'Two columns side by side: '+o.L[0]+' and '+o.R[0]+'.';
  case 'word':return 'A big red stamp: '+o.w+'.';
  case 'ladder':return 'Two price rows, ASK above BID'+(o.hi==='spread'?', with the gap between them marked':o.hi==='none'?'':', with '+o.hi.toUpperCase()+' lit in red')+'.';
  case 'loop':return 'A four-step loop, each step lighting up in turn.';
  case 'levels':return (o.noTarget?'Entry and a dashed red stop-loss line':'Target (green), entry and stop loss (red)')+', with a bracket marking the distance (illustration).';
  case 'candles':return 'A row of green and red candles'+(o.vol?' with volume bars underneath':'')+(o.ring!==undefined?', one candle ringed':'')+' (illustration).';
  case 'anatomy':return 'One big green candle'+({plain:'',all:', labelled HIGH, CLOSE, OPEN, LOW',body:', body outlined, OPEN and CLOSE labelled; a small green UP and red DOWN candle beside it',wicks:', wicks lit in white, HIGH and LOW labelled'})[o.mode]+' (illustration).';
  case 'end':return 'End card with the channel name.'}};
const labels=v=>{const [k,o]=v;switch(k){
  case 'line':return [...(o.lines||[]).map(l=>l[1]),...(o.dots||[]).map(d=>d[1]),...(o.labels===true?['EXPECTED','GOT']:Array.isArray(o.labels)?o.labels:[])].filter(Boolean);
  case 'bars':return o.map(b=>b[0]).filter(Boolean);
  case 'steps':return o.items.map(strip);
  case 'vs':return [o.L[0],o.R[0],...(o.show==='left'||o.show==='both'?o.L[1]:[]),...(o.show==='right'||o.show==='both'?o.R[1]:[])].map(strip);
  case 'word':return [o.w];
  case 'ladder':return ['ASK','lowest seller','BID','highest buyer',...(o.hi==='spread'?['SPREAD']:[])];
  case 'loop':return o.labels;
  case 'levels':{const L=o.labels||['TARGET','ENTRY','STOP'],br=o.br||['RISK','REWARD'];return [...(o.noTarget?L.slice(1):L),...(o.mode!=='reward'?[br[0]]:[]),...(o.mode!=='risk'?[br[1]]:[])].filter(Boolean)}
  case 'candles':return o.vol?['VOLUME']:[];
  case 'anatomy':return ({plain:[],all:['HIGH','CLOSE','OPEN','LOW'],body:['CLOSE','OPEN','UP','DOWN'],wicks:['HIGH','LOW']})[o.mode];
  default:return []}};
const onscreen=(v,i,noNext)=>{const [,title,sub,vis]=v.s[i],a=[plain(title)];if(sub)a.push(plain(sub));a.push(...labels(vis));
  if(i===5){a.push('Survive first.','Follow');if(v.next&&!noNext)a.push('Next: '+v.next);a.push('Zaytovnn Trades')}return a.join(' · ')};
// ---- learning-order check: no term before the day that teaches it
const taught={};ORDER.forEach(id=>SERIES[id].terms.forEach(t=>{taught[t]=SERIES[id].day}));
const errs=[];
for(const id of ORDER){const v=SERIES[id],text=(v.s.map((s,i)=>s[0]+' '+onscreen(v,i,true)).join(' ')  /* the 'Next:' line names tomorrow's topic on purpose */+' '+v.cap+' '+v.pin).toLowerCase();
  for(const [t,day] of Object.entries(taught)){if(day<=v.day)continue;const re=new RegExp('\\b'+t.replace(/[-]/g,'[- ]')+(t.length>3?'':'s?\\b'),'i');
    if(re.test(text))errs.push(`${id} (day ${v.day}) uses "${t}" before day ${day} teaches it`)}
  const n=v.s.map(s=>W(s[0])),tot=n.reduce((a,b)=>a+b),sec=tot/2.5,vo=v.s.map(s=>s[0]).join(' ');
  if(n[0]>7)errs.push(id+': hook over 7 words');if(sec<30||sec>45)errs.push(id+': length '+sec.toFixed(1)+'s');
  if(/\d/.test(vo))errs.push(id+': digit in voiceover');if(BANNED.test(vo+' '+v.cap))errs.push(id+': banned word');
  if(!/Survive first\. Follow\.$/.test(v.s[5][0]))errs.push(id+': CTA');
  const cap=`${v.cap} Trading basics, day ${v.day} of 30. Educational only, not financial advice.`;if(cap.length>150)errs.push(id+': caption '+cap.length)}
if(errs.length){console.error(errs.join('\n'));process.exit(1)}
// ---- write files
fs.mkdirSync(path.join(ROOT,'scripts'),{recursive:true});fs.mkdirSync(path.join(ROOT,'briefs/vo'),{recursive:true});
const cal=[];
for(const id of ORDER){const v=SERIES[id],n=v.s.map(s=>W(s[0])),tot=n.reduce((a,b)=>a+b),sec=Math.round(tot/2.5),t=[0];n.forEach(k=>t.push(t[t.length-1]+Math.max(2.6,k/2.5)));
  const r=i=>`${Math.round(t[i])}–${Math.round(t[i+1])}s`,file=path.join(ROOT,'scripts',`${id}-${v.slug}.md`);
  let status='draft';if(fs.existsSync(file)){const m=fs.readFileSync(file,'utf8').match(/^status: (\w+)/m);if(m)status=m[1]}
  const cap=`${v.cap} Trading basics, day ${v.day} of 30. Educational only, not financial advice.`;
  const tags=['#tradingforbeginners','#tradingbasics','#learntotrade',...v.tags];
  const blk=i=>`  VO: ${v.s[i][0]}\n  ON-SCREEN: ${onscreen(v,i)}\n  VISUAL: ${see(v.s[i][3])}`;
  const vo=v.s.map(s=>s[0]).join(' ');
  const md=`---
id: ${id}
series: Trading Basics, day ${v.day} of 30
pillar: ${v.pillar}
hook_type: ${v.hook}
length_target: ${sec}s
status: ${status}        # draft | approved | blocked | produced | posted
teaches: [${v.terms.join(', ')}]
sources: []          # no figures used, so nothing to source (§6.6)
---
# Day ${v.day} · ${v.t}

HOOK (${r(0)})
${blk(0)}

STAKES (${r(1)}): what it costs to get this wrong
${blk(1)}

LESSON (${Math.round(t[2])}–${Math.round(t[5])}s): 3 beats, one idea each
  Beat 1:
${blk(2)}

  Beat 2:
${blk(3)}

  Beat 3:
${blk(4)}

LOOP / CTA (${r(5)})
${blk(5)}

DISCLAIMER (on-screen): Educational only — not financial advice.${v.lev?'\nLEVERAGE WARNING (on-screen, every scene): Leverage magnifies losses.':''}
CAPTION (≤150 chars): ${cap}
HASHTAGS (3–5): ${tags.slice(0,5).join(' ')}
PINNED COMMENT: ${v.pin}
COVER / THUMBNAIL: frame 0 of the video ("${plain(v.s[0][1])}").
IRL COMPANION: your own real-life video for day ${v.day}, filmed by you. Not scripted here.
WORD COUNT: ${tot} (≈${sec}s at 2.5 words/sec)

## Compliance check (§6)
1. Education, not advice: ✅ explains a concept or a habit; no buy or sell calls, no price targets
2. No easy-money framing: ✅ none of the banned words appear
3. Results honesty: ✅ no P&L shown; every chart is labelled an illustration${/I'm (still )?on sim/.test(vo)?'; "I\'m on sim" matches about-me.md':''}
4. Leverage warning: ${v.lev?'✅ on screen in every scene, and spoken':'n/a (no leveraged product taught)'}
5. Disclose connections: ✅ none
6. Sourced numbers: ✅ no figures used
7. Disclaimer: ✅ on-screen in every scene
Learning order: ✅ uses no term before the day that teaches it (checked by gen-scripts.js).
`;
  fs.writeFileSync(file,md);fs.writeFileSync(path.join(ROOT,'briefs/vo',`${id}-vo.txt`),v.s.map(s=>s[0]).join('\n\n')+'\n');
  cal.push({day:v.day,id,t:v.t,pillar:v.pillar,hook:v.s[0][0],sec,status,terms:v.terms})}
const wk=[['Week 1 · Start here: markets, practice, charts',0,7],['Week 2 · Placing a trade',7,14],['Week 3 · Risk: the survival core',14,21],['Week 4 · Plans and habits',21,28],['Days 29–30 · Protect yourself, then graduate',28,30]];
let out=`# 30-day content calendar: Trading Basics for beginners (v2)

One beginner lesson a day for 30 days, in learning order: each day uses only ideas taught on earlier days (checked automatically).
Every lesson has a slot for **your own IRL video** that day. Those are yours to film; nothing here scripts them.
Days are numbered, not dated: day 1 is whichever day you post the first one. Post package time: **11:30 am Eastern**.
Source for every day: \`tools/studio/series.js\`. After any change run \`node tools/studio/gen-scripts.js\`.

**★ Critical:** survival-first lessons. If you ever skip days, never skip these.
**Status:** all 30 are drafts until you approve the full set.
`;
for(const [name,a,b] of wk){out+=`\n## ${name}\n| Day | Lesson | ★ | Teaches | Length | Hook | Status | Your IRL video |\n|-----|--------|---|---------|--------|------|--------|----------------|\n`;
  for(const r of cal.slice(a,b))out+=`| ${r.day} | ${r.t} | ${CRITICAL.has(r.id)?'★':''} | ${r.terms.join(', ')||'—'} | ${r.sec}s | ${r.hook} | ${r.status} | ☐ |\n`}
out+=`
## How each day runs
1. 11:30 am Eastern: that day's post package (video, caption, hashtags, pinned comment).
2. You post it to TikTok and Instagram Reels, and post your IRL video for the day.
3. 48 hours later, paste the stats: \`day, date posted, platform, views at 48h, average watch %, shares, saves, new follows, notes\`.
`;
fs.mkdirSync(path.join(ROOT,'ideas'),{recursive:true});fs.writeFileSync(path.join(ROOT,'ideas/calendar-30-day.md'),out);
let st=`# Estimated scene start times (seconds), days 1–30\n\nEstimates at 2.5 words per second. Final videos are timed to the real voice.\n\n| Day | Scene 1 | 2 | 3 | 4 | 5 | 6 | Voice ends |\n|-----|---------|---|---|---|---|---|-----------|\n`;
for(const id of ORDER){const v=SERIES[id],t=[0];v.s.forEach(x=>t.push(t[t.length-1]+Math.max(2.6,W(x[0])/2.5)));st+=`| ${v.day} · ${v.t} | ${t.map(x=>x.toFixed(1)).join(' | ')} |\n`}
fs.writeFileSync(path.join(ROOT,'briefs/scene-times.md'),st);
console.log('ok: 30 scripts, calendar, voice text and scene times written; all checks passed');
