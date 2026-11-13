// Shared drawing kit for the silent drafts (videos 001 and 004). 1080x1920, black / white / one red.
const W=1080,H=1920,c=document.getElementById('c'),x=c.getContext('2d');
const BG='#0a0a0c',WH='#f5f5f5',RED='#ff2d3d',GRN='#22c55e',GR='#8a8a92',DIM='#5a5a64'; // chart colours: green = up/gain, red = down/loss
const F="'Inter','DejaVu Sans','Liberation Sans',Arial,sans-serif",CX=510,MAXW=860,ON={a:1,sc:1};
const clamp=(v,a=0,b=1)=>Math.max(a,Math.min(b,v)),p=(t,a,b)=>clamp((t-a)/(b-a)),eo=u=>1-Math.pow(1-u,3),lerp=(a,b,u)=>a+(b-a)*u;
const hash=n=>{const s=Math.sin(n*127.1)*43758.5453;return s-Math.floor(s)};
let ABS=1; // absolute video time, set every frame by render()
const ap=(t,t0)=>ABS<0.3&&t0<=0.15?ON:({a:p(t,t0,t0+0.1),sc:lerp(1.22,1,eo(p(t,t0,t0+0.22)))}); // frame 0 is the cover
function rich(parts,X,Y,size,A=ON,o={}){if(A.a<=0)return;x.save();const w=o.w??900;let tot;
  for(;;){x.font=`${w} ${size}px ${F}`;tot=parts.reduce((s,q)=>s+x.measureText(q[0]).width,0);if(tot<=(o.max??MAXW))break;size*=0.96}
  x.globalAlpha*=A.a;x.translate(X,Y);x.scale(A.sc,A.sc);x.textBaseline='middle';x.textAlign='left';let cx=o.al==='left'?0:-tot/2;
  for(const [s,col] of parts){x.fillStyle=col;x.fillText(s,cx,0);cx+=x.measureText(s).width}x.restore()}
const txt=(s,X,Y,size,col=WH,A,o)=>rich([[s,col]],X,Y,size,A,o);
function line(x1,y1,x2,y2,col,w){x.strokeStyle=col;x.lineWidth=w;x.lineCap='round';x.beginPath();x.moveTo(x1,y1);x.lineTo(x2,y2);x.stroke()}
function rr(X,Y,w,h,r){x.beginPath();x.roundRect(X,Y,w,h,r)}
function dot(X,Y,r,col){x.fillStyle=col;x.beginPath();x.arc(X,Y,r,0,7);x.fill()}
function drawPath(pts,frac,col,w){frac=clamp(frac);if(frac<=0)return pts[0];const f=frac*(pts.length-1),n=Math.floor(f),r=f-n;
  x.strokeStyle=col;x.lineWidth=w;x.lineJoin='round';x.lineCap='round';x.beginPath();x.moveTo(pts[0][0],pts[0][1]);
  for(let i=1;i<=n;i++)x.lineTo(pts[i][0],pts[i][1]);let e=pts[n];
  if(n<pts.length-1){e=[lerp(pts[n][0],pts[n+1][0],r),lerp(pts[n][1],pts[n+1][1],r)];x.lineTo(e[0],e[1])}x.stroke();return e}
function pill(s,X,Y,size,col,A=ON,fill=false){if(A.a<=0)return;x.save();x.font=`800 ${size}px ${F}`;const w=x.measureText(s).width+size*1.3,h=size*1.9;
  x.globalAlpha=A.a;if(fill){x.fillStyle=col;rr(X-w/2,Y-h/2,w,h,h/2);x.fill()}else{x.strokeStyle=col;x.lineWidth=4;rr(X-w/2,Y-h/2,w,h,h/2);x.stroke()}
  x.restore();txt(s,X,Y+2,size,fill?BG:col,A,{w:800})}
function simBadge(X,Y,u,t0){if(u<t0)return;const s=lerp(2.2,1,eo(p(u,t0,t0+0.2)));x.save();x.translate(X,Y);x.rotate(-0.2);x.scale(s,s);x.globalAlpha=p(u,t0,t0+0.1);
  x.fillStyle=BG;rr(-100,-52,200,104,16);x.fill();x.strokeStyle=RED;x.lineWidth=8;rr(-100,-52,200,104,16);x.stroke();txt('SIM',0,2,62,RED);x.restore()}
function flag(X,Y,h){line(X,Y,X,Y+h,WH,7);x.fillStyle=RED;x.beginPath();x.moveTo(X+4,Y);x.lineTo(X+h*0.75,Y+h*0.27);x.lineTo(X+4,Y+h*0.54);x.closePath();x.fill()}
// Falling account line: flat from x0 to xf at y0, then a jagged drop to (x1,y1).
function fallPts(x0,y0,xf,x1,y1,seed=0){const a=[];for(let X=x0;X<=xf;X+=30)a.push([X,y0+(hash(X+seed)-.5)*14]);
  for(let k=1;k<=12;k++){const u=k/12;a.push([lerp(xf,x1,u),k===12?y1:lerp(y0,y1,Math.pow(u,1.5))+(hash(k+50+seed)-.5)*30])}return a}

// ---- extras for the Trading Basics series (005-007)
function ohlc(X,yH,yTop,yBot,yL,w,col,wick){line(X,yH,X,yL,wick||col,Math.max(4,w*0.09));x.fillStyle=col;x.fillRect(X-w/2,yTop,w,yBot-yTop)}
function lab(s,x1,y,x2,A=ON,col=WH,size=44){if(A.a<=0)return;x.save();x.globalAlpha=A.a;line(x1,y,x2-16,y,col,4);dot(x1,y,8,col);x.restore();txt(s,x2,y+2,size,col,A,{al:'left',max:300})}
function candle(X,cy,w,h,up,col){x.fillStyle=col;const top=up?cy-h:cy;line(X,top-h*0.28,X,top+h+h*0.28,col,Math.max(3,w*0.09));x.fillRect(X-w/2,top,w,h)}
function warn(Y){x.fillStyle=RED;rr(CX-430,Y,860,116,22);x.fill();x.fillStyle=BG;x.beginPath();x.moveTo(108,Y+87);x.lineTo(144,Y+25);x.lineTo(180,Y+87);x.closePath();x.fill();
  txt('!',144,Y+67,40,RED);txt('LEVERAGE MAGNIFIES LOSSES',CX+50,Y+60,46,BG,ON,{max:660})}
function dash(x1,y,x2,col,w=7){x.save();x.setLineDash([22,16]);line(x1,y,x2,y,col,w);x.restore()}
function box(s,X,Y,w,h,col,A=ON,fill=false){if(A.a<=0)return;x.save();x.globalAlpha=A.a;if(fill){x.fillStyle=col;rr(X-w/2,Y-h/2,w,h,18);x.fill()}else{x.strokeStyle=col;x.lineWidth=7;rr(X-w/2,Y-h/2,w,h,18);x.stroke()}x.restore();txt(s,X,Y+2,Math.min(60,h*0.5),fill?BG:col,A,{max:w-40})}
const ILL=(y=1165)=>txt('illustration',CX,y,28,DIM,ON,{w:600});
function endCard(u,tS,tF,tC,yS=1000,next=''){if(next)txt(next,CX,yS+245,40,GR,ap(u,tF+0.3),{w:800});txt('Survive first.',CX,yS,100,RED,ap(u,tS));pill('Follow',CX,yS+130,46,WH,ap(u,tF),true);txt('Zaytovnn Trades',CX,1292,60,WH,ap(u,tC))}
// setup(): captions (2-4 words, key word red, spread evenly over each scene's voice time) + frame wrapper.
function setup({DUR,VO,KEY,scenes,capEnd}){const CAPS=[];
  // URL options: ?clean = no burned-in captions (CapCut adds them). ?d=5.1,4.3,... = seconds per scene, taken from the real voiceover.
  const QS=new URLSearchParams(location.search),CLEAN=QS.has('clean'),S=scenes.map(q=>q[0]),E=S.slice(1).concat([capEnd]);
  const N=QS.get('d')?QS.get('d').split(',').map(Number):E.map((e,i)=>e-S[i]);if(N.length!==S.length||N.some(v=>!(v>0)))throw new Error('d needs '+S.length+' positive numbers');
  const NS=[];N.reduce((acc,v,i)=>(NS[i]=acc,acc+v),0);const NEND=NS[NS.length-1]+N[N.length-1],TAIL=DUR-capEnd;
  const warp=t=>{if(t>=NEND)return capEnd+(t-NEND);let i=0;while(i<NS.length-1&&t>=NS[i+1])i++;return S[i]+(t-NS[i])*(E[i]-S[i])/N[i]};
  for(const [a,b,s] of VO){const sents=s.split(/(?<=[.?!:])\s+/),n=s.split(/\s+/).length,d=(b-a-0.2)/n;let i=0;
    for(const se of sents){const ws=se.split(/\s+/),k=Math.ceil(ws.length/4),per=Math.ceil(ws.length/k);
      for(let j=0;j<ws.length;j+=per)CAPS.push([a+0.1+(i+j)*d,ws.slice(j,j+per)]);i+=ws.length}}
  function captions(t){let cur=null;for(const q of CAPS)if(q[0]<=t)cur=q;if(!cur||t>capEnd)return;
    const parts=cur[1].map((w,i)=>[(i?' ':'')+w,KEY.test(w)?RED:WH]);x.font=`900 62px ${F}`;
    const tw=Math.min(MAXW,parts.reduce((s,q)=>s+x.measureText(q[0]).width,0));
    x.fillStyle='rgba(0,0,0,.72)';rr(CX-tw/2-34,1290-58,tw+68,116,26);x.fill();
    rich(parts,CX,1292,62,{a:1,sc:lerp(1.08,1,eo(p(t,cur[0],cur[0]+0.12)))})}
  const OUT=NEND+TAIL;window.DUR=OUT;window.render=tt=>{const t=warp(tt);ABS=tt;x.setTransform(1,0,0,1,0,0);x.globalAlpha=1;x.fillStyle=BG;x.fillRect(0,0,W,H);
    let f=scenes[0][1],t0=0;for(const [a,fn] of scenes)if(t>=a){f=fn;t0=a}f(t-t0);if(!CLEAN)captions(t);
    txt('Educational only — not financial advice.',CX,1455,30,GR,ON,{w:600});x.fillStyle=RED;x.fillRect(0,1914,W*tt/OUT,6)};window.render(0)}
