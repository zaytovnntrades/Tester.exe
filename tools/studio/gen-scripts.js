// Writes scripts/NNN-slug.md, briefs/vo/NNN-vo.txt and ideas/calendar-30-day.md from series.js.
// Run: node tools/studio/gen-scripts.js   (keeps an existing script's status line, so approvals survive a re-run)
const fs=require('fs'),path=require('path'),{SERIES,ORDER}=require('./series.js'),ROOT=path.resolve(__dirname,'../..');
const plain=s=>s.replace(/\*/g,''),W=s=>s.split(/\s+/).length;
const see=v=>{const [k,o]=v;switch(k){
  case 'line':return ({up:'A price line stepping upward',down:'A price line stepping downward',side:'A price line moving sideways',zig:'A zig-zag price line',range:'A price line bouncing between a floor and a ceiling',break:'A price line that ranges, then breaks above the ceiling',spike:'A price line that is flat, then shoots up',steps:'A staircase line',dd:'A line that climbs to a peak, then falls',gap:'A price line that jumps straight from one level to a worse one (a buy that fills higher)'})[o.shape]+' (illustration).';
  case 'bars':return 'Bars growing from a baseline (illustration): '+o.map(b=>(b[0]||'unlabelled')+(b[2]==='red'?' in red':'')).join(', ')+'.';
  case 'steps':return 'A stack of boxes appearing one by one'+(o.hi!==undefined?', with the current one lit in red':'')+'.';
  case 'vs':return 'Two columns side by side: '+o.L[0]+' and '+o.R[0]+'.';
  case 'word':return 'A big red stamp: '+o.w+'.';
  case 'ladder':return 'Two price rows, ASK above BID'+(o.hi==='spread'?', with the gap between them marked':o.hi==='none'?'':', with '+o.hi.toUpperCase()+' lit in red')+'.';
  case 'loop':return 'A four-step loop, each step lighting up in turn.';
  case 'levels':return 'Three horizontal levels with a bracket marking the distance between them (illustration).';
  case 'candles':return 'A row of candles with volume bars underneath (illustration).';
  case 'end':return 'End card with the channel name.'}};
const labels=v=>{const [k,o]=v;switch(k){
  case 'line':return [...(o.lines||[]).map(l=>l[1]),...(o.dots||[]).map(d=>d[1]),...(o.labels?['EXPECTED','GOT']:[])].filter(Boolean);
  case 'bars':return o.map(b=>b[0]).filter(Boolean);
  case 'steps':return o.items.map(s=>s.replace(/^!/,''));
  case 'vs':return [o.L[0],o.R[0],...(o.show==='left'||o.show==='both'?o.L[1]:[]),...(o.show==='right'||o.show==='both'?o.R[1]:[])].map(s=>s.replace(/^!/,''));
  case 'word':return [o.w];
  case 'ladder':return ['ASK','lowest seller','BID','highest buyer',...(o.hi==='spread'?['SPREAD']:[])];
  case 'loop':return o.labels;
  case 'levels':return [...(o.labels||['TARGET','ENTRY','STOP']),...(o.mode==='both'?(o.br||['RISK','REWARD']):o.mode==='risk'?[(o.br||['RISK'])[0]]:[(o.br||['RISK','REWARD'])[1]])];
  case 'candles':return ['VOLUME'];default:return []}};
// Critical = survival-first ideas: if you can only post some days, post these first.
const CRITICAL=new Set(['006','007','004','001','015','016','019','024','028','031']);
const cal=[];
for(const id of ORDER){const v=SERIES[id],n=v.s.map(s=>W(s[0])),tot=n.reduce((a,b)=>a+b),sec=Math.round(tot/2.5),t=[0];
  if(n[0]>7)throw new Error(id+': hook over 7 words (3-second rule)');if(sec<30||sec>45)throw new Error(id+': length '+sec+'s, outside 30-45s');n.forEach(k=>t.push(t[t.length-1]+Math.max(2.6,k/2.5)));
  const r=i=>`${Math.round(t[i])}–${Math.round(t[i+1])}s`,file=path.join(ROOT,'scripts',`${id}-${v.slug}.md`);
  let status='draft';if(fs.existsSync(file)){const m=fs.readFileSync(file,'utf8').match(/^status: (\w+)/m);if(m)status=m[1]}
  const cap=`${v.cap} Trading basics, day ${v.day} of 30. Educational only, not financial advice.`;if(cap.length>150)throw new Error(id+' caption too long');
  const tags=['#tradingforbeginners','#tradingbasics','#learntotrade',...v.tags],used=[...new Set(v.s.map(s=>s[3][0]))].some(k=>['line','bars','levels','candles'].includes(k));
  const on=i=>{const [,title,sub,vis]=v.s[i],a=[plain(title)];if(sub)a.push(sub);a.push(...labels(vis));if(i===5){a.push('Survive first.','Follow');if(v.next)a.push('Next: '+v.next);a.push('Zaytovnn Trades')}return a.join(' · ')};
  const blk=(i,pad='  ')=>`${pad}VO: ${v.s[i][0]}\n${pad}ON-SCREEN: ${on(i)}\n${pad}VISUAL: ${see(v.s[i][3])}`;
  const md=`---
id: ${id}
series: Trading Basics, day ${v.day} of 30
pillar: ${v.pillar}
hook_type: ${v.hook}
length_target: ${sec}s
status: ${status}        # draft | approved | blocked | produced | posted
sources: []          # no figures used, so nothing to source (§6.6)
---
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
HASHTAGS (3–5): ${tags.join(' ')}
PINNED COMMENT: ${v.pin}
COVER / THUMBNAIL: "${plain(v.s[0][1])}" in white and red on a dark background, with the hook's graphic.
WORD COUNT: ${tot} (≈${sec}s at 2.5 words/sec)

## Compliance check (§6)
1. Education, not advice: ✅ explains a concept or a habit; no buy or sell calls, no price targets
2. No easy-money framing: ✅ none of the banned words appear
3. Results honesty: ✅ no P&L shown${used?'; every chart and bar is labelled an illustration':''}${/I'm (still )?on sim/.test(v.s.map(s=>s[0]).join(' '))?'; "I\'m on sim" matches about-me.md':''}
4. Leverage warning: ${v.lev?'✅ on screen in every scene'+(/leverage/i.test(v.s.map(s=>s[0]).join(' '))?', and spoken in the voiceover':''):'n/a (no futures, forex or prop instruction)'}
5. Disclose connections: ✅ none${id==='029'?'. No prop firm is named, shown or recommended.':''}
6. Sourced numbers: ✅ no figures used
7. Disclaimer: ✅ on-screen in every scene
Built from \`tools/studio/series.js\`: this script and its video come from the same data, so they cannot differ.
`;
  fs.writeFileSync(file,md);fs.mkdirSync(path.join(ROOT,'briefs/vo'),{recursive:true});fs.writeFileSync(path.join(ROOT,'briefs/vo',`${id}-vo.txt`),v.s.map(s=>s[0]).join('\n\n')+'\n');
  cal.push([v.day,id,v.t,v.pillar,v.s[0][0],sec,status])}
const first=[[1,'005','How to read a candle',2,"You'll see this shape on almost every trading chart. Can you read it?",36],[2,'006','What a stop loss is',1,'Every trade needs an exit before it needs an entry.',32],[3,'007','What leverage is',2,"A small account can control a big trade. That's the danger.",31],[4,'004','Max daily loss',1,'One bad day can end your account. One number can stop it.',34],[5,'001','3 red flags from a $130M fraud case',1,'Two words helped take a hundred and thirty million dollars from everyday investors.',38],[6,'002','Why Fed day is for trading smaller',2,"October twenty-eighth. The Fed did nothing. That's the kind of day that hurts beginners.",38]]
 .map(r=>{const f=fs.readdirSync(path.join(ROOT,'scripts')).find(x=>x.startsWith(r[1]));return [...r,fs.readFileSync(path.join(ROOT,'scripts',f),'utf8').match(/^status: (\w+)/m)[1]]});
const all=[...first,...cal],wk=['Week 1 · Foundations','Week 2 · Chart reading, orders and direction','Week 3 · Risk, and the futures basics','Week 4 · Sessions, mindset and habits'];
let out=`# 30-day content calendar: Trading Basics for beginners

One video a day for 30 days. Every video teaches one beginner idea in 25 to 45 seconds.
Days are numbered, not dated: day 1 is whichever day you post the first video.
Days 7 to 30 are generated from \`tools/studio/series.js\`; re-run \`node tools/studio/gen-scripts.js\` after any change.

**★ Critical:** the survival-first ideas. If you can only post some days, post the ★ ones first. Posting order stays as listed, because each end card names the next day's video.\n**Hooks:** days 7 to 30 open in 7 words or fewer (under 3 seconds). Days 1 to 6 keep their approved hooks, which run 4 to 5 seconds.\n**Status key:** approved = you signed it off · draft = written, waiting for your approval. Every video has a clean (no-caption) render ready for CapCut.
`;
all.forEach((r,i)=>{if(i%7===0&&i<28)out+=`\n## ${wk[i/7]}\n| Day | Video | Critical | Topic | Pillar | Length | Status | Hook |\n|-----|-------|----------|-------|--------|--------|--------|------|\n`;
  if(i===28)out+=`\n## Days 29 and 30 · Wrap-up\n| Day | Video | Critical | Topic | Pillar | Length | Status | Hook |\n|-----|-------|----------|-------|--------|--------|--------|------|\n`;
  out+=`| ${r[0]} | ${r[1]} | ${CRITICAL.has(r[1])?'★':''} | ${r[2]} | ${r[3]} | ${r[5]}s | ${r[6]} | ${r[4]} |\n`});
const pc={};all.forEach(r=>pc[r[3]]=(pc[r[3]]||0)+1);
out+=`
## Things to know
- **Day 6 (video 002) has a shelf life.** It refers to the October 28, 2026 Fed decision. The Fed's own calendar lists the next meeting as **December 8–9, 2026** (\`research/raw/fed-fomc-calendar-2026-11-13.md\`, read 2026-11-13). So day 6 must be posted by **December 7**, which means day 1 must go out by **December 2**. If that's missed, skip day 6, move every later day up by one, and re-post your best performer on day 30.
- **Days 1 to 6 are the hand-built videos.** Their end cards already point to each other (005 → 006 → 007 → 004, then 001 → 002), which is why they open the calendar in that order.
- **Days 7 to 30 each end on a "Next:" line** naming the following day's topic. If you change the order, change it in \`series.js\` and re-render, or the end cards will point to the wrong video.
- **Pillar mix:** ${Object.keys(pc).sort().map(k=>`pillar ${k}: ${pc[k]} videos`).join(' · ')}. Forex (pillar 3) and prop firms (pillar 4) are light on purpose: you don't trade them, so they're taught from general knowledge only, with no figures.
- **No video uses a figure** except day 5 (SEC case) and day 6 (Fed decision), whose numbers trace to \`research/2026-11-11.md\`.

## After each post
Wait 48 hours, then paste one line per video and I'll add it to \`published/log.csv\`:
\`id, date posted, platform, views at 48h, average watch %, shares, saves, new follows, notes\`
After 10 rows I'll work out which pillars and hook types win and re-rank what comes next.
`;
fs.writeFileSync(path.join(ROOT,'ideas/calendar-30-day.md'),out);
// scene start times for CapCut (days 7-30)
let st=`# Scene start times, videos 008 to 031 (seconds)\n\nFor the quick CapCut route in \`briefs/capcut-handoff.md\`. Each video holds its end card for about 1.2 seconds after the voice ends.\nRebuild any clean video: \`node tools/studio/render.js tools/studio/basics.html renders/clean/008-clean.mp4 "id=008&clean"\`\nRe-time it to your voice clips: \`"id=008&clean&d=4.8,3.1,6.0,4.2,5.5,5.0"\` (six clip lengths, in order).\n\n| Video | Scene 1 | 2 | 3 | 4 | 5 | 6 | Voice ends |\n|-------|---------|---|---|---|---|---|-----------|\n`;
for(const id of ORDER){const v=SERIES[id],t=[0];v.s.forEach(x=>t.push(t[t.length-1]+Math.max(2.6,W(x[0])/2.5)));st+=`| ${id} · ${v.t} | ${t.map(x=>x.toFixed(1)).join(' | ')} |\n`}
fs.writeFileSync(path.join(ROOT,'briefs/capcut-scene-times-008-031.md'),st);console.log('scripts:',ORDER.length,'calendar days:',all.length);
