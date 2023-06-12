export function init(ctx, payload) {
  ctx.importCSS("main.css");
  // ctx.importJS("alpine.js");
  // ctx.importJS("https://unpkg.com/alpinejs@3.10.5/dist/cdn.min.js");

  ctx.root.innerHTML = `
    <div class="app">
        <h1>Hello there</h1>
        <div>CPU UTIL: <output id="cpu_util"></output></div>
        <div>MEM USED: <output id="mem_used"></output></div>
        <div>MEM UTIL: <output id="mem_util"></output></div>
    </div>
  `;

  const cpuUtilEl = document.getElementById("cpu_util");
  cpuUtilEl.value = payload.fields.cpuUtil;

  const memUsedEl = document.getElementById("mem_used");
  memUsedEl.value = payload.fields.memUsed;

  const memUtilEl = document.getElementById("mem_util");
  memUtilEl.value = payload.fields.memUtil;

  ctx.handleEvent("update", (values) => {
    cpuUtilEl.value = values[0];
    memUsedEl.value = values[1];
    memUtilEl.value = values[2];
  });

  // // Used for event listeners if used
  // ctx.handleSync(() => {
  //   // Synchronously invokes change listeners
  //   document.activeElement &&
  //     document.activeElement.dispatchEvent(new Event("change"));
  // });
}
