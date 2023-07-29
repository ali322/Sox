export const mergeSettings = (
  server: Record<string, any>,
  settings: Record<string, any>,
  resDir: string
) => {
  let route = Object.assign({}, server.route, {
    geoip: {
      path: `${resDir}etc/geoip.db`
    },
    geosite: {
      path: `${resDir}etc/geosite.db`
    },
  })
  let inbound = {
    "type": "mixed",
    "tag": "mixed-in",
    "listen": "::",
    "listen_port": settings.mixedPort,
    "sniff": true
  }
  let next = Object.assign({}, server, {
    inbounds: [inbound],
    route
  })
  return next
}