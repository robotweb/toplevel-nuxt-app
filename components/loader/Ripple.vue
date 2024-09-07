<template>
    <div style="position: absolute; height: 100%; width: 100%; background: rgba(255,255,255,0.9); border-radius: 20px; top: 0px; left: 0px; z-index: 9999; display: flex; justify-content: center; align-items: center;">
      <div style="width: 200px;">
        <svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 200 200'><circle fill='none' stroke-opacity='1' stroke='#0596E4' stroke-width='.5' cx='100' cy='100' r='0'><animate attributeName='r' calcMode='spline' dur='2' values='1;80' keyTimes='0;1' keySplines='0 .2 .5 1' repeatCount='indefinite'></animate><animate attributeName='stroke-width' calcMode='spline' dur='2' values='0;25' keyTimes='0;1' keySplines='0 .2 .5 1' repeatCount='indefinite'></animate><animate attributeName='stroke-opacity' calcMode='spline' dur='2' values='1;0' keyTimes='0;1' keySplines='0 .2 .5 1' repeatCount='indefinite'></animate></circle></svg>
      </div>
    </div>
  </template>