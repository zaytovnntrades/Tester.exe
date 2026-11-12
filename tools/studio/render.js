// Usage: node tools/studio/render.js <page.html> <out.mp4> [options]
//   options: clean            -> no burned-in captions (CapCut adds them)
//            d=5.1,4.3,...     -> seconds per scene, from the real voiceover
//            clean&d=5.1,4.3,... -> both
const {chromium}=require('playwright'),{spawn}=require('child_process'),path=require('path');
(async()=>{const [html,out,opts]=process.argv.slice(2),FPS=30;
  const b=await chromium.launch(),pg=await b.newPage({viewport:{width:1080,height:1920},deviceScaleFactor:1});
  pg.on('pageerror',e=>{console.error('PAGE ERROR',e.message);process.exit(1)});
  await pg.goto('file://'+path.resolve(html)+(opts?'?'+opts:''));const dur=await pg.evaluate(()=>window.DUR),n=Math.round(dur*FPS);
  const ff=spawn('ffmpeg',['-y','-loglevel','error','-f','image2pipe','-framerate',FPS,'-c:v','mjpeg','-i','-','-c:v','libx264','-pix_fmt','yuv420p','-crf','18','-movflags','+faststart',out],{stdio:['pipe','inherit','inherit']});
  for(let i=0;i<n;i++){await pg.evaluate(t=>window.render(t),i/FPS);const buf=await pg.screenshot({type:'jpeg',quality:93});
    if(!ff.stdin.write(buf))await new Promise(r=>ff.stdin.once('drain',r))}
  ff.stdin.end();await new Promise(r=>ff.on('close',r));await b.close();console.log(`${n} frames -> ${out}`)})();
