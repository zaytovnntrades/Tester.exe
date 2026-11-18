import React from 'react';
import {Composition} from 'remotion';
import {Reel005, reel005Defaults, reel005Duration} from './Reel005';
import {Lesson, LessonProps, loadTiming, HOLD} from './Lesson';

// Lesson: any of the 30 days. Props: {"id":"d01","captions":true}. Needs voice/dNN.wav + .json (tools/voice/make_voice.py).
export const Root: React.FC = () => (
  <>
    <Composition
      id="Lesson" component={Lesson as any} width={1080} height={1920} fps={30}
      defaultProps={{id: 'd01', captions: true} as LessonProps}
      calculateMetadata={async ({props}) => {
        const timing = await loadTiming((props as LessonProps).id);
        return {durationInFrames: Math.round((timing.total + HOLD) * 30), props: {...props, timing}};
      }}
    />
    {/* v1 polished Reel 005, kept for reference */}
    <Composition id="Reel005" component={Reel005} width={1080} height={1920} fps={30} defaultProps={reel005Defaults}
      calculateMetadata={({props}) => ({durationInFrames: reel005Duration(props)})} />
  </>
);
