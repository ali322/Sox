<template>
  <div class="py-2 flex-1 flex flex-col">
    <div class="flex px-4 pb-2 pt-2 justify-end items-center">
      <div class="flex-1 text-left flex">
        <label class="mr-6 text-gray-500 w-20">Tag</label>
        <input type="text" spellcheck="false" :disabled="running" v-model="tag"
          class="leading-7 rounded border border-gray-300 text-sm px-2 w-28 disabled:text-gray-500" />
      </div>
      <button class="w-24 h-[30px] flex items-center btn-secondary mr-4" @click="upload">
        <UploadRound class="w-5 h-5"></UploadRound>
        <span class="mx-1 leading-7">upload</span>
      </button> 
      <button class="w-16 h-[30px] flex items-center" :class="running ? 'btn-danger' : 'btn-primary'" @click="run">
        <StopRound class="w-6 h-6" v-if="running"></StopRound>
        <PlayArrowRound class="w-5 h-5" v-else></PlayArrowRound>
        <span class="mx-1 leading-7">{{ running ? 'stop' : 'run' }}</span>
      </button>
    </div>
    <div class="px-4">
      <div class="flex items-center py-2 text-left">
        <label class="mr-6 text-gray-500 w-20 text-sm">Type</label>
        <Select class="rounded w-28" v-model:value="server.type">
          <Option value="vless">vless</Option>
          <Option value="trojan">trojan</Option>
          <Option value="hysteria">hysteria</Option>
          <Option value="shadowtls">shadowtls</Option>
          <Option value="vmess">vmess</Option>
        </Select>
      </div>
    </div>
    <div class="px-4 py-2 flex-1 flex overflow-y-scroll text-left">
      <json-editor class="flex-1" v-model:json="server.data" :readOnly="running"/>
    </div>
    <Toast ref="toastRef" />
  </div>
</template>
<script lang="ts" setup>
import useServerStore from '@/store/server'
import { storeToRefs } from 'pinia'
import { toRefs, ref, computed } from 'vue'
import JsonEditor from 'vue3-ts-jsoneditor'
import { debounce } from 'ts-debounce'
import { path, dialog, tauri, fs } from '@tauri-apps/api'
import { PlayArrowRound, StopRound, UploadRound } from '@vicons/material'
import Toast from '@/components/Toast.vue'
import Select from '@/components/Select.vue'
import Option from '@/components/Option.vue'

interface Props {
  server: Record<string, any>,
  index: number
}
interface Emits {
  (e: 'run'): void,
}
const emit = defineEmits<Emits>()

const props = defineProps<Props>()
const { server, index } = toRefs(props)

const toastRef = ref<InstanceType<typeof Toast>>()
const serverStore = useServerStore()
const { running } = storeToRefs(serverStore)

const run = () => {
  emit('run')
}
const upload = async () => {
  const t = toastRef.value as any
  try {
    const homeDir = await path.homeDir()
    const importFile = await dialog.open({
      defaultPath: await path.join(homeDir)
    })
    if (importFile) {
      const content = await tauri.invoke("import_file", { path: importFile })
      const data = JSON.parse(content as string)
      server.value.data = data
      t.show("import server success")
    }
  } catch (e) {
    t.error(e)
  }
}

const tag = computed({
  get() {
    return server.value.tag
  },
  set(val) {
    server.value.tag = val
    onServerUpdate()
  }
})
const address = computed({
  get() {
    return server.value.address
  },
  set(val) {
    server.value.address = val
    onServerUpdate()
  }
})
const port = computed({
  get() {
    return server.value.port
  },
  set(val) {
    server.value.port = val
    onServerUpdate()
  }
})
const d = debounce(() => {
  serverStore.saveServer({ server: server.value, index: props.index })
}, 300, { isImmediate: false })
const onServerUpdate = () => {
  d()
}
</script>