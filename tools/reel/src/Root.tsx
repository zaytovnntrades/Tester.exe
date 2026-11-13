import React from 'react';
import {Composition} from 'remotion';
import {Reel005, reel005Defaults, reel005Duration} from './Reel005';

// One composition per Reel. Props:
//   captions: false            -> no burned-in captions (for adding the voice and captions in CapCut)
//   durations: [s1..s6]        -> seconds per scene, from the real voice clips, so every cut lands on the voice
export const Root: React.FC = () => (
  <Composition
    id="Reel005"
    component={Reel005}
    width={1080}
    height={1920}
    fps={30}
    defaultProps={reel005Defaults}
    calculateMetadata={({props}) => ({durationInFrames: reel005Duration(props)})}
  />
);
