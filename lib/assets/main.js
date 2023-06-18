import * as Vue from "https://cdn.jsdelivr.net/npm/vue@3.2.26/dist/vue.esm-browser.prod.js";

export function init(ctx, payload) {
  ctx.importCSS("output.css");

  const UtilBar = {
    name: "UtilBar",

    props: {
      label: {
        type: String,
        default: "",
      },
      percent: {
        type: Number,
        default: 0,
      },
      thresholds: {
        type: Array,
        default: () => [50, 80],
      },
      colors: {
        type: Array,
        default: () => [
          // [0, 255, 0], // green
          // [255, 255, 0], // yellow
          // [255, 0, 0], // red
          [152, 195, 121], // utilgreen
          [198, 210, 0], // utilyellow
          [209, 154, 102], // utilorange
        ],
      },
    },

    methods: {
      formatLabel(name, percent) {
        return `${name} ${percent}%`;
      },

      interpolateColor(color1, color2, factor) {
        const result = color1.slice();

        for (let i = 0; i < 3; i++) {
          result[i] = Math.round(result[i] + factor * (color2[i] - color1[i]));
        }

        return result;
      },

      calcColor(percent) {
        let interpolatedColor;

        if (percent <= this.thresholds[0]) {
          let factor = percent / this.thresholds[0];
          interpolatedColor = this.interpolateColor(
            this.colors[0],
            this.colors[1],
            factor
          );
        } else if (percent <= this.thresholds[1]) {
          let factor =
            (percent - this.thresholds[0]) /
            (this.thresholds[1] - this.thresholds[0]);
          interpolatedColor = this.interpolateColor(
            this.colors[1],
            this.colors[2],
            factor
          );
        } else {
          interpolatedColor = this.colors[2];
        }

        return `rgb(${interpolatedColor.join(",")})`;
      },
    },

    template: `
    <div class="flex gap-x-2">
      <div class="flex-shrink-0 w-36 flex justify-between items-center">
        <p class="">{{ label }}</p>
        <p class="">{{ percent }}%</p>
      </div>
      <div class="w-48 bg-white rounded-md border-2 border-black h-5 overflow-hidden">
        <div
          class="h-full"
          :style="{ width: percent + '%', backgroundColor: calcColor(percent) }"
        ></div>
      </div>
    </div>
    `,
  };

  const app = Vue.createApp({
    components: { UtilBar },
    data() {
      return {
        fields: Vue.reactive(payload.fields),
        showGpu: false,
      };
    },
    methods: {},
    template: `
      <div class="app">
        <div class="space-y-2">
          <h1 class="text-xl font-bold">System Utilization</h1>
        <div>
        <UtilBar label="CPU" :percent="fields.cpu_percent" />
        <UtilBar label="Memory" :percent="fields.mem_percent" />
        <UtilBar v-if="showGpu" label="GPU" :percent="fields.gpu_percent" />
        <UtilBar v-if="showGpu" label="GPU Memory" :percent="fields.gpu_mem_percent" />
      </div>
    `,
  }).mount(ctx.root);

  ctx.handleEvent("showGpu", (showGpu) => {
    app.showGpu = showGpu;
  });

  ctx.handleEvent("update", (fields) => {
    Object.assign(app.fields, fields);
  });
}
