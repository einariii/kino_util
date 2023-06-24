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
      scalar_used: {
        type: Number,
        default: 0,
      },
      scalar_total: {
        type: Number,
        default: 0,
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
      getScalar() {
        let used = Math.round(this.scalar_used * 10) / 10;
        let total = Math.round(this.scalar_total * 10) / 10;
        return `${used} / ${total}`;
      },
    },
    template: `
    <div class="flex gap-x-2 items-center">
      <p class="w-24">{{ label }}</p>
      <div class="w-40 bg-white rounded-md border-2 border-black h-5 overflow-hidden">
        <div class="h-full" :style="{ width: percent + '%', backgroundColor: calcColor(percent) }"></div>
      </div>
      <div class="flex-shrink-0 flex justify-start items-center ml-3">
        <p class="w-12 text-left">{{ percent }}%</p>
        <p v-if="scalar_used !=0" class="w-32 text-left">{{ getScalar() }} GB</p>
      </div>
    </div>
    `,
  };

  const app = Vue.createApp({
    components: { UtilBar },
    data() {
      return {
        fields: Vue.reactive(payload.fields),
        show_gpu: Vue.ref(false),
      };
    },
    methods: {},
    template: `
    <div class="app">
      <div class="container">
        <div class="header">
          <img src="./images/laptop_emoji.png" width="20" height="20" />
          <img src="./images/bar_chart_emoji.png" width="20" height="20" />
          <p>System Utilization</p>
        </div>
        <div class="note">
          <UtilBar label="CPU" :percent="fields.cpu_percent" />
          <UtilBar
            label="Memory"
            :scalar_used="fields.mem_used"
            :scalar_total="fields.mem_total"
            :percent="fields.mem_percent"
          />
          <UtilBar v-if="show_gpu" label="GPU" :percent="fields.gpu_percent" />
          <UtilBar
            v-if="show_gpu"
            label="GPU Memory"
            :scalar_used="fields.gpu_mem_used"
            :scalar_total="fields.gpu_mem_total"
            :percent="fields.gpu_mem_percent"
          />
        </div>
      </div>
    </div>
    `,
  }).mount(ctx.root);

  ctx.handleEvent("update", (fields) => {
    console.log("update", app.fields, fields);
    Object.assign(app.fields, fields);
  });

  ctx.handleEvent("show_gpu", (has_gpu) => {
    app.show_gpu = has_gpu;
  });
}
