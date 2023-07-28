<template>
  <div class="h-full">
    <div
      class="h-full bg-black text-left text-sm text-white font-sans"
    >
      <div id="term" class="h-full"></div>
    </div>
  </div>
</template>
<script setup lang="ts">
import useServerStore from '@/store/server'
import { onMounted, watch } from 'vue'
import { Terminal } from 'xterm'
import { FitAddon } from 'xterm-addon-fit'
import { CanvasAddon } from 'xterm-addon-canvas'
import 'xterm/css/xterm.css'

const store = useServerStore()
let lines: string[] = []

onMounted(() => {
  const term = new Terminal({
    fontSize: 12,
    fontFamily: 'monaco'
  })
  const fitAddon = new FitAddon()
  term.loadAddon(fitAddon)
  term.open(document.getElementById('term') as HTMLElement)
  fitAddon.fit()
  term.loadAddon(new CanvasAddon())
  store.output.forEach((line: string) => {
    lines.push(line)
    term.writeln(line)
  })
  watch(() => store.output, (curr: string[]) => {
    console.log('curr', curr, lines.length)
    if (curr.length === 0 ) {
      term.clear()
      lines = []
    } else { 
      curr.slice(lines.length).forEach((line) => {
        lines.push(line)
        term.writeln(line)
      })
    }
  })
})
</script>