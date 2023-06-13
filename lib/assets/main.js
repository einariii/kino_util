export function init(ctx, payload) {
  ctx.importCSS("main.css");
  ctx.importCSS("input.css");
  ctx.importJS("alpine_.js");

  ctx.root.innerHTML = `
    <div class="app2">
      <h1 class="celltitle">KINO_UTIL<br>"keep your system in sight"</h1>
      <div class="label2 cpucell">CPU UTIL:<br><output id="cpu_util"></output></div>
      <div class="label2 memcell">MEM USED:<br><output id="mem_used"></output></div>
      <div class="label2 memcell2">MEM UTIL:<br><output id="mem_util"></output></div>
      <div class="label2 gpucell">GPU USED:<br><output id="mem_util"></output></div>
      <div class="label2 gpucell2">GPU UTIL:<br><output id="mem_util"></output></div>
      <br>
    </div>
  `;

  // const cpuWarning = document.getElementById("cpu_warning");
  // var cpucellStyles = document.cpucell.style;

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

    // if (cpuUtilEl.value = values[0] > 50) {
    //   cpuWarning.value.setProperty('--cpuwarning', 'pink');
    // } else {
    //   cpuWarning.value.setProperty('--cpuwarning', '#E06C75');
    // }

    // cpuUtilEl.value = values[0] > 50 ? cpucellStyles.setProperty('--cpuwarning', 'pink') : '#E06C75';
    // cpuUtilEl.value = values[0] > 80 ? cpucellStyles.setProperty('--cpuwarning', 'red') : '#E06C75';

    // memUtilEl.value = values[2] > 50 ? document.documentElement.style.setProperty('--memwarning', 'pink') : '#98C379';
    // memUtilEl.value = values[2] > 80 ? document.documentElement.style.setProperty('--memwarning', 'red') : '#98C379';
  });

  // // Used for event listeners if used
  // ctx.handleSync(() => {
  //   // Synchronously invokes change listeners
  //   document.activeElement &&
  //     document.activeElement.dispatchEvent(new Event("change"));
  // });
}
