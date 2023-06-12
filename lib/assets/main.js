export function init(ctx, payload) {
  ctx.importCSS("main.css");
  ctx.importJS("alpine_.js");

  ctx.root.innerHTML = `
    <div class="app bg-slate-100">
      <h1 class="font-bold">Hello there</h1>
      <div>CPU UTIL: <output id="cpu_util"></output></div>
      <div>MEM USED: <output id="mem_used"></output></div>
      <div>MEM UTIL: <output id="mem_util"></output></div>
      <br>

      <h1 class="font-bold">AlpineJS Test</h1>
      <div x-data="{ count: 0 }">
        <span x-text="count"></span>
        <button @click="count++">INCR</button>
        <button @click="count = 0">RESET</button>
      </div>
    </div>
  `;

  const cpuUtilEl = document.getElementById("cpu_util");
  cpuUtilEl.value = payload.fields.cpuUtil ? payload.fields.cpuUtil + " %" : "";

  const memUsedEl = document.getElementById("mem_used");
  memUsedEl.value = payload.fields.memUsed
    ? payload.fields.memUsed + " GB"
    : "";

  const memUtilEl = document.getElementById("mem_util");
  memUtilEl.value = payload.fields.memUtil ? payload.fields.memUtil + " %" : "";

  ctx.handleEvent("update", (values) => {
    cpuUtilEl.value = values[0] + "%";
    memUsedEl.value = values[1] + "GB";
    memUtilEl.value = values[2] + "%";
  });

  // // Used for event listeners if used
  // ctx.handleSync(() => {
  //   // Synchronously invokes change listeners
  //   document.activeElement &&
  //     document.activeElement.dispatchEvent(new Event("change"));
  // });
}
