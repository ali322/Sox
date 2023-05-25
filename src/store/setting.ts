import { defineStore } from 'pinia'
import { ref, Ref } from 'vue'

export default defineStore(
  'setting',
  () => {
    const mixedPort = ref(1088)
    const isSysProxyEnabled = ref(false)

    const restoreSetting = () => {
      mixedPort.value = 1088
      isSysProxyEnabled.value = false
    }
    return { mixedPort, isSysProxyEnabled, restoreSetting }
  },
  { persist: true }
)
